//
//  Person.m
//  SHPractice-Block
//
//  Created by shine on 2018/11/17.
//  Copyright © 2018 shine. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)blockOperation{
    void(^TestBlock)(void) = ^(void) {
        NSLog(@"这是个globalBlock");
    };
    
    TestBlock();
    NSLog(@"self----------%@",self);
    NSLog(@"testBlock------------%@",TestBlock);
}
@end
