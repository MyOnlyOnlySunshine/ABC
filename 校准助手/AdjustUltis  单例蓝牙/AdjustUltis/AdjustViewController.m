//
//  AdjustViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "AdjustViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "DCNavTabBarController.h"
#import "LCBlueTManager.h"

@interface AdjustViewController ()

@end

@implementation AdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"校准助手";
    OneViewController *one = [[OneViewController alloc]init];
    one.title = @"电机测试与校准";
    TwoViewController *two = [[TwoViewController alloc]init];
    two.title = @"整机零位校准";
    NSArray *subViewControllers = @[one,two];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0, 64,self.view.frame.size.width,self.view.frame.size.height- 64);
    
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"11");
    if ([[LCBlueTManager getInstance] getConnectedCharacteristic])
    {
        [[LCBlueTManager getInstance] cancelPeripheralWith:[[LCBlueTManager getInstance] getConnectedPeripheral]];
        NSLog(@"蓝牙断开");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
