//
//  TATeamMeViewController.h
//  tio-chat-ios
//
//  Created by os on 2023/8/26.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TATeamLevelCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"


NS_ASSUME_NONNULL_BEGIN

@interface TATeamMeViewController : WH_admob_WHViewController

@property(nonatomic,strong) MJRefreshFooterView *footer;
@property(nonatomic,strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) WH_JXUserObject *user;
@property (nonatomic, strong) NSDictionary *userData;
@end

NS_ASSUME_NONNULL_END
