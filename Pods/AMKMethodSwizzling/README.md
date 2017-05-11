AMKMethodSwizzling
======
![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)
![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)

GitHub
------
https://github.com/AndyM129/AMKMethodSwizzling


Features
==============
支持类方法与实例方法的替换


Installation
======

### CocoaPods

由于不知道如何让[CocoaPods](http://cocoapods.org)支持，只能先下载到本地再使用了~~

### Manually
将该类添加到项目中，并引入该类的头文件，即可使用。


How To Use It
------

例如替换UIViewController的4个生命周期的方法：

### UIViewController+AMKit.h
```Objective-C
//
//  UIViewController+AMKit.h
//  AMKitLab_5.1
//
//  Created by Andy__M on 15/11/20.
//  Copyright © 2015年 Andy__M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AMKit)
@property(nonatomic, copy, setter=am_setViewWillAppearOrDisappearBlock:) void(^am_viewWillAppearOrDisappearBlock)(UIViewController * viewController, BOOL viewWillAppear); //!< viewWillAppearOrDisappear的回调
@property(nonatomic, copy, setter=am_setViewDidAppearOrDisappearBlock:) void(^am_viewDidAppearOrDisappearBlock)(UIViewController * viewController, BOOL viewDidAppear);   //!< viewDidAppearOrDisappear的回调
@end

```

### UIViewController+AMKit.m

```Objective-C
//
//  UIViewController+AMKit.m
//  AMKitLab_5.1
//
//  Created by Andy__M on 15/11/20.
//  Copyright © 2015年 Andy__M. All rights reserved.
//

#import "UIViewController+AMKit.h"
#import "NSObject+AMKMethodSwizzling.h"

static const void *NSOBJECT_RUNTIME_PROPERTY_KEY_ViewWillAppearOrDisappearBlock = &NSOBJECT_RUNTIME_PROPERTY_KEY_ViewWillAppearOrDisappearBlock;
static const void *NSOBJECT_RUNTIME_PROPERTY_KEY_ViewDidAppearOrDisappearBlock = &NSOBJECT_RUNTIME_PROPERTY_KEY_ViewDidAppearOrDisappearBlock;

@implementation UIViewController (AMKit)

#pragma mark - Init

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController amk_swizzleInstanceMethod:@selector(viewWillAppear:) with:@selector(am_viewWillAppear:)];
        [UIViewController amk_swizzleInstanceMethod:@selector(viewDidAppear:) with:@selector(am_viewDidAppear:)];
        [UIViewController amk_swizzleInstanceMethod:@selector(viewWillDisappear:) with:@selector(am_viewWillDisappear:)];
        [UIViewController amk_swizzleInstanceMethod:@selector(viewDidDisappear:) with:@selector(am_viewDidDisappear:)];
    });
}

#pragma mark - Propertys

- (void (^)(UIViewController * viewController, BOOL viewWillAppear))am_viewWillAppearOrDisappearBlock {
    return objc_getAssociatedObject(self, NSOBJECT_RUNTIME_PROPERTY_KEY_ViewWillAppearOrDisappearBlock);
}

- (void)am_setViewWillAppearOrDisappearBlock:(void (^)(UIViewController * viewController, BOOL viewWillAppear))viewWillAppearOrDisappearBlock {
    objc_setAssociatedObject(self, NSOBJECT_RUNTIME_PROPERTY_KEY_ViewWillAppearOrDisappearBlock, viewWillAppearOrDisappearBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIViewController * viewController, BOOL viewDidAppear))am_viewDidAppearOrDisappearBlock {
    return objc_getAssociatedObject(self, NSOBJECT_RUNTIME_PROPERTY_KEY_ViewDidAppearOrDisappearBlock);
}

- (void)am_setViewDidAppearOrDisappearBlock:(void (^)(UIViewController * viewController, BOOL viewDidAppear))viewDidAppearOrDisappearBlock {
    objc_setAssociatedObject(self, NSOBJECT_RUNTIME_PROPERTY_KEY_ViewDidAppearOrDisappearBlock, viewDidAppearOrDisappearBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Life Circle

-(void)am_viewWillAppear:(BOOL)animated {
    [self am_viewWillAppear:animated];
    if (self.am_viewWillAppearOrDisappearBlock) self.am_viewWillAppearOrDisappearBlock(self, YES);
}

- (void)am_viewDidAppear:(BOOL)animated {
    [self am_viewDidAppear:animated];
    if (self.am_viewDidAppearOrDisappearBlock) self.am_viewDidAppearOrDisappearBlock(self, YES);
}

-(void)am_viewWillDisappear:(BOOL)animated {
    [self am_viewWillDisappear:animated];
    if (self.am_viewWillAppearOrDisappearBlock) self.am_viewWillAppearOrDisappearBlock(self, NO);
}

-(void)am_viewDidDisappear:(BOOL)animated {
    [self am_viewDidDisappear:animated];
    if (self.am_viewDidAppearOrDisappearBlock) self.am_viewDidAppearOrDisappearBlock(self, NO);
}

@end
```

### 使用方法
```Objective-C
//  通过运行时给UIViewController添加2个block属性
//  通过MethodSwizzling，替换系统的实现为自己的实现，并在合适的位置调用自己添加的block属性
//  这样就可以在外部控制新创建的UIViewController在生命周期的4个方法中执行指定代码了
//  这只是AMKMethodSwizzling的使用方式之一
UIViewController *viewController = [[ViewController alloc] init];
viewController.am_viewWillAppearOrDisappearBlock = ^(UIViewController * viewController, BOOL viewWillAppear){
    NSLog(@"%@ %@", viewController.title, viewWillAppear?@"viewWillAppear":@"viewWillDisappear");
};
viewController.am_viewDidAppearOrDisappearBlock = ^(UIViewController * viewController, BOOL viewDidAppear){
    NSLog(@"%@ %@", viewController.title, viewDidAppear?@"viewDidAppear\n\n\n":@"viewDidDisappear");
};
[self.navigationController pushViewController:viewController animated:YES];
```

### 控制台输出
```
2016-04-16 17:15:04.770 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 2 viewWillAppear
2016-04-16 17:15:05.279 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 2 viewDidAppear


2016-04-16 17:15:05.902 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 2 viewWillDisappear
2016-04-16 17:15:05.902 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 3 viewWillAppear
2016-04-16 17:15:06.412 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 2 viewDidDisappear
2016-04-16 17:15:06.412 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 3 viewDidAppear


2016-04-16 17:15:07.135 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 3 viewWillDisappear
2016-04-16 17:15:07.136 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 4 viewWillAppear
2016-04-16 17:15:07.645 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 3 viewDidDisappear
2016-04-16 17:15:07.645 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 4 viewDidAppear


2016-04-16 17:15:13.319 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 4 viewWillDisappear
2016-04-16 17:15:13.320 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 5 viewWillAppear
2016-04-16 17:15:13.836 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 4 viewDidDisappear
2016-04-16 17:15:13.836 AMKMethodSwizzlingDemo[12955:2746054] AMKMethodSwizzlingDemo 5 viewDidAppear

```


Requirements
------
该软件 Xcode Version 7.1.1 上开发的，目标支持iOS7+，没有测试更早的iOS版本。


One More Thing
------
如果你有好的 idea 或 疑问，请随时提 issue 或 request。


Author
------
如果你在开发过程中遇到什么问题，或对iOS开发有着自己独到的见解，再或是你与我一样同为菜鸟，都可以关注或私信我的微博。

* QQ: 564784408
* 微信：Andy_129
* 微博：[@Developer_Andy](http://weibo.com/u/5271489088)
* 简书：[Andy__M](http://www.jianshu.com/users/28d89b68984b)

>“Stay hungry. Stay foolish.”

与君共勉~

License
------
本软件 使用 MIT 许可证，详情见 LICENSE 文件。



