//
//  ViewController.m
//  SHPractice-Block
//
//  Created by Shine on 08/04/2018.
//  Copyright © 2018 shine. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo2];
}

- (void)demo1{
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
    /*
     2018-11-17 12:26:05.385817+0800 SHPractice-Block[3315:7709348] block之前0x7ffeee09fd70
     2018-11-17 12:26:05.385939+0800 SHPractice-Block[3315:7709348] block之后0x604000230258
     2018-11-17 12:26:05.386022+0800 SHPractice-Block[3315:7709348] block中0x604000230258
     */
}

- (void)demo2{
    Person *person1 = [[Person alloc] init];
    Person *person2 = [[Person alloc] init];
    [person1 blockOperation];
    [person2 blockOperation];
    
    /*
     log:
     self----------<Person: 0x600000016c60>
     testBlock------------<__NSGlobalBlock__: 0x103139288>
     self----------<Person: 0x6000000164a0>
     testBlock------------<__NSGlobalBlock__: 0x103139288>
     
     可以看出。虽然两个对象的地址不同。但是两次执行的block内存地址是相同的。
     globalBlock存在于静态区，不依附于某个对象而存在，也并不为某个对象单独拥有，所有对象共享这个block,不管多个block调用这个block，这个block都会在内存中只有一份。直到进程被杀死，block才会被释放。
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pushToSecondViewController:(id)sender {
    SecondViewController *secVC = [[SecondViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:secVC];
    [self.navigationController pushViewController:secVC animated:YES];
}

@end
