//
//  OneViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "OneViewController.h"
#import "LLSwitch.h"

@interface OneViewController () <LLSwitchDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollV;
    Byte codeBtye[1];
}

@property(nonatomic,strong)UITextField *textF;
@property(nonatomic,strong)UITextField *textF1;
@property(nonatomic,strong)NSMutableData *firstData;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1.35*self.view.frame.size.height)];
    imgV.image = [UIImage imageNamed:@"bgImg1.jpg"];
    
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    // _scrollV .backgroundColor = [UIColor redColor];
    _scrollV.contentSize =CGSizeMake(self.view.frame.size.width,1.35*self.view.frame.size.height);
    _scrollV.delegate =self;
    _scrollV.bounces =NO;
    [self.view addSubview:_scrollV];
    [_scrollV addSubview:imgV];
    
    LLSwitch *llSwitch = [[LLSwitch alloc] initWithFrame:CGRectMake(260,20,60,30)];
    llSwitch.onColor = [UIColor orangeColor];
    [_scrollV addSubview:llSwitch];
    llSwitch.delegate = self;
    
    UILabel *modeL = [[UILabel alloc]initWithFrame:CGRectMake(60,20, 120, 30)];
    modeL.text = @"调试模式";
    modeL.font = [UIFont systemFontOfSize:20];
    [_scrollV addSubview:modeL];
    
    UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 375, 1)];
    lineL.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL];
    
    UILabel *firstL = [[UILabel alloc]initWithFrame:CGRectMake(116, 68, 150, 30)];
    firstL.text = @"电机零位校准/存储";
    firstL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstL];
    
    UILabel *secondL = [[UILabel alloc]initWithFrame:CGRectMake(20,100,70,40)];
    secondL.text = @"电机编码";
    secondL.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:secondL];
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(98, 105, 70, 30);
    firstBtn.backgroundColor = [UIColor whiteColor];
    firstBtn.layer.cornerRadius =15;
    firstBtn.clipsToBounds = YES;
    firstBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
    firstBtn.layer.borderWidth = 1;
    [firstBtn setTitle:@"单板调试" forState:UIControlStateNormal];
    [firstBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    if ([firstBtn.titleLabel.text isEqualToString:@"单板调试"]) {
        Byte byte[1] = {0x04};
        [_firstData appendBytes:byte length:1];
        codeBtye[0] = 0x04;
    }
    
    [_scrollV addSubview:firstBtn];
    
    UILabel *thirdL = [[UILabel alloc]initWithFrame:CGRectMake(200,100,70,40)];
    thirdL.text = @"磁链值";
    thirdL.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:thirdL];
    
    _textF = [[UITextField alloc]initWithFrame:CGRectMake(265, 105, 70, 30)];
    _textF.keyboardType = UIKeyboardTypeNumberPad;
    _textF.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollV addSubview:_textF];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScroll)];
    [_scrollV addGestureRecognizer:tapScroll];
    
    
    UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn.frame = CGRectMake(45, 180,100,40);
    thirdBtn.backgroundColor = [UIColor whiteColor];
    thirdBtn.layer.cornerRadius =20;
    thirdBtn.clipsToBounds = YES;
    thirdBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
   thirdBtn.layer.borderWidth = 1;
   [thirdBtn setTitle:@"校准" forState:UIControlStateNormal];
    [thirdBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn addTarget:self action:@selector(thirdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn];
    
    UIButton *fourthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    fourthBtn.frame = CGRectMake(230, 180,100,40);
    fourthBtn.backgroundColor = [UIColor whiteColor];
    fourthBtn.layer.cornerRadius =20;
    fourthBtn.clipsToBounds = YES;
    fourthBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
    fourthBtn.layer.borderWidth = 1;
    [fourthBtn setTitle:@"存储" forState:UIControlStateNormal];
    [fourthBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    fourthBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [fourthBtn addTarget:self action:@selector(fourthBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:fourthBtn];
    
    UILabel *fourthL = [[UILabel alloc]initWithFrame:CGRectMake(157,230,60,20)];
    fourthL.text = @"说明";
    fourthL.font = [UIFont systemFontOfSize:18];
    fourthL.textAlignment =1;
    fourthL.textColor = [UIColor lightTextColor];
    [_scrollV addSubview:fourthL];
    
    UILabel *fivthL = [[UILabel alloc]initWithFrame:CGRectMake(50,258,280,100)];
    fivthL .text = @"1.保持默认参数（900)\n2.点击校准按键\n3.等待电机停止转动(电机不在线位位置)\n4.点击存储";
    fivthL .font = [UIFont systemFontOfSize:16];
    fivthL .textColor = [UIColor lightTextColor];
    fivthL.numberOfLines =0;
    [_scrollV addSubview:fivthL];
    UILabel *lineL1 = [[UILabel alloc]initWithFrame:CGRectMake(0,370, 375, 1)];
    lineL1.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL1];
    
    
    UILabel *firstLL = [[UILabel alloc]initWithFrame:CGRectMake(116,375, 150, 30)];
    firstLL.text = @"电机力矩测试";
    firstLL.textAlignment =1;
    firstLL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstLL];
    
    UILabel *secondLL = [[UILabel alloc]initWithFrame:CGRectMake(20,400,70,40)];
    secondLL.text = @"电机编码";
    secondLL.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:secondLL];
    
    UIButton *firstBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn1.frame = CGRectMake(98, 405, 70, 30);
    firstBtn1.backgroundColor = [UIColor whiteColor];
    firstBtn1.layer.cornerRadius =15;
    firstBtn1.clipsToBounds = YES;
    firstBtn1.layer.borderColor = [UIColor lightTextColor].CGColor;
    firstBtn1.layer.borderWidth = 1;
    [firstBtn1 setTitle:@"单板调试" forState:UIControlStateNormal];
    [firstBtn1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    firstBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [firstBtn1 addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:firstBtn1];
    
    UILabel *thirdLL = [[UILabel alloc]initWithFrame:CGRectMake(200,400,70,40)];
    thirdLL.text = @"力矩值";
    thirdLL.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:thirdLL];
    
    _textF1 = [[UITextField alloc]initWithFrame:CGRectMake(265, 405, 70, 30)];
    _textF1.keyboardType = UIKeyboardTypeNumberPad;
    _textF1.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollV addSubview:_textF1];
    
    UIButton *thirdBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn1.frame = CGRectMake(275/2,460,100,40);
    thirdBtn1.backgroundColor = [UIColor whiteColor];
    thirdBtn1.layer.cornerRadius =20;
    thirdBtn1.clipsToBounds = YES;
    thirdBtn1.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtn1.layer.borderWidth = 1;
    [thirdBtn1 setTitle:@"设置" forState:UIControlStateNormal];
    [thirdBtn1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn1.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn1 addTarget:self action:@selector(thirdBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn1];
    
    UILabel *fourthLL = [[UILabel alloc]initWithFrame:CGRectMake(157,515,60,20)];
    fourthLL.text = @"说明";
    fourthLL.font = [UIFont systemFontOfSize:18];
    fourthLL.textAlignment =1;
    fourthLL.textColor = [UIColor lightTextColor];
    [_scrollV addSubview:fourthLL];
    
    UILabel *fivthLL = [[UILabel alloc]initWithFrame:CGRectMake(50,530,280,100)];
    fivthLL .text = @"1.力矩值为正时,电机正转\n2.力矩值为负时,电机反转\n3.力矩值为零时,电机停止";
    fivthLL .font = [UIFont systemFontOfSize:16];
    fivthLL .textColor = [UIColor lightTextColor];
    fivthLL.numberOfLines =0;
    [_scrollV addSubview:fivthLL];
    
    UILabel *lineL2 = [[UILabel alloc]initWithFrame:CGRectMake(0,630, 375, 1)];
    lineL2.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL2];
    
    UILabel *lineL3 = [[UILabel alloc]initWithFrame:CGRectMake(190,630,1,220)];
    lineL3.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL3];
    
    UILabel *lineL4 = [[UILabel alloc]initWithFrame:CGRectMake(0,850,375,1)];
    lineL4.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL4];

    UILabel *firstL1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 640, 150, 30)];
    firstL1.text = @" 设置电机转动方向";
    firstL1.textAlignment =1;
    firstL1.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstL1];
    
    UILabel *firstL2 = [[UILabel alloc]initWithFrame:CGRectMake(205, 640, 150, 30)];
    firstL2.text = @"设置电角度方向";
    firstL2.textAlignment =1;
    firstL2.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstL2];
    
    UILabel *firstL3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 670, 125,20)];
    firstL3.text = @" 电机编号";
    firstL3.textAlignment =1;
    firstL3.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:firstL3];
    
    UILabel *firstL4 = [[UILabel alloc]initWithFrame:CGRectMake(220,670, 125, 20)];
    firstL4.text = @"电机编号";
    firstL4.textAlignment =1;
    firstL4.font = [UIFont systemFontOfSize:15];
    [_scrollV addSubview:firstL4];
    
    UIButton *thirdBtnx = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtnx.frame = CGRectMake(13,707,40,40);
    thirdBtnx.backgroundColor = [UIColor whiteColor];
    thirdBtnx.layer.cornerRadius =20;
    thirdBtnx.clipsToBounds = YES;
    thirdBtnx.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtnx.layer.borderWidth = 1;
    [thirdBtnx setTitle:@"X" forState:UIControlStateNormal];
    [thirdBtnx setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtnx.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtnx addTarget:self action:@selector(thirdBtnxClick) forControlEvents:UIControlEventTouchUpInside];
    thirdBtnx.tag = 100;
    [_scrollV addSubview:thirdBtnx];
    
    UIButton *thirdBtny = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtny.frame = CGRectMake(75,707,40,40);
    thirdBtny.backgroundColor = [UIColor whiteColor];
    thirdBtny.layer.cornerRadius =20;
    thirdBtny.clipsToBounds = YES;
    thirdBtny.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtny.layer.borderWidth = 1;
    [thirdBtny setTitle:@"Y" forState:UIControlStateNormal];
    [thirdBtny setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtny.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtny addTarget:self action:@selector(thirdBtnyClick) forControlEvents:UIControlEventTouchUpInside];
     thirdBtny.tag = 101;
    [_scrollV addSubview:thirdBtny];
    
    UIButton *thirdBtnz = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtnz.frame = CGRectMake(135,707,40,40);
    thirdBtnz.backgroundColor = [UIColor whiteColor];
    thirdBtnz.layer.cornerRadius =20;
    thirdBtnz.clipsToBounds = YES;
    thirdBtnz.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtnz.layer.borderWidth = 1;
    [thirdBtnz setTitle:@"Z" forState:UIControlStateNormal];
    [thirdBtnz setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtnz.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtnz addTarget:self action:@selector(thirdBtnzClick) forControlEvents:UIControlEventTouchUpInside];
     thirdBtnz.tag = 102;
    [_scrollV addSubview:thirdBtnz];
    
    
    UIButton *thirdBtnx1 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtnx1.frame = CGRectMake(210,707,40,40);
    thirdBtnx1.backgroundColor = [UIColor whiteColor];
    thirdBtnx1.layer.cornerRadius =20;
    thirdBtnx1.clipsToBounds = YES;
    thirdBtnx1.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtnx1.layer.borderWidth = 1;
    [thirdBtnx1 setTitle:@"X" forState:UIControlStateNormal];
    [thirdBtnx1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtnx1.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtnx1 addTarget:self action:@selector(thirdBtnx1Click) forControlEvents:UIControlEventTouchUpInside];
    thirdBtnx1.tag = 103;
    [_scrollV addSubview:thirdBtnx1];
    
    UIButton *thirdBtny1 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtny1.frame = CGRectMake(268,707,40,40);
    thirdBtny1.backgroundColor = [UIColor whiteColor];
    thirdBtny1.layer.cornerRadius =20;
    thirdBtny1.clipsToBounds = YES;
    thirdBtny1.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtny1.layer.borderWidth = 1;
    [thirdBtny1 setTitle:@"Y" forState:UIControlStateNormal];
    [thirdBtny1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtny1.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtny1 addTarget:self action:@selector(thirdBtny1Click) forControlEvents:UIControlEventTouchUpInside];
    thirdBtny1.tag = 104;
    [_scrollV addSubview:thirdBtny1];
    
    UIButton *thirdBtnz1 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtnz1.frame = CGRectMake(327,707,40,40);
    thirdBtnz1.backgroundColor = [UIColor whiteColor];
    thirdBtnz1.layer.cornerRadius =20;
    thirdBtnz1.clipsToBounds = YES;
    thirdBtnz1.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtnz1.layer.borderWidth = 1;
    [thirdBtnz1 setTitle:@"Z" forState:UIControlStateNormal];
    [thirdBtnz1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtnz1.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtnz1 addTarget:self action:@selector(thirdBtnz1Click) forControlEvents:UIControlEventTouchUpInside];
    thirdBtnz1.tag = 105;
    [_scrollV addSubview:thirdBtnz1];
    
    UIButton *thirdBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn2.frame = CGRectMake(18,777,150,40);
    thirdBtn2.backgroundColor = [UIColor whiteColor];
    thirdBtn2.layer.cornerRadius =20;
    thirdBtn2.clipsToBounds = YES;
    thirdBtn2.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtn2.layer.borderWidth = 1;
    [thirdBtn2 setTitle:@"取反" forState:UIControlStateNormal];
    [thirdBtn2 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn2.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn2 addTarget:self action:@selector(thirdBtn2Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn2];
    
    UIButton *thirdBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn3.frame = CGRectMake(210,777,150,40);
    thirdBtn3.backgroundColor = [UIColor whiteColor];
    thirdBtn3.layer.cornerRadius =20;
    thirdBtn3.clipsToBounds = YES;
    thirdBtn3.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtn3.layer.borderWidth = 1;
    [thirdBtn3 setTitle:@"取反" forState:UIControlStateNormal];
    [thirdBtn3 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn3.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn3 addTarget:self action:@selector(thirdBtn3Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn3];
    
    UILabel *lastL = [[UILabel alloc]initWithFrame:CGRectMake(120,858,140, 30)];
    lastL.text = @"电机启动测试";
    lastL.textAlignment = 1;
    lastL.font = [UIFont systemFontOfSize:16];
   // lastL.textColor = [UIColor lightTextColor];
    [_scrollV addSubview:lastL ];

    
    UIButton *thirdBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn4.frame = CGRectMake(45,914,100,40);
    thirdBtn4.backgroundColor = [UIColor whiteColor];
    thirdBtn4.layer.cornerRadius =20;
    thirdBtn4.clipsToBounds = YES;
    thirdBtn4.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtn4.layer.borderWidth = 1;
    [thirdBtn4 setTitle:@"正向" forState:UIControlStateNormal];
    [thirdBtn4 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn4.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn4 addTarget:self action:@selector(thirdBtn4Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn4];
    
    UIButton *thirdBtn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn5.frame = CGRectMake(235,914,100,40);
    thirdBtn5.backgroundColor = [UIColor whiteColor];
    thirdBtn5.layer.cornerRadius =20;
    thirdBtn5.clipsToBounds = YES;
    thirdBtn5.layer.borderColor = [UIColor lightTextColor].CGColor;
    thirdBtn5.layer.borderWidth = 1;
    [thirdBtn5 setTitle:@"反向" forState:UIControlStateNormal];
    [thirdBtn5 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdBtn5.titleLabel.font = [UIFont systemFontOfSize:20];
    [thirdBtn5 addTarget:self action:@selector(thirdBtn5Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollV addSubview:thirdBtn5];

}

- (void)thirdBtn1Click
{
    NSLog(@"3");
}

- (void)thirdBtn2Click
{
    NSLog(@"取反");
}

- (void)thirdBtn3Click
{
    NSLog(@"取反1");
}

- (void)thirdBtn4Click
{
    NSLog(@"正向");
}

- (void)thirdBtn5Click
{
    NSLog(@"反向");
}
- (void)thirdBtnxClick
{
    UIButton *xBtn = [_scrollV viewWithTag:100];
     UIButton *yBtn = [_scrollV viewWithTag:101];
     UIButton *zBtn = [_scrollV viewWithTag:102];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor greenColor];
}

- (void)thirdBtnyClick
{
    UIButton *xBtn = [_scrollV viewWithTag:100];
    UIButton *yBtn = [_scrollV viewWithTag:101];
    UIButton *zBtn = [_scrollV viewWithTag:102];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor redColor];
}

- (void)thirdBtnzClick
{
    UIButton *xBtn = [_scrollV viewWithTag:100];
    UIButton *yBtn = [_scrollV viewWithTag:101];
    UIButton *zBtn = [_scrollV viewWithTag:102];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor yellowColor];
}
- (void)thirdBtnx1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor magentaColor];
}

