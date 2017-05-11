//
//  ViewController.m
//  AMKSafeObjectDemo
//
//  Created by Andy on 2017/5/9.
//  Copyright © 2017年 Andy Meng. All rights reserved.
//

#import "ViewController.h"

static NSString const * kTestString = @"AMKSafeObjectTest";

#define NSLog(FORMAT, ...) fprintf(stderr,"%sLine %d: %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])


@interface ViewController () @end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testString];
}

- (void)testString {
    NSLog(@"%u", [kTestString characterAtIndex:10]);
    NSLog(@"%u", [kTestString characterAtIndex:1000]);
    NSLog(@"%u", [kTestString characterAtIndex:-1000]);
    NSLog(@"\n");
    
    NSLog(@"%@", [kTestString substringFromIndex:10]);
    NSLog(@"%@", [kTestString substringFromIndex:kTestString.length]);
    NSLog(@"%@", [kTestString substringFromIndex:1000]);
    NSLog(@"%@", [kTestString substringFromIndex:-1000]);
    NSLog(@"\n");
    
    NSLog(@"%@", [kTestString substringToIndex:10]);
    NSLog(@"%@", [kTestString substringToIndex:kTestString.length]);
    NSLog(@"%@", [kTestString substringToIndex:1000]);
    NSLog(@"%@", [kTestString substringToIndex:-1000]);
    NSLog(@"\n");
    
    NSLog(@"%@", [kTestString substringWithRange:NSMakeRange(-10, -10)]);
    NSLog(@"%@", [kTestString substringWithRange:NSMakeRange(-10, 10)]);
    NSLog(@"%@", [kTestString substringWithRange:NSMakeRange(10, -10)]);
    NSLog(@"%@", [kTestString substringWithRange:NSMakeRange(10, 10)]);
    NSLog(@"\n");
    
}

@end
