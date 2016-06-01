//
//  UIViewController+Extension.m
//  runtimeDemo
//
//  Created by aoliday on 16/6/1.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "UIViewController+Extension.h"



@implementation UIViewController (Extension)

+ (void)load {
    
    //获取method.
    Method viewDidloadMethod = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    Method logLoadMethod = class_getInstanceMethod([UIViewController class], @selector(logViewDidLoad));
    //使用method_swizzling交换方法的IMP.
    method_exchangeImplementations(viewDidloadMethod, logLoadMethod);
}


- (void)logViewDidLoad {
    //这里logViewDidLoad的IMP指向了viewDidLoad的IMP,因此相当于是调用了viewDidload方法.
    [self logViewDidLoad];
    NSLog(@"%@ is load...",NSStringFromClass([self class]));
}

@end
