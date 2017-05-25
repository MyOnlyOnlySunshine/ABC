//
//  OneViewController.h
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface OneViewController : UIViewController
@property(strong,nonatomic)CBPeripheral *discoverPeripheral;
@property(strong,nonatomic)CBCharacteristic *characteristic;
@end
