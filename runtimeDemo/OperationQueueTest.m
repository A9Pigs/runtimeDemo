//
//  OperationQueueTest.m
//  runtimeDemo
//
//  Created by aoliday on 16/6/2.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "OperationQueueTest.h"

@interface OperationQueueTest() {
    
    NSBlockOperation *oper1;
    NSBlockOperation *oper2;
    
    
}

@end

@implementation OperationQueueTest

+ (void)test {
    
    OperationQueueTest *test = [OperationQueueTest new];
    [test testOperation];
}

- (void)testOperation {
    
    oper1 = [[NSBlockOperation alloc] init];
    oper2 = [[NSBlockOperation alloc] init];
    oper1.queuePriority = NSOperationQueuePriorityNormal;
    oper2.queuePriority = NSOperationQueuePriorityNormal;
    __weak NSBlockOperation * weakOper1 = oper1;
    __weak NSBlockOperation * weakOper2 = oper2;
    __weak OperationQueueTest *weakSelf = self;
    [oper1 addExecutionBlock:^{
        
        for (NSInteger index = 0; index < 500; index ++) {
            
            @synchronized(weakSelf) {
            
                if (index == 430) {
                    
                    weakOper1.queuePriority = NSOperationQueuePriorityVeryLow;
                    weakOper2.queuePriority = NSOperationQueuePriorityVeryHigh;
                    NSLog(@"oper1 priority lower...");
                }
            }
            int i = 0;
            while (i < 100) {
                i++;
            }
            printf("oper1 %ld \n",index);
        }
    }];
    
    [oper2 addExecutionBlock:^{
        
        for (NSInteger index = 0; index < 500; index ++) {
            
            @synchronized(weakSelf) {
            
                if (index == 30) {
                    
                    weakOper1.queuePriority = NSOperationQueuePriorityVeryHigh;
                    weakOper2.queuePriority = NSOperationQueuePriorityVeryLow;
                    NSLog(@"oper2 priority lower...");
                }
            }
            printf("            oper2 %ld \n",index);
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:2];
    [queue addOperation:oper2];
    [queue addOperation:oper1];
    
//    [oper1 addObserver:self forKeyPath:@"queuePriority" options:NSKeyValueObservingOptionPrior context:nil];
//    [oper2 addObserver:self forKeyPath:@"queuePriority" options:NSKeyValueObservingOptionPrior context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"p1:%ld,p2:%ld",oper1.queuePriority,oper2.queuePriority);
}

@end
