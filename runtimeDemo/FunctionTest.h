//
//  FunctionTest.h
//  runtimeDemo
//
//  Created by aoliday on 16/5/30.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionTest : NSString

- (void)logIMP1:(char *)name;
+ (void)logInstanceMethods:(Class)class;


@end
