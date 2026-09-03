//
//  TMineVipViewController.m
//  tio-chat-ios
//
//  Created by os on 2023/11/25.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TMineVipViewController.h"
#import "JXScoreButton.h"
#import "TMineVipCell.h"
#import <AlipaySDK/AlipaySDK.h>
 
//UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
@interface TMineVipViewController () < UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UILabel * leftLabel ;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *CenterView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UILabel *totoalLabel;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;



@property (nonatomic, strong) NSMutableArray *myGroupArray;
@property (nonatomic, strong) NSMutableArray *myVipArray;
@property (nonatomic,   weak) JXScoreButton *selecttitleBtn ;
 
@property (nonatomic, strong) NSString *palVipMoneyId;
@end

@implementation TMineVipViewController
 
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"vip";
        
    }
    return self;
}
- (void)chanpinNot{
  [g_App showAlert:@"ProductID为无效ID"];
    
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myGroupArray = [NSMutableArray array];
    _myVipArray = [NSMutableArray array];
    [g_notify addObserver:self selector:@selector(chanpinNot) name:@"chanpinidwuxiao" object:nil];
 
    self.view.backgroundColor = [UIColor blackColor];// [UIColor colorWithHex:0xF8F8F8];;
    // Do any adURL    http://198.44.160.137:6060/mytio/user/curr
    [_surePayBtn addTarget:self action:@selector(surePayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _tableView.layer.cornerRadius = 8;
    _tableView.layer.masksToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"TMineVipCell" bundle:nil] forCellReuseIdentifier:@"TMineVipCell"];
    
    NSArray *tittleArr = @[@{@"yue":@"月卡",@"title":@"aaa",@"price":[NSString stringWithFormat:@"%d",18]},
                           @{@"yue":@"季卡",@"title":@"aaa",@"price":[NSString stringWithFormat:@"%d",48]},
                           @{@"yue":@"年卡",@"title":@"aaa",@"price":[NSString stringWithFormat:@"%d",128]}];
  
    
    self.wh_isGotoBack = YES;
    [self createHeadAndFoot];
    self.wh_heightFooter = 0;
    self.wh_tableBody.frame = CGRectZero;
    
    [g_notify addObserver:self selector:@selector(WH_receiveAlipayFinishNotification:) name:@"kAlipayPaymentCallbackNotification" object:nil];
}
- (void)createSubViews:(NSArray *)tittleArr{
    
    CGFloat btnW = (JX_SCREEN_WIDTH -80)/3;
    UIButton *lastBtn = nil;
    for (int i=0; i<tittleArr.count; i++) {
        NSDictionary *dictitle = tittleArr[i];
        JXScoreButton *titleBtn = [JXScoreButton titleButton];
        titleBtn.tag =i;
        [titleBtn dictData:dictitle];
        titleBtn.indexBtn = i;
        [_CenterView addSubview:titleBtn];
        titleBtn.frame = CGRectMake(i*(btnW+20) ,10,btnW, btnW+30);
        lastBtn = titleBtn;
        if(i==0){
            titleBtn.selected = YES;
            _selecttitleBtn = titleBtn;
        }
        
        [titleBtn addTarget:self action:@selector(vipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
- (void)vipBtnClick:(JXScoreButton *)btn{
   _selecttitleBtn.selected = NO;
    btn.selected = YES;
   _selecttitleBtn = btn;
    
    NSDictionary  *configDict =  _myVipArray[_selecttitleBtn.tag];
   _totoalLabel.text = [NSString stringWithFormat:@"¥%@",[configDict objectForKey:@"price"]];
 //   /user/recharge/getSign  原有接口 ，去掉price ,添加参数：String vipConfigId
}

- (void)surePayBtnClick{
   // 开通一个月云聊vip，价格18rmb，享受聊天双向撤回，群发消息功能,可建群数量为300个，群最大人数 5000人，添加人数每天300次
     
    
    if(_myVipArray.count>0){
        
        NSDictionary  *configDict =  _myVipArray[_selecttitleBtn.tag];
       [g_server WH_getPaySignWithPrice:[configDict objectForKey:@"id"] payType:1 toView:self];
    }
 //   /user/recharge/getSign  原有接口 ，去掉price ,添加参数：String vipConfigId
}
 
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _myGroupArray.count;
    
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark   ---------tableView协议----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMineVipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TMineVipCell" forIndexPath:indexPath];
    
    NSDictionary *objuser = _myGroupArray[indexPath.row];
    cell.indexPathRow = indexPath.row;
    cell.dataDict = objuser;
    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [g_server WH_Apia_UservipConfig:@"" toView:self];
    // 会员
}

  
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UservipConfig] ){
         NSArray *vipConfigArr =  [dict objectForKey:@"vipConfig"];
         NSArray *vipPriceListArr =  [dict objectForKey:@"priceList"];
         NSDictionary *vipPriceDict =  vipPriceListArr.firstObject;
        _totoalLabel.text = [NSString stringWithFormat:@"¥%@",[vipPriceDict objectForKey:@"price"]];
        [self createSubViews:vipPriceListArr];
        [_myVipArray addObjectsFromArray:vipPriceListArr];
        
        
         if(vipConfigArr.count>0){
            NSMutableArray *tempArr = vipConfigArr.mutableCopy;
            NSDictionary *topDict = @{
                @"function" : @"功能",
                @"normal" : @"普通会员",
                @"updatetime" :@"2023-12-03 20:58:27",
                @"id" : @1 ,
                @"vip" : @"vip会员",
                @"type" : @0,
                @"createtime" : @"2023-12-03 20:58:27",
                @"roombigestnum" : @"10"};
              [tempArr insertObject:topDict atIndex:0];
              [self->_myGroupArray addObjectsFromArray:tempArr.copy];
             
              [self->_tableView reloadData];
        } 
        
    }
    if ([aDownload.action isEqualToString:wh_act_getSign]) {
        if ([[dict objectForKey:@"package"] isEqualToString:@"Sign=WXPay"]) {
          //  [self tuningWxWith:dict];
        }else {
            [self tuningAlipayWithOrder:[dict objectForKey:@"orderInfo"]];
        }
    }else if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        [g_notify postNotificationName:kUpdateUser_WHNotifaction object:nil];
        [self actionQuit];
    }
    
}