- (void)thirdBtny1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor orangeColor];
}

- (void)thirdBtnz1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor cyanColor];
   
}


- (void)thirdBtnClick
{
     NSMutableData *mData = [NSMutableData new];
    Byte byte[] = {0x55,0xaa,0x03,0x05,0x54,0x13};
    [mData appendBytes:byte length:6];
    
//[mData appendData:_firstData];
    [mData appendBytes:codeBtye length:1];
    NSLog(@"firstData : %@",_firstData);
  //  Byte *byte2 = (Byte *)[_firstData bytes];
    
    Byte byte1[4];
    byte1[0] = [_textF.text integerValue]/256;
    byte1[1] = [_textF.text integerValue]%256;
    byte1[2] = 0x03^0x05^0x54^0x13^codeBtye[0]^byte1[0]^byte1[1];
    byte1[3] = 0xf0;
    [mData appendBytes:byte1 length:4];
  
    [self.discoverPeripheral writeValue:mData forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"电机零位校准%@",mData);
}
- (void)fourthBtnClick
{
    NSLog(@"2");
}

- (void)tapScroll
{
    [_textF resignFirstResponder];
    [_textF1 resignFirstResponder];
}


- (void)firstBtnClick:(UIButton *)firstBtn
{
    _firstData = [NSMutableData data];
    
//    NSArray *arr = @[@"X",@"Y",@"Z"];
//    NSString *titleStr =[NSString new];
//    CLDropDownMenu *dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:((UIButton *)firstBtn).frame Pressed:^(NSInteger index)
//    {
//        [firstBtn setTitle:arr[index] forState:UIControlStateNormal];
//    }];
//    dropMenu.direction = CLDirectionTypeBottom;
//    dropMenu.titleList =arr;
//    [self.view addSubview:dropMenu];
//    
    if ([firstBtn.titleLabel.text isEqualToString:@"单板调试"]) {
        Byte byte[1] = {0x04};
        [_firstData appendBytes:byte length:1];
        codeBtye[0] = 0x04;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"X"])
    {
        Byte byte[1] = {0x01};
        [_firstData appendBytes:byte length:1];
        codeBtye[0] = 0x01;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Y"])
    {
        Byte byte[1] = {0x02};
        [_firstData appendBytes:byte length:1];
        codeBtye[0] = 0x02;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Z"])
    {
        Byte byte[1] = {0x03};
        [_firstData appendBytes:byte length:1];
        codeBtye[0] = 0x03;
    }

    
    
}

-(void)didTapLLSwitch:(LLSwitch *)llSwitch {
    NSLog(@"start");
}

- (void)animationDidStopForLLSwitch:(LLSwitch *)llSwitch {
    if (llSwitch.on == YES) {
        Byte byte[] = {0x55,0xaa,0x03,0x04,0x53,0x51,0x01,0x03^0x04^0x53^0x51^0x01,0xf0};
        [self.discoverPeripheral writeValue:[NSData dataWithBytes:byte length:9] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"电机板进入debug模式:%@",[NSData dataWithBytes:byte length:9]);
    }
    else
    {
        Byte byte[] = {0x55,0xaa,0x03,0x04,0x53,0x51,0x02,0x03^0x04^0x53^0x51^0x02,0xf0};
        [self.discoverPeripheral writeValue:[NSData dataWithBytes:byte length:9] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
         NSLog(@"电机板退出debug模式:%@",[NSData dataWithBytes:byte length:9]);
    }

}

@end
