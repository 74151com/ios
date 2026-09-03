//
//  JXVipOpenSystemVC.m
//  shiku_im
//
//  Created by os on 2023/5/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "JXVipOpenSystemVC.h" 
#import "IWTitleButton.h"
#import "JXVipButton.h"
#import "JXVipOpenSystemCell.h"

@interface JXVipOpenSystemVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UILabel * leftLabel ;
@property (nonatomic,weak) UILabel * btLabel ;//会员有效期

@property (weak, nonatomic) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *myGroupArray;
@property (nonatomic,weak)JXVipButton *selecttitleBtn ;
@end

@implementation JXVipOpenSystemVC



- (id)init
{
    self = [super init];
    if (self) {
       
        self.wh_heightHeader = JX_SCREEN_TOP;
        self.wh_heightFooter = 0;
        self.wh_isGotoBack = YES;
        //会员中心
        //self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT-JX_SCREEN_BOTTOM);
        [self createHeadAndFoot];
        self.title = @"会员服务";
        self.wh_tableBody.backgroundColor =  HEXCOLOR(0xf0eff4);
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形 2"]];
        [self.wh_tableBody addSubview:imageV];
        self.view.backgroundColor = HEXCOLOR(0xf0eff4);
        self.wh_tableBody.scrollEnabled = NO;
        self.wh_tableBody.bounces = NO;
        _myGroupArray = [NSMutableArray array];
        UIView *vipView = [[UIView alloc]init];;
        vipView.autoresizingMask = UIViewAutoresizingNone;
        vipView.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, 11);
       // vipView.user = _user;
        [self.wh_tableBody addSubview:vipView];
  
        [g_server act_vipPaymentConfigListInfo:self page:@"1"];
        
    }
    return self;
}
- (void)createHeadAndFootUIButton:(NSArray *)datalist{
    
    
  /*
    
    {"createTime":1694969024,"id":"65072cc0ce877e57ac8ad867","level":1,"number":1,"price":100}
    */
    CGFloat btnW = 70;
    UIButton *lastBtn = nil;
    for (int i=0; i<datalist.count; i++) {
        NSDictionary *dictitle = datalist[i];
        JXVipButton *titleBtn = [JXVipButton titleButton];
        [titleBtn dictData:dictitle];
        titleBtn.tag =i;
        [self.wh_tableBody addSubview:titleBtn];
        titleBtn.frame = CGRectMake(20,i*(btnW+8)+20, JX_SCREEN_WIDTH-40, btnW);
        lastBtn = titleBtn;
        if(i==0){
            _payCostShow = [dictitle objectForKey:@"id"];
            _priceCostShow= [[dictitle objectForKey:@"price"] intValue];
            titleBtn.selected = YES;
            _selecttitleBtn = titleBtn;
        }
        
        [titleBtn addTarget:self action:@selector(vipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    CGFloat lastY =  CGRectGetMaxY(lastBtn.frame);

    
    UILabel * btLabel = [[UILabel alloc]init];
    btLabel.text = @"";
    btLabel.frame = CGRectMake(20,lastY+30, JX_SCREEN_WIDTH-40, 20);
    btLabel.textColor = [UIColor grayColor];
    btLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [self.wh_tableBody addSubview:btLabel];
    _btLabel = btLabel;
   
    
    
    
    UIButton *openVipBtn = [[UIButton alloc]init];
    openVipBtn.layer.cornerRadius = 25;
    openVipBtn.layer.masksToBounds = YES;
    [openVipBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_submit"] forState:UIControlStateNormal];
    openVipBtn.backgroundColor =[UIColor orangeColor];
    openVipBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [openVipBtn setTitle:@"续费会员" forState:UIControlStateNormal];
    [self.wh_tableBody addSubview:openVipBtn];
    openVipBtn.frame = CGRectMake(20,CGRectGetMaxY(btLabel.frame)+30, JX_SCREEN_WIDTH-40, 50);
    
    [openVipBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [g_server getUser:MY_USER_ID toView:self];
}
/**
 * 会员
 */
- (void)vipBtnClick:(JXVipButton *)btn{
    _selecttitleBtn.selected = NO;
     btn.selected = YES;
    _selecttitleBtn = btn;
    
//    NSArray *tittleArr = @[@{@"yue":@"月费",@"title":@"aaa",@"price":@"30"},
//                           @{@"yue":@"季费",@"title":@"aaa",@"price":@"90"},
//                           @{@"yue":@"年费",@"title":@"aaa",@"price":@"100"}];
//    NSDictionary *dictitle = tittleArr[btn.tag];
//    _leftLabel.text = [NSString stringWithFormat:@"需要支付¥:%@",dictitle[@"price"]];
    
     NSDictionary *dictitle = _myGroupArray[btn.tag];
    _payCostShow = [NSString stringWithFormat:@"%@",dictitle[@"id"]];
    _priceCostShow= [[dictitle objectForKey:@"price"] intValue];
}

/**
 * 续费会员
 */
- (void)backBtnClick:(UIButton *)btn{
     
    NSDictionary *dictitle = _myGroupArray[btn.tag];
     
    if ([g_myself.isPayPassword boolValue]) {
        self.verVC = [WH_JXVerifyPay_WHVC alloc];
        self.verVC.type = JXVerifyTypeVip;
        self.verVC.wh_RMB = [NSString stringWithFormat:@"%d",_priceCostShow];
        self.verVC.wh_titleStr =@"会员";
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
        self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
        self.verVC = [self.verVC init];
        
        UIViewController *lastVC = (UIViewController *)g_navigation.subViews.lastObject;
        [lastVC.view addSubview:self.verVC.view];
    } else {
        WH_JXPayPassword_WHVC *payPswVC = [WH_JXPayPassword_WHVC alloc];
        payPswVC.type = JXPayTypeSetupPassword;
        payPswVC.enterType = JXEnterTypeVipCenter;
        payPswVC = [payPswVC init];
        [g_navigation pushViewController:payPswVC animated:YES];
    }
    
}
- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
- (void)WH_didVerifyPay:(NSString *)sender {
    long time = (long)[[NSDate date] timeIntervalSince1970];
 //   NSString *secret = [self getSecretWithText:sender time:time];
    WH_JXUserObject *user = [[WH_JXUserObject alloc]init];
    user.payPassword = sender;
    [g_server WH_checkPayPasswordWithUser:user toView:self];
}

- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
   NSMutableString *str1 = [NSMutableString string];
   [str1 appendString:APIKEY];
   [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
   //[str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[_countTextField.text doubleValue]]]];
   str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
   
   [str1 appendString:g_myself.userId];
   [str1 appendString:g_server.access_token];
   NSMutableString *str2 = [NSMutableString string];
   str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
   [str1 appendString:str2];
   str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
   
   return [str1 copy];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
 



#pragma 服务端返回数据
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1 {
    [_wait hide];
    if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        if (g_App.myMoney <= _priceCostShow) {
            [g_server showMsg:Localized(@"JX_NotEnough")];
        }else{
            
        }
    }
    
    if( [aDownload.action isEqualToString:wh_act_UserGet] ){
        [g_myself WH_getDataFromDict:dict];
        
        int vips = [[dict objectForKey:@"vip"] intValue];
        
        if(vips>0){
            NSString *expireTime = [dict objectForKey:@"vipEndTime"];
          
            
            _btLabel.text =[NSString stringWithFormat:@"会员过期时间:%@",expireTime];
        }
    }
    if( [aDownload.action isEqualToString:wh_act_CheckPayPassword] ){
        [self WH_dismiss_WHVerifyPayVC];
        
        [g_server   act_purchaseVipinfo:self vipConfigId:_payCostShow];
        
    } else if ([aDownload.action isEqualToString:act_purchaseViinfo]) {
        
        [self WH_dismiss_WHVerifyPayVC];
        [g_server getUser:MY_USER_ID toView:self];
        [g_server showMsg:@"购买会员成功"];
        
    }else if ([aDownload.action isEqualToString:act_vipPaymentConfigList]) {
        
        _myGroupArray = array1.mutableCopy;
        
        [self createHeadAndFootUIButton:array1];
    }
     
    
}
 
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
 
    return WH_show_error;
}


#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
   
    if ([aDownload.action isEqualToString:act_purchaseViinfo]) {
        // 撤回加等待符（撤回接口调用很慢）
        [_wait start];
    }
}

@end
