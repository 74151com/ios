//
//  WH_AddWithdrawalAccount_WHVC.m
//  Tigase
//
//  Created by lyj on 2019/11/20.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_AddWithdrawa_BankVc.h"
#import "WH_JXSelectFriends_WHVC.h"
#import "WH_DepartObject.h"
 
 
@interface WH_AddWithdrawa_BankVc ()

@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSArray           *wh_titleArray;
@property (nonatomic, strong) NSArray           *wh_placeholderArray;
@property (nonatomic, strong) NSMutableArray    *wh_textFieldArray;
@end

@implementation WH_AddWithdrawa_BankVc
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wh_heightHeader = JX_SCREEN_TOP;
        self.wh_heightFooter = 0;
        self.wh_isGotoBack = YES;
         self.title = @"银行卡提现"; 
    }
    return self;
}

// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
    self.wh_tableBody.backgroundColor = [UIColor whiteColor];
    [self createHeadAndFoot];
    [self customView];
    
}

- (void)customView {
    
   _wh_textFieldArray = [NSMutableArray arrayWithCapacity:1];
 
  //  self.wh_titleArray = @[@"*持卡人姓名", @"*银行卡卡号", @"*银行名称", @"支行名称", @"备注信息"];
  //  self.wh_placeholderArray = @[@"名字", @"银行卡号", @"银行", @"支行(非对公账户可不填)", @"备注"];
    self.wh_titleArray = @[@"*持卡人姓名", @"*银行卡卡号", @"支行名称", @"金额"];
    self.wh_placeholderArray = @[@"名字", @"银行卡号", @"支行名称", @"金额"];
    
    for (int i = 0; i < self.wh_titleArray.count; i++) {
        //标题
        UILabel *wh_titleLabel = [[UILabel alloc] init];
        wh_titleLabel.textColor = HEXCOLOR(0x3A404C);
        wh_titleLabel.text = self.wh_titleArray[i];
        wh_titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self.wh_titleArray[i]];
        [attriStr addAttributes:@{NSForegroundColorAttributeName : HEXCOLOR(0x3A404C)} range:NSMakeRange(0, attriStr.length)];
        NSRange range = [self.wh_titleArray[i] rangeOfString:@"*"];
        [attriStr addAttributes:@{NSForegroundColorAttributeName : HEXCOLOR(0xED6350)} range:range];
        wh_titleLabel.attributedText = attriStr;
        [self.wh_tableBody addSubview:wh_titleLabel];
        [wh_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wh_tableBody).mas_offset(20);
            make.top.equalTo(self.wh_tableBody).mas_offset(55 * i+20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(54.5);
            
        }];
        
        //输入框
        UITextField *wh_textField = [self.view createTF:CGRectZero font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] color:HEXCOLOR(0xD1D6E0) text:@"" place:self.wh_placeholderArray[i]];
        wh_textField.backgroundColor = [UIColor whiteColor];// HEXCOLOR(0x3A404C);
        [self.wh_tableBody addSubview:wh_textField];
        [wh_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wh_tableBody).mas_offset(120);
            make.top.bottom.equalTo(wh_titleLabel);
            //make.right.equalTo(self.wh_tableBody).mas_offset(-5);
            make.width.mas_equalTo(JX_SCREEN_WIDTH-140);
        }];
        [self.wh_textFieldArray addObject:wh_textField];
        
        //分割线
        UIView *wh_lineView = [[UIView alloc] init];
        wh_lineView.backgroundColor = HEXCOLOR(0xF8F8F7);
        [self.wh_tableBody addSubview:wh_lineView];
        [wh_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wh_titleLabel.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.left.right.equalTo(self.wh_tableBody);
            if (i == self.wh_titleArray.count - 1) {
                make.top.equalTo(self.wh_tableBody.mas_bottom);
            }
        }];
    }
   
    UIButton *wh_addAliPayButton = [self.wh_tableBody createBtn:CGRectMake(10, 300, JX_SCREEN_WIDTH - 20, 44) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] color:[UIColor whiteColor] text:@"绑定" img:@"" target:self sel:@selector(WH_bindWithdrawalAccountAction)];
    wh_addAliPayButton.backgroundColor = HEXCOLOR(0x0093FF);
    wh_addAliPayButton.layer.cornerRadius = 10;
    wh_addAliPayButton.layer.masksToBounds = YES;
    [self.wh_tableBody addSubview:wh_addAliPayButton];
    
}
 

#pragma mark -- 绑定提现账号
- (void)WH_bindWithdrawalAccountAction {
   NSLog(@"绑定账号");
    
    UITextField *textField0 = _wh_textFieldArray[0];
    UITextField *textField1 = _wh_textFieldArray[1];
    UITextField *textField2 = _wh_textFieldArray[2];
    UITextField *textField3 = _wh_textFieldArray[3];
//    UITextField *textField4 = _wh_textFieldArray[4];
    if (textField0.text.length == 0) {
        [g_App showAlert:@"请输入姓名"];
        return;
    }
    if (textField1.text.length == 0) {
        [g_App showAlert:@"请输入银行卡号"];
        return;
    }
    if (textField2.text.length == 0) {
        [g_App showAlert:@"请输入银行名称"];
        return;
    }
    NSDictionary *param = @{@"contextType":@"5", @"contextName":[NSString stringWithFormat:@"%@", textField0.text], @"contextNo":[NSString stringWithFormat:@"%@", textField1.text],@"contextBankName":[NSString stringWithFormat:@"%@", textField2.text],@"money":[NSString stringWithFormat:@"%@", textField3.text]};
    
   
     [g_server WH_wh_act_transferRecordAddParam:param toView:self];
   
   
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
   
    [g_server showMsg:@"提现成功,待管理员审核"];
    
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return WH_show_error;
}
#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    
    return WH_show_error;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
