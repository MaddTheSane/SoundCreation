//
//  NSObject+Blocks.h
//  test
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

-(void)performBlock:(void (^)(void))block AfterTimeInterval:(NSTimeInterval)time;
@end