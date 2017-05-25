//
//  OneViewController.m
//  AdjustUltis
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "OneViewController.h"
#import "LLSwitch.h"
#import "DisperseBtn.h"
#import "LCBlueTManager.h"

@interface OneViewController () <LLSwitchDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollV;
    Byte codeBtye[1];
    Byte settingCode[1];
    Byte directionByte[1];
    Byte xyzByte1[1];
    Byte xyzByte2[2];
    NSTimer *_timer;
}

@property(nonatomic,strong)UITextField *textF;
@property(nonatomic,strong)UITextField *textF1;
@property(nonatomic,strong)NSMutableData *firstData;
@property (weak, nonatomic) DisperseBtn *disView;
@property (weak, nonatomic) DisperseBtn *disView1;
@property (weak, nonatomic) DisperseBtn *disView2;
@property (weak, nonatomic) DisperseBtn *disView3;


@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if ([_textF1.text integerValue] >9000||[_textF1.text integerValue]<-9000) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"啊哦" message:@"力矩范围值为 -900 ~ 900,您的输入有误，请检查！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionBtn = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _textF1.text =nil;
        }];
        [alertVC addAction:actionBtn];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    return YES;
}
- (void)configUI
{
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1.35*self.view.frame.size.height)];
    imgV.image = [UIImage imageNamed:@"bgImg1.jpg"];
    
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    // _scrollV .backgroundColor = [UIColor redColor];
    _scrollV.contentSize =CGSizeMake(self.view.frame.size.width,1.45*self.view.frame.size.height);
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
    firstL.font = [UIFont systemFontOfSize:17];
    [_scrollV addSubview:firstL];
    
    UILabel *secondL = [[UILabel alloc]initWithFrame:CGRectMake(20,110,70,40)];
    secondL.text = @"电机编码";
    secondL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:secondL];
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(98, 105,50,50);
    firstBtn.backgroundColor = [UIColor whiteColor];
    firstBtn.layer.cornerRadius =25;
    firstBtn.clipsToBounds = YES;
    firstBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
    firstBtn.layer.borderWidth = 1;
    [firstBtn setTitle:@"单板" forState:UIControlStateNormal];
    [firstBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    firstBtn.tag = 106;
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    if ([firstBtn.titleLabel.text isEqualToString:@"单板"]) {
        codeBtye[0] = 0x04;
    }
    
    [_scrollV addSubview:firstBtn];
    
    UILabel *thirdL = [[UILabel alloc]initWithFrame:CGRectMake(200,110,70,40)];
    thirdL.text = @"磁链值";
    thirdL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:thirdL];
    
    _textF = [[UITextField alloc]initWithFrame:CGRectMake(265, 115, 80, 30)];
    _textF.keyboardType = UIKeyboardTypeDecimalPad;
    _textF.borderStyle = UITextBorderStyleRoundedRect;
    _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textF.text = @"900";
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
    firstLL.font = [UIFont systemFontOfSize:17];
    [_scrollV addSubview:firstLL];
    
    UILabel *secondLL = [[UILabel alloc]initWithFrame:CGRectMake(20,410,70,40)];
    secondLL.text = @"电机编码";
    secondLL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:secondLL];
    
    UIButton *firstBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn1.frame = CGRectMake(98, 405, 50, 50);
    firstBtn1.backgroundColor = [UIColor whiteColor];
    firstBtn1.layer.cornerRadius =25;
    firstBtn1.clipsToBounds = YES;
    firstBtn1.layer.borderColor = [UIColor lightTextColor].CGColor;
    firstBtn1.layer.borderWidth = 1;
    [firstBtn1 setTitle:@"单板" forState:UIControlStateNormal];
    [firstBtn1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    firstBtn1.tag = 107;
    firstBtn1.titleLabel.font = [UIFont systemFontOfSize:20];
    [firstBtn1 addTarget:self action:@selector(firstBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
   [_scrollV addSubview:firstBtn1];
    
    if ([firstBtn.titleLabel.text isEqualToString:@"单板"]) {
        Byte byte[1] = {0x04};
        [_firstData appendBytes:byte length:1];
        settingCode[0] = 0x04;
    }

    
    UILabel *thirdLL = [[UILabel alloc]initWithFrame:CGRectMake(200,410,70,40)];
    thirdLL.text = @"力矩值";
    thirdLL.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:thirdLL];
    
    _textF1 = [[UITextField alloc]initWithFrame:CGRectMake(265, 415, 80, 30)];
    _textF1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _textF1.borderStyle = UITextBorderStyleRoundedRect;
    _textF1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textF1.delegate = self;
    [_scrollV addSubview:_textF1];
    
    
    
    UIButton *thirdBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn1.frame = CGRectMake(275/2,475,100,40);
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
    
    UILabel *fourthLL = [[UILabel alloc]initWithFrame:CGRectMake(157,525,60,20)];
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
    
//    UILabel *lineL3 = [[UILabel alloc]initWithFrame:CGRectMake(190,630,1,220)];
//    lineL3.backgroundColor = [UIColor lightTextColor];
//    [_scrollV addSubview:lineL3];
    
    UILabel *lineL4 = [[UILabel alloc]initWithFrame:CGRectMake(0,940,375,1)];
    lineL4.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL4];
    
    UILabel *lineL5 = [[UILabel alloc]initWithFrame:CGRectMake(0,790,375,1)];
    lineL5.backgroundColor = [UIColor lightTextColor];
    [_scrollV addSubview:lineL5];
    


    UILabel *firstL1 = [[UILabel alloc]initWithFrame:CGRectMake(116, 640, 150, 30)];
    firstL1.text = @" 设置电机转动方向";
    firstL1.textAlignment =1;
    firstL1.font = [UIFont systemFontOfSize:17];
    [_scrollV addSubview:firstL1];
    
    UILabel *firstL2 = [[UILabel alloc]initWithFrame:CGRectMake(116,800, 150, 30)];
    firstL2.text = @"设置电角度方向";
    firstL2.textAlignment =1;
    firstL2.font = [UIFont systemFontOfSize:17];
    [_scrollV addSubview:firstL2];
    
    UILabel *firstL3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 700, 70,40)];
    firstL3.text = @" 电机编号";
    firstL3.textAlignment =1;
    firstL3.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstL3];
    
    UILabel *firstL4 = [[UILabel alloc]initWithFrame:CGRectMake(20,850, 70, 40)];
    firstL4.text = @"电机编号";
    firstL4.textAlignment =1;
    firstL4.font = [UIFont systemFontOfSize:16];
    [_scrollV addSubview:firstL4];
    
