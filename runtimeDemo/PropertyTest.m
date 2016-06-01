//
//  PropertyTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/5/30.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "PropertyTest.h"

@implementation PropertyTest

- (instancetype)init {
    
    if (self = [super init]) {
        NSLog(@"进入propertyTest类测试。。。。。。。。。。。。。。");
        [[self class] logProperties:[self class]];
    }
    
    return self;
}

+ (void)logProperties:(Class)class {
    
    unsigned int outCount;
    objc_property_t *attrs = class_copyPropertyList(class, &outCount);
    if (outCount) {
        
        for (NSInteger index = 0; index < outCount; index ++) {
            
            objc_property_t p = attrs[index];
            printf("第%lu个属性是:%s , atrributes:%s \n",index,property_getName(p),property_getAttributes(p));
        }
    }
    
    free(attrs);
}

@end
