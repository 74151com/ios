//
//  WH_CodeyzfRechargeYISVc.m
//  Tigase
//
//  Created by os on 2023/10/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_CodeyzfRechargeYISVc.h"
#import "WH_QRImage.h"

@interface WH_CodeyzfRechargeYISVc ()

@property (nonatomic, strong) UIImageView * qrImageView;
@end

@implementation WH_CodeyzfRechargeYISVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = NO;
    self.wh_isGotoBack = YES;
    self.title = @"扫码充值";
    [self createHeadAndFoot];
    
    [self.wh_tableBody setBackgroundColor:g_factory.globalBgColor];
    
    self.wh_tableBody.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage * qrImage = [WH_QRImage qrImageForString:_qrcode imageSize:300 logoImage:imageView.image logoImageSize:70];
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake((JX_SCREEN_WIDTH-300)/2, 100, 300, 300)];
    _qrImageView.image = qrImage;
    [self.wh_tableBody addSubview:_qrImageView];
   
    {
        UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrImageView.frame)+12, JX_SCREEN_WIDTH, 20)];
        [mLabel setText:_money];
        [mLabel setTextColor:HEXCOLOR(0x3A404C)];
        [mLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 18]];
        [mLabel setTextAlignment:NSTextAlignmentCenter];
        [self.wh_tableBody addSubview:mLabel];
    }
    
    //我的余额
    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrImageView.frame)+52, JX_SCREEN_WIDTH, 20)];
    [mLabel setText:_payType==1?@"打开支付宝扫一扫":@"打开微信扫一扫"];
    [mLabel setTextColor:HEXCOLOR(0x3A404C)];
    [mLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 14]];
    [mLabel setTextAlignment:NSTextAlignmentCenter];
    [self.wh_tableBody addSubview:mLabel];
  //  [g_server act_codeyzfRechargeYIS:@"0.02" payType:@"1" toView:self];
}



#pragma mark 请求成功
- (void)WH_didServerResult_WHSucces:(WH_JXConnection *)aDownload dict:(NSDictionary *)dict array:(NSArray *)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:wh_act_codeyzfRecharge]) {
        
    }else if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        [g_notify postNotificationName:kUpdateUser_WHNotifaction object:nil];
        [self actionQuit];
    }
}

- (int)WH_didServerResult_WHFailed:(WH_JXConnection *)aDownload dict:(NSDictionary *)dict{
    [_wait stop];
    return WH_show_error;
}

- (int)WH_didServerConnect_WHError:(WH_JXConnection *)aDownload error:(NSError *)error{
    [_wait stop];
    return WH_hide_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}


@end
