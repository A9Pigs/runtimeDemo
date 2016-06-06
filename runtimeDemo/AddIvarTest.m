//
//  AddIvarTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/5/30.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "AddIvarTest.h"

@interface AddIvarTest() {
    
    __unsafe_unretained id _signValue;
    __weak NSString *_weakV1;
    NSString *_desc;
    __weak NSString *_weakV2;
    __weak NSString *_weakV3;
    NSNumber *_number;
    NSInteger _count;
    __weak NSString *_weakV4;
}

@end

@implementation AddIvarTest

+ (void)load {
    
    const char *addIvar = "_newInstanceValue";
    //    char *NSStringEncoding = @encode(NSString);
    //    NSUInteger NSStringSize , NSStringAlign;
    //    NSGetSizeAndAlignment(NSStringEncoding, &NSStringSize, &NSStringAlign);
    
    BOOL added = class_addIvar([AddIvarTest class],addIvar, sizeof(NSString *), log2(sizeof(NSString *)), "@");
    /*
     * The documentation states you can't add ivars to classes that have already been registered
     * Discussion
     
        This function may only be called after objc_allocateClassPair and before objc_registerClassPair. Adding an instance variable to an existing class is not supported
     */
    if (added) {
        
        NSLog(@"iVar 添加成功...");
    }else {
        
        NSLog(@"已注册的类无法添加Ivar.可以使用associate添加属性.");
    }
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        NSLog(@"进入IvarTest类测试。。。。。。。。。。。。。。");
        [self logIvars];
        
        [self logIvarlayout];
        
        NSLog(@"%@",NSStringFromClass([self class]));
        NSLog(@"%@",NSStringFromClass([super class]));
        NSLog(@"%@",NSStringFromClass(class_getSuperclass(objc_getClass("AddIvarTest"))));
    }
    return self;
}

- (void)logIvars {
    
    unsigned int outCount ;
    
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    if (outCount) {
        
        for (NSInteger index = 0; index < outCount; index ++) {
            
            Ivar ivar = ivars[index];
            printf("第%lu个变量是:%s , typeEncoding:%s \n",index,ivar_getName(ivar),ivar_getTypeEncoding(ivar));
        }
    }
    free(ivars);
}

+ (void)logIvars:(Class)class {
    
    unsigned int outCount ;
    
    Ivar *ivars = class_copyIvarList(class, &outCount);
    if (outCount) {
        
        for (NSInteger index = 0; index < outCount; index ++) {
            
            Ivar ivar = ivars[index];
            printf("第%lu个变量是:%s , typeEncoding:%s \n",index,ivar_getName(ivar),ivar_getTypeEncoding(ivar));
        }
    }
    free(ivars);
}

- (void)logIvarlayout {
    
    //没看懂这一块
    const UInt8 * result = class_getIvarLayout(object_getClass(self));
    printf("Ivar layout is : 0x%x\n , ",*result);
    
    const UInt8 * weakResult = class_getWeakIvarLayout(object_getClass(self));
    printf("weak Ivar layout is : 0x%x\n,",*weakResult);
    
//    self.functionPointDefault = ^(char *name) {
//        
//        return 1;
//    };
}


@end
