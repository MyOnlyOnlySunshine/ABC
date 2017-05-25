//
//  TwoViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "TwoViewController.h"
#import "JMAnimationButton.h"
#import "JMNavigationController.h"

@interface TwoViewController ()<JMAnimationButtonDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
//@property (nonatomic, weak) JMAnimationButton* button1;
@property(nonatomic,strong)UIButton *button1;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    JMAnimationButton* button1 = [JMAnimationButton buttonWithFrame:CGRectMake(80, 200, self.view.bounds.size.width - 2 * 80, 50)];
//    self.button1 = button1;
//    button1.delegate = self;
    self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button1.frame = CGRectMake(80, 200, self.view.bounds.size.width - 2 * 80, 50);
    [_button1 setTitle:@"电机零位校准" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _button1.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _button1.layer.borderColor = [UIColor grayColor].CGColor;
    _button1.layer.borderWidth = 2;
    _button1.layer.cornerRadius = 15;
    _button1.layer.masksToBounds = YES;
    [self.view addSubview:_button1];
    [_button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)click:(JMAnimationButton*)button{
//    
//    [button startAnimation];
//    
//    Byte byte[8] = {0x55,0xaa,0x01,0x02,0x58,0x00,0x01^0x02^0x58^0x00,0xf0};
//    [self.discoverPeripheral writeValue:[NSData dataWithBytes:byte length:8] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
//    NSLog(@"电机零位校准写入: %@",[NSData dataWithBytes:byte length:8]);
//}

- (void)click:(UIButton *)button
{
    [self showAlertWithTitle:@"温馨提示" andContent:@"云台正在校准……\n收到回传命令后，将提示校准成功"];
    Byte byte[8] = {0x55,0xaa,0x01,0x02,0x58,0x00,0x01^0x02^0x58^0x00,0xf0};
    [self.discoverPeripheral writeValue:[NSData dataWithBytes:byte length:8] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"电机零位校准写入: %@",[NSData dataWithBytes:byte length:8]);
}

-(void)JMAnimationButtonDidStartAnimation:(JMAnimationButton *)JMAnimationButton{
    NSLog(@"start");
}

-(void)JMAnimationButtonDidFinishAnimation:(JMAnimationButton *)JMAnimationButton{
    [self.button1 setTitle:@"校准成功" forState:UIControlStateNormal];
}

-(void)JMAnimationButtonWillFinishAnimation:(JMAnimationButton *)JMAnimationButton{
    [self.button1 setBackgroundColor:[UIColor greenColor]];
    [self.button1 setTitle:@"校准成功" forState:UIControlStateNormal];
    self.button1.enabled = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(passValue:) name:@"value_cha" object:nil];
}

- (void)passValue:(NSNotification *)notification
{
    NSDictionary *dic =[notification userInfo];
    NSLog(@"dic = %@",dic);
    NSData *data = dic[@"characteristic.value"];
    NSLog(@"蓝牙整机零位%@",data);
    if (data.length == 8) {
        Byte *byte = (Byte *)[data bytes];
        if (byte[0] == 0x55 &&byte[1] == 0xaa &&byte[2] == 0x01 && byte[3] ==0x02 && byte[4] == 0x58 &&byte[5] ==0x00 &&byte[7] == 0xf0)
        {
            byte[6] = byte[2] ^byte[3]^byte[4]^byte[5];
            [self showAlertWithTitle:@"温馨提示" andContent:@"校准成功"];
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title andContent:(NSString *)content
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:yes];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