//    UIButton *thirdBtnx = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtnx.frame = CGRectMake(13,707,40,40);
//    thirdBtnx.backgroundColor = [UIColor whiteColor];
//    thirdBtnx.layer.cornerRadius =20;
//    thirdBtnx.clipsToBounds = YES;
//    thirdBtnx.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtnx.layer.borderWidth = 1;
//    [thirdBtnx setTitle:@"X" forState:UIControlStateNormal];
//    [thirdBtnx setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtnx.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtnx addTarget:self action:@selector(thirdBtnxClick) forControlEvents:UIControlEventTouchUpInside];
//    thirdBtnx.tag = 100;
//    [_scrollV addSubview:thirdBtnx];
//    
//    UIButton *thirdBtny = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtny.frame = CGRectMake(75,707,40,40);
//    thirdBtny.backgroundColor = [UIColor whiteColor];
//    thirdBtny.layer.cornerRadius =20;
//    thirdBtny.clipsToBounds = YES;
//    thirdBtny.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtny.layer.borderWidth = 1;
//    [thirdBtny setTitle:@"Y" forState:UIControlStateNormal];
//    [thirdBtny setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtny.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtny addTarget:self action:@selector(thirdBtnyClick) forControlEvents:UIControlEventTouchUpInside];
//     thirdBtny.tag = 101;
//    [_scrollV addSubview:thirdBtny];
//    
//    UIButton *thirdBtnz = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtnz.frame = CGRectMake(135,707,40,40);
//    thirdBtnz.backgroundColor = [UIColor whiteColor];
//    thirdBtnz.layer.cornerRadius =20;
//    thirdBtnz.clipsToBounds = YES;
//    thirdBtnz.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtnz.layer.borderWidth = 1;
//    [thirdBtnz setTitle:@"Z" forState:UIControlStateNormal];
//    [thirdBtnz setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtnz.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtnz addTarget:self action:@selector(thirdBtnzClick) forControlEvents:UIControlEventTouchUpInside];
//     thirdBtnz.tag = 102;
//    [_scrollV addSubview:thirdBtnz];
    
    
//    UIButton *thirdBtnx1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtnx1.frame = CGRectMake(210,707,40,40);
//    thirdBtnx1.backgroundColor = [UIColor whiteColor];
//    thirdBtnx1.layer.cornerRadius =20;
//    thirdBtnx1.clipsToBounds = YES;
//    thirdBtnx1.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtnx1.layer.borderWidth = 1;
//    [thirdBtnx1 setTitle:@"X" forState:UIControlStateNormal];
//    [thirdBtnx1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtnx1.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtnx1 addTarget:self action:@selector(thirdBtnx1Click) forControlEvents:UIControlEventTouchUpInside];
//    thirdBtnx1.tag = 103;
//    [_scrollV addSubview:thirdBtnx1];
//    
//    UIButton *thirdBtny1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtny1.frame = CGRectMake(268,707,40,40);
//    thirdBtny1.backgroundColor = [UIColor whiteColor];
//    thirdBtny1.layer.cornerRadius =20;
//    thirdBtny1.clipsToBounds = YES;
//    thirdBtny1.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtny1.layer.borderWidth = 1;
//    [thirdBtny1 setTitle:@"Y" forState:UIControlStateNormal];
//    [thirdBtny1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtny1.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtny1 addTarget:self action:@selector(thirdBtny1Click) forControlEvents:UIControlEventTouchUpInside];
//    thirdBtny1.tag = 104;
//    [_scrollV addSubview:thirdBtny1];
//    
//    UIButton *thirdBtnz1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    thirdBtnz1.frame = CGRectMake(327,707,40,40);
//    thirdBtnz1.backgroundColor = [UIColor whiteColor];
//    thirdBtnz1.layer.cornerRadius =20;
//    thirdBtnz1.clipsToBounds = YES;
//    thirdBtnz1.layer.borderColor = [UIColor lightTextColor].CGColor;
//    thirdBtnz1.layer.borderWidth = 1;
//    [thirdBtnz1 setTitle:@"Z" forState:UIControlStateNormal];
//    [thirdBtnz1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//    thirdBtnz1.titleLabel.font = [UIFont systemFontOfSize:20];
//    [thirdBtnz1 addTarget:self action:@selector(thirdBtnz1Click) forControlEvents:UIControlEventTouchUpInside];
//    thirdBtnz1.tag = 105;
//    [_scrollV addSubview:thirdBtnz1];
//    
    UIButton *reviseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    reviseBtn.frame = CGRectMake(100,695,50,50);
    reviseBtn.backgroundColor = [UIColor whiteColor];
    reviseBtn.layer.cornerRadius =25;
    reviseBtn.clipsToBounds = YES;
    reviseBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
    reviseBtn.layer.borderWidth = 1;
    [reviseBtn setTitle:@"单板" forState:UIControlStateNormal];
    [reviseBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    reviseBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [reviseBtn addTarget:self action:@selector(reviseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    reviseBtn.tag = 1000;
    [_scrollV addSubview:reviseBtn];

    UIButton *thirdBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn2.frame = CGRectMake(225,700,100,40);
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
    
    
    UIButton *reviseBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    reviseBtn1.frame = CGRectMake(100,845,50,50);
    reviseBtn1.backgroundColor = [UIColor whiteColor];
    reviseBtn1.layer.cornerRadius =25;
    reviseBtn1.clipsToBounds = YES;
    reviseBtn1.layer.borderColor = [UIColor lightTextColor].CGColor;
    reviseBtn1.layer.borderWidth = 1;
    [reviseBtn1 setTitle:@"单板" forState:UIControlStateNormal];
    [reviseBtn1 setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    reviseBtn1.titleLabel.font = [UIFont systemFontOfSize:20];
    [reviseBtn1 addTarget:self action:@selector(reviseBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    reviseBtn1.tag = 1001;
    [_scrollV addSubview:reviseBtn1];

    UIButton *thirdBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn3.frame = CGRectMake(225,850,100,40);
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
    
    UILabel *lastL = [[UILabel alloc]initWithFrame:CGRectMake(120,950,140, 30)];
    lastL.text = @"电机启动测试";
    lastL.textAlignment = 1;
    lastL.font = [UIFont systemFontOfSize:17];
   // lastL.textColor = [UIColor lightTextColor];
    [_scrollV addSubview:lastL ];

    
    UIButton *thirdBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    thirdBtn4.frame = CGRectMake(45,1000,100,40);
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
    thirdBtn5.frame = CGRectMake(235,1000,100,40);
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

- (void)setDisViewButtonsNum:(int)num{
    
    [_disView recoverBotton];
    
    for (UIView *btn in _disView.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *arr = @[@"X",@"Y",@"Z"];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius =20;
        btn.layer.masksToBounds = YES;
        
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView.btns = [marr copy];
}

- (void)setDisViewButtonsNum1:(int)num{
    
    [_disView1 recoverBotton];
    
    for (UIView *btn in _disView1.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *arr = @[@"X",@"Y",@"Z"];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius =20;
        btn.layer.masksToBounds = YES;
        
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(button1Tagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView1.btns = [marr copy];
}

- (void)setDisViewButtonsNum2:(int)num{
    
    [_disView2 recoverBotton];
    
    for (UIView *btn in _disView2.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *arr = @[@"X",@"Y",@"Z"];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius =20;
        btn.layer.masksToBounds = YES;
        
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(button2Tagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView2.btns = [marr copy];
}


- (void)setDisViewButtonsNum3:(int)num{
    
    [_disView3 recoverBotton];
    
    for (UIView *btn in _disView3.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *arr = @[@"X",@"Y",@"Z"];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius =20;
        btn.layer.masksToBounds = YES;
        
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(button3Tagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView3.btns = [marr copy];
}



-(void)buttonTagget:(UIButton *)sender{
    [self.disView recoverBotton];
    UIButton *btn = [_scrollV viewWithTag:106];
    switch (sender.tag+1) {
        case 1:
        {
            [btn setTitle:@"X" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btn setTitle:@"Y" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [btn setTitle:@"Z" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
     [_scrollV sendSubviewToBack:self.disView];
}

- (void)button1Tagget:(UIButton *)sender
{
    [self.disView1 recoverBotton];
    UIButton *btn = [_scrollV viewWithTag:107];
    NSLog(@"%ld",sender.tag+1);
    switch (sender.tag+1) {
        case 1:
        {
            [btn setTitle:@"X" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btn setTitle:@"Y" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [btn setTitle:@"Z" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [_scrollV sendSubviewToBack:self.disView1];
}

- (void)button2Tagget:(UIButton *)sender
{
    [self.disView2 recoverBotton];
    UIButton *btn = [_scrollV viewWithTag:1000];
    NSLog(@"%ld",sender.tag+1);
    switch (sender.tag+1) {
        case 1:
        {
            [btn setTitle:@"X" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btn setTitle:@"Y" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [btn setTitle:@"Z" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [_scrollV sendSubviewToBack:self.disView2];
}

- (void)button3Tagget:(UIButton *)sender
{
    [self.disView3 recoverBotton];
    UIButton *btn = [_scrollV viewWithTag:1001];
    NSLog(@"%ld",sender.tag+1);
    switch (sender.tag+1) {
        case 1:
        {
            [btn setTitle:@"X" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btn setTitle:@"Y" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [btn setTitle:@"Z" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [_scrollV sendSubviewToBack:self.disView3];
    
}


- (void)thirdBtn1Click
{
     UIButton *firstBtn1 = [_scrollV viewWithTag:107];
    if ([firstBtn1.titleLabel.text isEqualToString:@"单板"]) {
        
        settingCode[0] = 0x04;
    }
    else if ([firstBtn1.titleLabel.text isEqualToString:@"Y"])
    {
        settingCode[0] = 0x01;
    }
    else if ([firstBtn1.titleLabel.text isEqualToString:@"Z"])
    {
        settingCode[0] = 0x02;
    }
    else if ([firstBtn1.titleLabel.text isEqualToString:@"X"])
    {
        settingCode[0] = 0x03;
    }
    
    Byte byte[]= {0x55,0xaa,0x01,0x05,0x53,0x03,settingCode[0]};
    NSMutableData *mData = [NSMutableData new];
    [mData appendBytes:byte length:7];
    
    Byte byte1[4];
    byte1[0] = [_textF1.text integerValue]/256;
    byte1[1] = [_textF1.text integerValue]%256;
    byte1[2] = 0x01^0x05^0x53^0x03^settingCode[0]^byte1[0]^byte1[1];
    byte1[3] = 0xf0;
    [mData appendBytes:byte1 length:4];
    
    [[LCBlueTManager getInstance] sendInfoData:mData];
    
    NSLog(@"电机力矩测试 %@",mData);
}

- (void)thirdBtn2Click
{

    UIButton *rBtn = [_scrollV viewWithTag:1000];
    if ([rBtn.titleLabel.text isEqualToString:@"X"]) {
        [self sendDataWithIndex:1 andCount:1 andReviseIndex:1];
    }
    else if ([rBtn.titleLabel.text isEqualToString:@"Y"])
    {
        [self sendDataWithIndex:2 andCount:1 andReviseIndex:1];
    }
    else if ([rBtn.titleLabel.text isEqualToString:@"Z"])
    {
       [self sendDataWithIndex:3 andCount:1 andReviseIndex:1];
    }else if ([rBtn.titleLabel.text isEqualToString:@"单板"])
    {
         [self sendDataWithIndex:7 andCount:1 andReviseIndex:1];
    }
}

- (void)thirdBtn3Click
{
    UIButton *rBtn = [_scrollV viewWithTag:1001];
    if ([rBtn.titleLabel.text isEqualToString:@"X"]) {
        [self sendDataWithIndex:4 andCount:2 andReviseIndex:1];
    }
    else if ([rBtn.titleLabel.text isEqualToString:@"Y"])
    {
        [self sendDataWithIndex:5 andCount:2 andReviseIndex:1];
    }
    else if ([rBtn.titleLabel.text isEqualToString:@"Z"])
    {
        [self sendDataWithIndex:6 andCount:2 andReviseIndex:1];
    }else if ([rBtn.titleLabel.text isEqualToString:@"单板"])
    {
        [self sendDataWithIndex:8 andCount:2 andReviseIndex:1];
    }
}


- (void)reviseBtnClick:(UIButton *)btn
{
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(98, 680, 50,50);
    disView.center =CGPointMake(btn.center.x,btn.center.y);
    disView.borderRect = _scrollV.frame;
    //设置两个状态对应的图片
    [_scrollV addSubview:disView];
    
    _disView2 = disView;
    [self setDisViewButtonsNum2:3];
    [self.disView2 disperse];
}

- (void)reviseBtn1Click:(UIButton *)btn
{
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(100,850, 50,50);
    disView.center =CGPointMake(btn.center.x,btn.center.y);
    disView.borderRect = _scrollV.frame;
    //设置两个状态对应的图片
    [_scrollV addSubview:disView];
    
    _disView3 = disView;
    [self setDisViewButtonsNum3:3];
    [self.disView3 disperse];
    
}
- (void)thirdBtn4Click
{
    Byte byte[]= {0x55,0xaa,0x01,0x05,0x53,0x03,0x04};
    
    NSMutableData *mData = [NSMutableData new];
    [mData appendBytes:byte length:7];
    
    Byte byte1[4];
    byte1[0] = 20/256;
    byte1[1] = 20%256;
    byte1[2] = 0x01^0x05^0x53^0x03^0x04^byte1[0]^byte1[1];
    byte1[3] = 0xf0;
    [mData appendBytes:byte1 length:4];
    
    [[LCBlueTManager getInstance] sendInfoData:mData];
    
    NSLog(@"电机启动正向 %@",mData);

}

- (void)thirdBtn5Click
{
    Byte byte[]= {0x55,0xaa,0x01,0x05,0x53,0x03,0x04};
    
    NSMutableData *mData = [NSMutableData new];
    [mData appendBytes:byte length:7];
    
    Byte byte1[4];
    byte1[0] = (-20)/256;
    byte1[1] = (-20)%256;
    byte1[2] = 0x01^0x05^0x53^0x03^0x04^byte1[0]^byte1[1];
    byte1[3] = 0xf0;
    [mData appendBytes:byte1 length:4];
    
    [[LCBlueTManager getInstance] sendInfoData:mData];
    NSLog(@"电机启动反向 %@",mData);
}

- (void)thirdBtnxClick
{
     UIButton *xBtn = [_scrollV viewWithTag:100];
     UIButton *yBtn = [_scrollV viewWithTag:101];
     UIButton *zBtn = [_scrollV viewWithTag:102];
     UIButton *rBtn = [_scrollV viewWithTag:1000];

    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    rBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor greenColor];
    [self sendDataWithIndex:1 andCount:1 andReviseIndex:1];
}

- (void)thirdBtnyClick
{
    UIButton *xBtn = [_scrollV viewWithTag:100];
    UIButton *yBtn = [_scrollV viewWithTag:101];
    UIButton *zBtn = [_scrollV viewWithTag:102];
    UIButton *rBtn = [_scrollV viewWithTag:1000];
     rBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor redColor];
    [self sendDataWithIndex:2 andCount:1 andReviseIndex:1];
}

- (void)thirdBtnzClick
{
    UIButton *xBtn = [_scrollV viewWithTag:100];
    UIButton *yBtn = [_scrollV viewWithTag:101];
    UIButton *zBtn = [_scrollV viewWithTag:102];
    UIButton *rBtn = [_scrollV viewWithTag:1000];
    
    rBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor yellowColor];
    [self sendDataWithIndex:3 andCount:1 andReviseIndex:1];
}
- (void)thirdBtnx1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    UIButton *rBtn = [_scrollV viewWithTag:1001];
    rBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor magentaColor];
    [self sendDataWithIndex:4 andCount:2 andReviseIndex:1];
}

- (void)thirdBtny1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    UIButton *rBtn = [_scrollV viewWithTag:1001];
    rBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor orangeColor];
    [self sendDataWithIndex:5 andCount:2 andReviseIndex:1];
}

- (void)thirdBtnz1Click
{
    UIButton *xBtn = [_scrollV viewWithTag:103];
    UIButton *yBtn = [_scrollV viewWithTag:104];
    UIButton *zBtn = [_scrollV viewWithTag:105];
    UIButton *rBtn = [_scrollV viewWithTag:1001];

    rBtn.backgroundColor = [UIColor whiteColor];
    xBtn.backgroundColor = [UIColor whiteColor];
    yBtn.backgroundColor = [UIColor whiteColor];
    zBtn.backgroundColor = [UIColor cyanColor];
    [self sendDataWithIndex:6 andCount:2 andReviseIndex:1];
   
}

- (void)sendDataWithIndex:(NSInteger)index andCount:(NSInteger)count andReviseIndex:(NSInteger)reviseIndex
{
    if (count == 1)
    {
        if (index == 1)
        {
            xyzByte1[0] = 0x03;
        }else if (index == 2)
        {
            xyzByte1[0] = 0x01;
        }
        else if (index == 3)
        {
            xyzByte1[0] = 0x02;
        }
        else if (index ==7)
        {
            xyzByte1[0] = 0x04;
        }
        if (reviseIndex == 1)
        {
            directionByte[0] = 0x01;

        }else if (reviseIndex ==2)
        {
             directionByte[0] = 0x02;
        }
        
        Byte byte[] = {0x55,0xaa,0x01,0x04,0x54,0x42,xyzByte1[0],directionByte[0],0x01^0x04^0x54^0x42^xyzByte1[0]^directionByte[0],0xf0};
        [[LCBlueTManager getInstance] sendInfoData:[NSData dataWithBytes:byte length:10]];
        NSLog(@"电机转动方向:%@",[NSData dataWithBytes:byte length:10]);
    }
    else if (count == 2)
    {
        if (index == 4)
        {
            xyzByte1[0] = 0x03;
            
        }else if (index == 5)
        {
            xyzByte1[0] = 0x01;
        }
        else if (index == 6)
        {
            xyzByte1[0] = 0x02;
        }
        else if (index ==8)
        {
            xyzByte1[0] = 0x04;
        }
        if (reviseIndex == 1)
        {
            directionByte[0] = 0x01;
            
        }else if (reviseIndex ==2)
        {
            directionByte[0] = 0x02;
        }

        
        Byte byte[] = {0x55,0xaa,0x01,0x04,0x54,0x32,xyzByte1[0],directionByte[0],0x01^0x04^0x54^0x32^xyzByte1[0]^directionByte[0],0xf0};
       [[LCBlueTManager getInstance] sendInfoData:[NSData dataWithBytes:byte length:10]];
        NSLog(@"电角度方向:%@",[NSData dataWithBytes:byte length:10]);
    }
   
}


- (void)thirdBtnClick
{
    UIButton *firstBtn = [_scrollV viewWithTag:106];
    NSMutableData *mData = [NSMutableData new];
    Byte byte[] = {0x55,0xaa,0x01,0x05,0x54,0x13};
    [mData appendBytes:byte length:6];
    
    if ([firstBtn.titleLabel.text isEqualToString:@"单板"]) {

        codeBtye[0] = 0x04;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"X"])
    {
        codeBtye[0] = 0x03;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Y"])
    {
        codeBtye[0] = 0x01;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Z"])
    {
        codeBtye[0] = 0x02;
    }

    [mData appendBytes:codeBtye length:1];
    Byte byte1[4];
    byte1[0] = [_textF.text integerValue]/256;
    byte1[1] = [_textF.text integerValue]%256;
    byte1[2] = 0x01^0x05^0x54^0x13^codeBtye[0]^byte1[0]^byte1[1];
    byte1[3] = 0xf0;
    [mData appendBytes:byte1 length:4];
  
    [[LCBlueTManager getInstance] sendInfoData:mData];
    NSLog(@"电机零位校准%@",mData);
}
- (void)fourthBtnClick
{
     UIButton *firstBtn = [_scrollV viewWithTag:106];
    if ([firstBtn.titleLabel.text isEqualToString:@"单板调试"]) {
        
        codeBtye[0] = 0x04;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"X"])
    {
        codeBtye[0] = 0x03;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Y"])
    {
        codeBtye[0] = 0x01;
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"Z"])
    {
        codeBtye[0] = 0x02;
    }

    
    Byte saveB[] ={0x55,0xaa,0x01,0x03,0x54,0x21,codeBtye[0],0x01^0x03^0x54^0x21^codeBtye[0],0xf0};
    NSData *data = [NSData dataWithBytes:saveB length:9];
   [[LCBlueTManager getInstance] sendInfoData:data];
    NSLog(@"存储电机零位校准 %@",data);
}

- (void)tapScroll
{
    [_textF resignFirstResponder];
    [_textF1 resignFirstResponder];
}


- (void)firstBtnClick:(UIButton *)firstBtn
{
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(98, 405, 50,50);
    disView.center =CGPointMake(firstBtn.center.x, firstBtn.center.y);
    disView.borderRect = self.view.frame;
    //设置两个状态对应的图片
    [_scrollV addSubview:disView];
    
    _disView = disView;
    [self setDisViewButtonsNum:3];
    [self.disView disperse];
}

- (void)firstBtn1Click:(UIButton *)btn
{
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(98, 405, 50,50);
    disView.center =CGPointMake(btn.center.x,btn.center.y);
    disView.borderRect = self.view.frame;
    //设置两个状态对应的图片
    [_scrollV addSubview:disView];
    
    _disView1 = disView;
    [self setDisViewButtonsNum1:3];
    [self.disView1 disperse];
}

-(void)didTapLLSwitch:(LLSwitch *)llSwitch {
    NSLog(@"start");
}

- (void)animationDidStopForLLSwitch:(LLSwitch *)llSwitch {
    if (llSwitch.on == YES)
    {
       _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        
        [_timer fire];
    }
    else
    {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        Byte byte[] = {0x55,0xaa,0x01,0x03,0x53,0x51,0x02,0x01^0x03^0x53^0x51^0x02,0xf0};
        
         NSLog(@"电机板退出debug模式:%@",[NSData dataWithBytes:byte length:9]);
    }
}

- (void)timerRun
{
    Byte byte[] = {0x55,0xaa,0x01,0x03,0x53,0x51,0x01,0x01^0x03^0x53^0x51^0x01,0xf0};
    [[LCBlueTManager getInstance] sendInfoData:[NSData dataWithBytes:byte length:9]];
    NSLog(@"电机板进入debug模式:%@",[NSData dataWithBytes:byte length:9]);
}

@end
