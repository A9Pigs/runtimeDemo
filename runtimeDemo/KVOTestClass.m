//
//  KVOTestClass.m
//  runtimeDemo
//
//  Created by aoliday on 16/6/1.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "KVOTestClass.h"

@interface KVOTestClass()
@property int x,y,z;

@end

@implementation KVOTestClass

static NSArray *ClassMethodNames(Class c) {
    
    NSMutableArray *array = [NSMutableArray new];
    
    unsigned int methodCount;
    Method *methods = class_copyMethodList(c, &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        
        [array addObject:NSStringFromSelector(method_getName(methods[i]))];
    }
    free(methods);
    
    return array;
}

static void PrintDescription(NSString * name ,id obj) {
    
//    NSString *str = [NSString stringWithFormat:@"%@: %@ \n\t NSObject class %s \n\t libobjc class %s \n\t implements methods <%@>",
//                     name,
//                     obj,
//                     class_getName([obj class]),
//                     class_getName(obj->isa),
//                     [ClassMethodNames(obj->isa) componentsJoinedByString:@", "]];
//    printf("%s\n", [str UTF8String]);
}

@end
