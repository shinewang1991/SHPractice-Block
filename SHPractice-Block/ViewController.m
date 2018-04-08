//
//  ViewController.m
//  SHPractice-Block
//
//  Created by Shine on 08/04/2018.
//  Copyright © 2018 shine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    void(^testBlock)(void) = ^() {
        NSLog(@"这是个block");
    };
    
    testBlock();
    NSLog(@"%@",testBlock);
    /* 2018-04-08 20:49:58.032749+0800 SHPractice-Block[56145:31015946] 这是一个block
    2018-04-08 20:49:58.032944+0800 SHPractice-Block[56145:31015946] <__NSGlobalBlock__: 0x1094c3088> */
    
    
    int a = 5;
    void(^testBlock1)(void) = ^{
        NSLog(@"这是有引用外部变量的block----%d",a);
    };
    
    NSLog(@"%@",testBlock1);
    /* 2018-04-08 21:02:18.472881+0800 SHPractice-Block[56467:31066726] <__NSMallocBlock__: 0x60c000045640>
     */
    
    NSLog(@"%@",^{
        NSLog(@"万物皆对象----%d",a);
    });
    
    /* 2018-04-08 21:04:05.098497+0800 SHPractice-Block[56572:31075276] <__NSStackBlock__: 0x7ffeeafafb28>
     */
    
    /*Block的分类:
        NSGlobalBlock   全局
        NSMallocBlock   堆
        NSStackBlock  栈   ARC中没有。 栈区 -> 堆区
     */
    
    
    //为什么block修改block外的变量，需要加__Block？  __block将外部变量从栈区拷贝到了堆区.
    __block int b = 10;
    NSLog(@"block之前%p",&b);   //观察b的地址是否发生了变化。验证是否是真的已经copy了一份。
    void(^testBlock3)(int num) = ^(int num) {
        NSLog(@"block中%p",&b);
        b+=num;
    };
    NSLog(@"block之后%p",&b);
    testBlock3(5);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
