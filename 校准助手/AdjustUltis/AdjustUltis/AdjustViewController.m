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

@interface AdjustViewController ()

@end

@implementation AdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"校准助手";
    OneViewController *one = [[OneViewController alloc]init];
    one.characteristic = self.characteristic;
    one.discoverPeripheral = self.discoverPeripheral;
    one.title = @"电机测试与校准";
    TwoViewController *two = [[TwoViewController alloc]init];
    two.title = @"整机零位校准";
    two.discoverPeripheral =self.discoverPeripheral;
    two.characteristic =self.characteristic;
    NSArray *subViewControllers = @[one,two];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0, 64,self.view.frame.size.width,self.view.frame.size.height- 64);
    
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
