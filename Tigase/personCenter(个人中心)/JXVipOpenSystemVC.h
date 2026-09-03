//
//  JXVipOpenSystemVC.h
//  shiku_im
//
//  Created by os on 2023/5/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WH_JXVerifyPay_WHVC.h"
#import "WH_JXPayPassword_WHVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXVipOpenSystemVC : WH_admob_WHViewController
 
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;
@property (nonatomic, strong) WH_JXPayPassword_WHVC * payPswVC;

@property (nonatomic, copy) NSString * passwordSelect;
@property (nonatomic, copy) NSString * payCostShow;

@property (nonatomic, assign) int  priceCostShow; 
@end

NS_ASSUME_NONNULL_END

/**
 
UILabel * leftLabel = [[UILabel alloc]init];
leftLabel.text = @"需要支付:30元";
leftLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
[self.view addSubview:leftLabel];
_leftLabel = leftLabel;
leftLabel.frame = CGRectMake(20,lastY+10, JX_SCREEN_WIDTH-40, 30);

_myGroupArray = [NSMutableArray array];
NSArray *payArr = @[@{@"yue":@"月费",@"title":@"aaa",@"price":@"30"}];
[_myGroupArray addObjectsFromArray:payArr];

UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(leftLabel.frame)+10, JX_SCREEN_WIDTH, 60) style:UITableViewStylePlain];
tableView.delegate = self;
tableView.backgroundColor = HEXCOLOR(0xf0eff4);;
tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
tableView.dataSource = self;
[self.view addSubview:tableView];
tableView.scrollEnabled = NO;
_tableView = tableView;


 
 */
