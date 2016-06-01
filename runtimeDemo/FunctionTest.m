//
//  FunctionTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/5/30.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "FunctionTest.h"

@implementation FunctionTest

void methodIMP1(id self , SEL _cmd , char *name) {
    
    NSLog(@"this is IMP which has three arguments. and name is :%@",[NSString stringWithUTF8String:name]);
}
- (void)logIMP1:(char *)name {}
- (instancetype)init {
    
    if (self = [super init]) {
        
        NSLog(@"进入FunctionTest类测试。。。。。。。。。。。。。。");
        class_addMethod(object_getClass(self), @selector(logIMP1:), (IMP)methodIMP1, "v@:*");
        
        [self logIMP1:(char *)"动态添加的方法"];
        
        Method method = class_getInstanceMethod([FunctionTest class], @selector(hasPrefix:));
        
        NSLog(@"获取到的方法为:%@",   NSStringFromSelector(method_getName(method)));
        NSLog(@"获取到的类方法为:%@", NSStringFromSelector(method_getName(class_getClassMethod(object_getClass(self),@selector(defaultCStringEncoding)))));
        
        
        class_setVersion(object_getClass(self), 3);
        NSLog(@"类的version是:%d",class_getVersion(object_getClass(self)));
        
    }
    
    return self;
}

+ (void)logInstanceMethods:(Class)class {
    
    unsigned int outCount;
    Method *methods = class_copyMethodList([class class], &outCount);
    if (outCount) {
        
        for (int index = 0; index < outCount; index ++) {
            
            Method method = methods[index];
            NSLog(@"methodName:%@ , typeEncoding:%s",NSStringFromSelector(method_getName(method)),method_getTypeEncoding(method));
        }
    }
}

@end
