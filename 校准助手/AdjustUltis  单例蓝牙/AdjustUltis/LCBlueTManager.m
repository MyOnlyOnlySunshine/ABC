//
//  LCBlueTManager.m
//  uoplay
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "LCBlueTManager.h"

@implementation LCBlueTManager
//创建单例类
+(instancetype)getInstance
{
    static  LCBlueTManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LCBlueTManager alloc]init];
    });
    return manager;
}
//开始扫描
- (void)startScan
{
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
}

//停止扫描
-(void)stopScan
{
    [_manager stopScan];
}

-(void)getBlueListArray:(void (^)(NSMutableArray *blueToothArray))listBlock
{
    bluetoothListArr = [listBlock copy];
}

//获取扫描到设备的列表
-(NSMutableArray *)getNameList{
    return _peripheralList;
}

//连接设备
-(void)connectPeripheralWith:(CBPeripheral *)per{
    if (per != nil) {
        valuePrint = NO;
        _peripheral = nil;
        _characteristic = nil;
        //5. 连接Peripheral设备
        [_manager connectPeripheral:per options:nil];
    }
}

//成功回调
-(void)connectInfoReturn:(void(^)(CBCentralManager *central,CBPeripheral *perpheral,NSString *StateStr))myBlock{
    conReturnBlock = [myBlock copy];
}
//像蓝牙发送信息
-(void)sendInfoData:(NSData*)infoData
{
    if (_characteristic) {
        [_peripheral writeValue:infoData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }else
    {
        NSLog(@"蓝牙已断开");
    }
    
}
-(void)getPrintSuccessReturn:(void(^)(BOOL sizeValue))printBlock
{
    printSuccess = [printBlock copy];
}
//展示蓝牙返回的信息
-(void)showResult
{
    if (printSuccess && valuePrint==YES)
    {
        printSuccess(YES);
    }
}


- (NSData *)recieviedData
{
    return _responseData;
}

#define mark 通知
//打开通知
-(void)openNotify
{
    if (_readChar!=nil&&_peripheral!=nil)
    {
        //订阅感兴趣的特性的值
        [_peripheral setNotifyValue:YES forCharacteristic:_characteristic];
    }
}

//关闭通知
-(void)cancelNotify
{
    [_peripheral setNotifyValue:NO forCharacteristic:_characteristic];
    
}

//断开连接
-(void)cancelPeripheralWith:(CBPeripheral *)per
{
    [_manager cancelPeripheralConnection:_peripheral];
}
#pragma mark  CBCentralManager代理

//2.检查本地设备支持BLE(蓝牙协议)
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙打开，开始扫描");
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        NSLog(@"蓝牙不可用");
    }
}

//4. 扫描到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (_peripheralList.count<8 && peripheral.name.length>1 && [_peripheralList containsObject:peripheral]==NO)
    {
        NSLog(@"%@===%@",peripheral.name , RSSI);   
        
        [_peripheralList addObject:peripheral];
        
        if (bluetoothListArr)
        {
            bluetoothListArr(_peripheralList);
        }
    }
}

//连接设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    if (conReturnBlock)
    {
        conReturnBlock(central,peripheral,@"ERROR");
    }
}
//设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    if (conReturnBlock)
    {
        conReturnBlock(central,peripheral,@"DISCONNECT");
    }
}

//6.连接设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
    [_peripheral setDelegate:self];
    //7.查找所有的服务
    _isConnected = YES;
    [_peripheral discoverServices:nil];
}


- (NSString *)getConnectedPeripheralName
{
    return _peripheral.name;
}
- (CBCharacteristic *)getConnectedCharacteristic
{
    return _characteristic;
}

- (CBPeripheral *)getConnectedPeripheral
{
    return _peripheral;
}
#pragma mark CBPeripheral代理
//8. 扫描设备的服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
       
    }
    else
    {
        for (CBService *service in peripheral.services)
        {
            //9.查找服务中的特性
            [peripheral discoverCharacteristics:nil forService:service];
        }
        
        if (conReturnBlock)
        {
            conReturnBlock(nil,peripheral,@"SUCCESS");
        }
    }
}
//10. 扫描服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        
    }
    else
    {
        for (CBCharacteristic * cha in service.characteristics)
        {
            
            [_peripheral setNotifyValue:YES forCharacteristic:cha];
            [_peripheral readValueForCharacteristic:cha];
            [_peripheral discoverDescriptorsForCharacteristic:cha];

            CBUUID *uuid = [CBUUID UUIDWithString:@"FFF2"];
            if ([cha.UUID isEqual:uuid])
            {
                _characteristic = cha;
               
//                [_peripheral setNotifyValue:YES forCharacteristic:_characteristic];
//                [_peripheral readValueForCharacteristic:cha];
//                [_peripheral discoverDescriptorsForCharacteristic:cha];
                break;
            }else
            {
               
            }
        }
    }
}
//12.获取特征值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
       
    }
    else
    {
        _responseData = characteristic.value;
       // NSLog(@"_respond = %@",_responseData);
        NSNotification *notice = [NSNotification notificationWithName:@"value_cha" object:nil userInfo:@{@"characteristic.value":characteristic.value}];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}

//扫描特征值的描述
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
      
    }
    else
    {
        
    }
    
}

//获取描述值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

@end
