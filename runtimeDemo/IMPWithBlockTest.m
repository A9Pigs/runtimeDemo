//
//  IMPWithBlockTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/6/1.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "IMPWithBlockTest.h"

@implementation IMPWithBlockTest


+ (void)doTest {
    
    int (^impBlock)(id,int,int) = ^(id _self , int a , int b) {
        
        return a + b;
    };
    
    int (*impFunc)(id,SEL,int,int) = (void*)imp_implementationWithBlock(impBlock);
    
    IMPWithBlockTest *test = [IMPWithBlockTest new];
    //直接调用BLock.
    NSLog(@"impyBlock: %d + %d = %d", 20, 22, impBlock(nil, 20, 22));
    //IMP可以直接调用.
    NSLog(@"impyFunct: %d + %d = %d", 20, 22, impFunc(nil, NULL, 20, 22));
    
    //如果instance没有实现totoalValue方法.则调用addMethods,或则调用replaceMethod。
//    class_addMethod([test class], @selector(totalValue:other:), (IMP)impFunc, "i@:ii");
    class_replaceMethod([test class], @selector(totalValue:other:), (IMP)impFunc, "i@:ii");
    //调用函数.
    NSLog(@"Methods: %d + %d = %d",20,22,[test totalValue:20 other:22]);
    
    SEL _sel = @selector(boogityBoo:);
    float k = 5.0;
    IMP boo = imp_implementationWithBlock(^(id _self , float c) {
        
        NSLog(@"Executing [%@ -%@%f] %f",
              [_self class], NSStringFromSelector(_sel), c,
              c * k);
    });
    
    class_addMethod([test class], _sel, boo, "v@:f");
    [test boogityBoo:3.1415];
}

- (int)totalValue:(int)a other:(int)b{return 0;}
- (void)boogityBoo:(float)c{}
@end
