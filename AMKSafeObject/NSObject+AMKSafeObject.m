//
//  NSObject+AMKSafeObject.m
//  AMKSafeObjectDemo
//
//  Created by Andy on 2017/5/9.
//  Copyright © 2017年 Andy Meng. All rights reserved.
//

#import "NSObject+AMKSafeObject.h"
#import <AMKMethodSwizzling/NSObject+AMKMethodSwizzling.h>

@implementation NSObject (AMKSafeObject) @end

@implementation NSString (AMKSafeObject)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSCFConstantString") amk_swizzleInstanceMethod:@selector(characterAtIndex:) with:@selector(amk_characterAtIndex:)];
        [NSClassFromString(@"__NSCFConstantString") amk_swizzleInstanceMethod:@selector(substringFromIndex:) with:@selector(amk_substringFromIndex:)];
        [NSClassFromString(@"__NSCFConstantString") amk_swizzleInstanceMethod:@selector(substringToIndex:) with:@selector(amk_substringToIndex:)];
        [NSClassFromString(@"__NSCFConstantString") amk_swizzleInstanceMethod:@selector(substringWithRange:) with:@selector(amk_substringWithRange:)];
    });
}

- (unichar)amk_characterAtIndex:(NSUInteger)index {
    if (index > self.length) return '\0';
    return [self amk_characterAtIndex:index];
}

- (NSString *)amk_substringFromIndex:(NSUInteger)from {
    if (from > self.length) return nil;
    return [self amk_substringFromIndex:from];
}

- (NSString *)amk_substringToIndex:(NSUInteger)to {
    if (to > self.length) to = self.length;
    return [self amk_substringToIndex:to];
}

- (NSString *)amk_substringWithRange:(NSRange)range {
    if (range.location > self.length) return nil;
    
    if (range.length>self.length || range.location+range.length>self.length) {
        range.length = self.length - range.location;
    }
    return [self amk_substringWithRange:range];
}

@end
