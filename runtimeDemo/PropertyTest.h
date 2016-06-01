//
//  PropertyTest.h
//  runtimeDemo
//
//  Created by aoliday on 16/5/30.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyTest : NSObject

@property int (*functionPointDefault)(char *);

@property unsigned int value1;

@property (nonatomic,assign) double value2;

@property (atomic, retain) NSNumber *value3;

@property (strong) NSString *value4;

@property (weak,nonatomic) id value5;

+ (void)logProperties:(Class)class;

@end
