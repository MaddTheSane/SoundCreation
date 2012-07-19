//
//  NSObject+Blocks.m
//  test
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)(void))block AfterTimeInterval:(NSTimeInterval)time {
    double delayInSeconds = (double)time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        block();
    });
}
@end