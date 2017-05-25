//
//  ViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "ViewController.h"
#import "LCConnectViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    self.title = @"校准助手";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查找设备" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake((self.view.frame.size.width-180)/2,450, 180, 60);
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 2;
    btn.layer.cornerRadius = 30;
    btn.clipsToBounds =YES;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadAnimation];
}

- (void)loadAnimation
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-150)/2,100,150,300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    NSMutableArray * loadingImages = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d.png",i]];
        [loadingImages addObject:image];
    }
    _imageView.animationImages = loadingImages;//[SingleClass shareSingleClass].loadingImages;
    _imageView.animationDuration = 1;
    _imageView.animationRepeatCount = NSIntegerMax;
    [_imageView startAnimating];
    
}

- (void)searchBtnClick:(UIButton *)btn
{
    LCConnectViewController *bleVC = [LCConnectViewController new];
    [self.navigationController pushViewController:bleVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
