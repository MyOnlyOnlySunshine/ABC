//
//  LCBlueTManager.h
//  uoplay
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface LCBlueTManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * _manager;
    
    CBPeripheral * _peripheral;
    
    CBCharacteristic * _characteristic;
    
    CBCharacteristic * _readChar;
    
    NSMutableArray * _peripheralList;
    
    NSData * _responseData;
    
    void(^conReturnBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSString *stateStr);
    
    void(^printSuccess)(BOOL sizeValue);
    
    void(^bluetoothListArr)(NSMutableArray *blueToothArray);
    
    BOOL valuePrint;
}
@property(nonatomic,strong)NSData *responseData;
@property(nonatomic,assign)BOOL isConnected;
+(instancetype)getInstance;

- (void)startScan;

-(void)stopScan;

- (NSMutableArray *)getNameList;

-(void)connectPeripheralWith:(CBPeripheral *)per;

-(void)openNotify;

-(void)cancelNotify;

- (void)sendInfoData:(NSData *)infoData;

-(void)showResult;

-(void)cancelPeripheralWith:(CBPeripheral *)per;

-(void)connectInfoReturn:(void(^)(CBCentralManager *central ,CBPeripheral *peripheral ,NSString *stateStr))myBlock;

-(void)getPrintSuccessReturn:(void(^)(BOOL sizeValue))printBlock;

-(void)getBlueListArray:(void (^)(NSMutableArray *blueToothArray))listBlock;

- (NSString *)getConnectedPeripheralName;

- (CBCharacteristic *)getConnectedCharacteristic;
- (CBPeripheral *)getConnectedPeripheral;

- (NSData *)recieviedData;

@end
