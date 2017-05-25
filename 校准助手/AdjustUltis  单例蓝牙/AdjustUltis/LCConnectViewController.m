//
//  LCConnectViewController.m
//  uoplay
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "LCConnectViewController.h"
#import "AdjustViewController.h"

#import "LCBlueTManager.h"
#import "MBProgressHUD.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface LCConnectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *bleNameArr;
@property(nonatomic,strong)LCBlueTManager *bleManager;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation LCConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self configBle];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scan) userInfo:nil repeats:YES];
    });
}

#pragma mark-
#pragma mark 初始化UI
- (void)configUI
{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight-64) style:UITableViewStylePlain];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.title = @"蓝牙连接";
    self.edgesForExtendedLayout =UIRectEdgeNone;
    [self configHUD];
}

- (void)configBle
{
    self.bleManager = [LCBlueTManager getInstance];
    [self.bleManager startScan];
    [self.bleManager getBlueListArray:^(NSMutableArray *blueToothArray) {
        self.bleNameArr = blueToothArray;
    }];
}

- (void)configHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在搜索附近蓝牙，请耐心等待。";
}


- (void)configAlertVC
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您手持悠拍的蓝牙进行连接" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"好的，我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:yes];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark-
#pragma mark 加载数据


#pragma mark-
#pragma mark 点击事件
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    LCHasConnectedViewController *hasConnectedVC = [LCHasConnectedViewController new];
//   // hasConnectedVC.peripheral = self.bleNameArr[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
//    //hud.hidden = YES;
//    [self.navigationController pushViewController: hasConnectedVC animated:YES];
//
//}

#pragma mark-
#pragma mark 数据请求


#pragma mark-
#pragma mark 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bleNameArr.count !=0) {
        _hud.hidden =YES;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self configAlertVC];
        });
       }
    return  self.bleNameArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bleName"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bleName"];
    }
     CBPeripheral *per=(CBPeripheral *)self.bleNameArr[indexPath.row];
    cell.textLabel.text = per.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    hud.labelText = @"正在连接蓝牙";
    
    CBPeripheral * peripheral = (CBPeripheral *)self.bleNameArr[indexPath.row];
     [self.bleManager connectPeripheralWith: peripheral];
    
    if (_timer != nil) {
        [_timer invalidate];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        if (peripheral !=nil && [[LCBlueTManager getInstance] getConnectedCharacteristic] != nil) {
            AdjustViewController *adjustVC= [AdjustViewController  new];
            hud.hidden = YES;
            adjustVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController pushViewController:adjustVC animated:YES];
        }
    });
    [self.bleManager stopScan];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark-
#pragma mark 业务逻辑
- (NSMutableArray *)bleNameArr
{
    if (_bleNameArr == nil) {
        _bleNameArr = [NSMutableArray new];
    }
    return _bleNameArr;
}

- (void)scan
{
    self.bleNameArr =  [self.bleManager getNameList];
    [self.tableView reloadData];
}

#pragma mark-
#pragma mark 通知的注册和销毁

@end