- (void)tuningAlipayWithOrder:(NSString *)signedString {
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"wahu";
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            //未安装支付宝客户端回调
            [g_notify postNotificationName:@"kAlipayPaymentCallbackNotification" object:resultDic];
        }];
    }
}

//微信支付回调处理
-(void)WH_receiveWXPayFinishNotification:(NSNotification *)notifi{
    PayResp *resp = notifi.object;
    switch (resp.errCode) {
        case WXSuccess:{
            [self paySuccessHandler];
            break;
        }
        case WXErrCodeUserCancel:{
            //取消了支付
            break;
        }
        default:{
            //支付错误
            [self payFailedHanlder];
            break;
        }
    }
}

//支付宝0支付回调处理
- (void)WH_receiveAlipayFinishNotification:(NSNotification *)notifi{
    NSDictionary *resultDic = notifi.object;
    
    
    [g_notify postNotificationName:kUpdateUser_WHNotifaction object:self userInfo:nil];
    
    if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
        [self paySuccessHandler];
    } else {
        // 支付失败
        [self payFailedHanlder];
    }
}

//支付成功处理
- (void)paySuccessHandler{
    [g_App showAlert:Localized(@"JXMoney_PaySuccess") delegate:self tag:1001 onlyConfirm:YES];
     
}

//支付失败处理
- (void)payFailedHanlder{
    [JXMyTools showTipView:@"支付失败"];
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
   [_wait start];
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
@end
