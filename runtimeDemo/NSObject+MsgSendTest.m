//
//  NSObject+MsgSendTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/6/3.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "NSObject+MsgSendTest.h"

@implementation NSObject (MsgSendTest)

+ (void)load {
    //获取method.
    Method InstanceMethod = class_getClassMethod([NSObject class], @selector(resolveInstanceMethod:));
    Method KBInstanceMethod = class_getClassMethod([NSObject class], @selector(KB_ResolveInstanceMethod:));
    //使用method_swizzling交换方法的IMP.
    method_exchangeImplementations(InstanceMethod, KBInstanceMethod);
    
    //获取method.
    Method classMethod = class_getClassMethod([NSObject class], @selector(resolveClassMethod:));
    Method KBClassMethod = class_getClassMethod([NSObject class], @selector(KB_ResolveClassMethod:));
    //使用method_swizzling交换方法的IMP.
    method_exchangeImplementations(classMethod, KBClassMethod);
}

+ (BOOL)KB_ResolveInstanceMethod:(SEL)sel {
    
    if ([NSStringFromSelector(sel) isEqualToString:@"unrecginzedSelctorViewController"]) {
        
        class_addMethod(self, sel, imp_implementationWithBlock(^(void) {
            
            NSLog(@"OY MY GOD!!!! < the methods %@ unrecongnized....!!",NSStringFromSelector(sel));
        }), "V@:");
    }
    return [self KB_ResolveInstanceMethod:sel];
}

+ (BOOL)KB_ResolveClassMethod:(SEL)sel {
    
    NSLog(@"OY MY GOD!!!! < the methods %@ unrecongnized....!!",NSStringFromSelector(sel));
    return [self KB_ResolveClassMethod:sel];
}


@end
