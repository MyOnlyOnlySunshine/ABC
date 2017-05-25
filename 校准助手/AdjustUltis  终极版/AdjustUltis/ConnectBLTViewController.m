
//
//  ConnectBLTViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "ConnectBLTViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "AdjustViewController.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger,BluetoothState){
    BluetoothStateDisconnect =0,
    BluetoothStateScanSuccess,
    BluetoothStateScaning,
    BluetoothStateConnected,
    BluetoothStateConnecting
};

typedef NS_ENUM(NSInteger,BluetoothFailState){
    BluetoothFailStateUnExit = 0,
    BluetoothFailStateUnKnow,
    BluetoothFailStateByHW,
    BluetoothFailStateByOff,
    BluetoothFailStateUnauthorized,
    BluetoothFailStateByTimeout
    
};

@interface ConnectBLTViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(strong,nonatomic) CBCentralManager *manager;
@property(assign,nonatomic)BluetoothFailState bluetoothFailState;
@property(assign,nonatomic)BluetoothState bluetoothState;
@property(strong,nonatomic)CBPeripheral *discoverPeripheral;
@property(strong,nonatomic)CBCharacteristic *characteristic;
@property(strong,nonatomic)NSMutableArray *BleViewPerArr;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (strong, nonatomic) UIImageView *backgroundImg;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ConnectBLTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark --表格显示搜索到的蓝牙
- (void)configUI
{
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    self.manager.delegate =self;
    [self performSelector:@selector(scan) withObject:nil afterDelay:1];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.width)];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
     self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
      self.tableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview: self.tableView];
}

#pragma mark -- 扫描外设
-(void)scan
{
    self.BleViewPerArr = [[NSMutableArray alloc]initWithCapacity:1];
    [self.manager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    _bluetoothState = BluetoothStateScaning;
    if (_bluetoothState == BluetoothFailStateByOff) {
        NSLog(@"%@",@"请检查蓝牙是否开启后重试");
    }
}

#pragma  mark -- 蓝牙开启状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"失败，蓝牙状态是关闭的");
        switch (central.state) {
            case CBCentralManagerStatePoweredOff:
                NSLog(@"蓝牙未开启");
                _bluetoothFailState = BluetoothFailStateByOff;
                break;
            case CBCentralManagerStateResetting:
                _bluetoothFailState=BluetoothFailStateByTimeout;
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"抱歉，您的手机不支持蓝牙4.0");
                _bluetoothFailState = BluetoothFailStateByHW;
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"蓝牙未授权");
                _bluetoothFailState = BluetoothFailStateUnauthorized;
                break;
            case CBCentralManagerStateUnknown:
                _bluetoothFailState = BluetoothFailStateUnKnow;
                break;
            default:
                break;
        }
        return;
    }
    _bluetoothFailState =BluetoothFailStateUnExit;
}

#pragma  mark  --  警告框
- (void)showAlert
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您手持悠拍的蓝牙进行连接" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"好的，我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:yes];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IsConnect"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IsConnect"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CBPeripheral *per=(CBPeripheral *)_BleViewPerArr[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = per.name;
    return cell;
}

#pragma mark -- tableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _BleViewPerArr.count;
}

#pragma  mark --  发现外设的代理
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
  //  _imageView.hidden =YES;
    //过滤名字为空，且重复的蓝牙名称
    
    if (peripheral.name != nil&&[_BleViewPerArr containsObject:peripheral]==NO)
    {
        [_BleViewPerArr addObject:peripheral];
    }
    _bluetoothFailState = BluetoothFailStateUnExit;
    _bluetoothState = BluetoothStateScanSuccess;
    [_tableView reloadData];
}


#pragma  mark --  单个cell选中的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    hud.labelText = @"正在连接蓝牙";
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _discoverPeripheral=(CBPeripheral *)_BleViewPerArr[indexPath.row];
    
    //连接设备
    if (_discoverPeripheral != nil) {
        [_manager connectPeripheral:_discoverPeripheral options:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AdjustViewController *adjustVC = [AdjustViewController new];
            adjustVC.discoverPeripheral = _discoverPeripheral;
            adjustVC.characteristic =_characteristic;
             hud.hidden = YES;
            adjustVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController pushViewController:adjustVC animated:YES];
        });
    }
}

#pragma  mark --  蓝牙连接成功的代理
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [_manager stopScan];
    _bluetoothState=BluetoothStateConnected;
}

// 获取当前设备服务services
#pragma  mark -- 获取中间services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"错误信息: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"所有的servicesUUID%@",peripheral.services);
    
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
        NSLog(@"服务%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    NSLog(@"此时连接的peripheral：%@",peripheral);
    
}

#pragma  mark -- 蓝牙发现特征的代理
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"特征：%@ 错误信息：%@", service.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"服务：%@",service.UUID);
    // 特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        _characteristic = characteristic;
        NSLog(@"_characteristic = %@",_characteristic);
        [_discoverPeripheral setNotifyValue:YES forCharacteristic:_characteristic];
        NSLog(@"这个蓝牙特征的UUID是:%@",characteristic.UUID);
    }
}

#pragma  mark -- 蓝牙接受到数据的代理
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    _characteristic =characteristic;
     NSNotification *notice = [NSNotification   notificationWithName:@"value_cha" object:nil userInfo:@{@"characteristic.value":_characteristic.value}];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
