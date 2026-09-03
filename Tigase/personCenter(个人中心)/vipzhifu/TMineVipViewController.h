//
//  TMineVipViewController.h
//  tio-chat-ios
//
//  Created by os on 2023/11/25.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "TATeamLevelCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface TMineVipViewController : WH_admob_WHViewController

@property (nonatomic, strong) WH_JXUserObject *user;

@property (nonatomic, strong) NSString *invitecode;
@property (nonatomic, strong) NSString *nextCode;


@end

NS_ASSUME_NONNULL_END
