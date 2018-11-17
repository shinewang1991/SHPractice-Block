//
//  SecondViewController.m
//  SHPractice-Block
//
//  Created by shine on 2018/11/17.
//  Copyright © 2018 shine. All rights reserved.
//

#import "SecondViewController.h"

typedef void(^TestBlock)(void);

@interface SecondViewController ()
@property (nonatomic, copy) TestBlock testBlock;
@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    __weak typeof(self) wSelf = self;
    self.testBlock = ^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"weakSelf ---- %@",NSStringFromClass([wSelf class]));
            /*
             log:
            weakSelf ---- (null)
             */
            
           wSelf.view.backgroundColor = [UIColor redColor];
        });
    };
    
    self.testBlock();
    
    //总结，block里一定要weakSelf和strongSelf配合使用。否则有可能在block执行过程self释放掉了，造成后面的代码执行异常
    
    //Demo 1.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"执行block");
        self.view.backgroundColor = [UIColor redColor];
    });
    
    /*
     先执行block，再执行了dealloc
     log:
     ...执行block
     ...SecondViewController---dealloc
     */
    
    //Demo 2.
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"执行block");
        typeof(weakSelf) strongSelf = weakSelf;
        if(strongSelf){
            NSLog(@"strongSelf 执行了");
        strongSelf.view.backgroundColor = [UIColor redColor];
        }
    });
    
    /*
     先执行dealloc，再执行了block，"strongSelf执行了"不会打印,因为self已经释放了
     log:
     ...SecondViewController---dealloc
     ...执行block
     */
    
    //结论。遇到了对象和block不互相持有的情况，如果block内部也是个耗时操作，也需要用weakSelf和strongSelf. 否则对象的dealloc需要等到block执行结束后才释放，容易造成内存泄漏
    
}

@end
