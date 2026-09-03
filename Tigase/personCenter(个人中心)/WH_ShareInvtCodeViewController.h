//
//  WH_ShareInvtCodeViewController.h
//  Tigase
//
//  Created by os on 2023/9/29.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_ShareInvtCodeViewController : WH_admob_WHViewController

@property (nonatomic ,strong) UIView *wh_baseView;
@property (nonatomic ,strong) UIView *wh_contentView;

@property (nonatomic, copy) NSString * wh_userId; 

@property (nonatomic, copy) NSString * wh_nickName;
@property (nonatomic, copy) NSString * wh_roomJId;

@property (nonatomic ,strong) UIImageView *wh_qrImageView;

@property (nonatomic,copy) NSString *wh_groupNum;

@property (nonatomic ,strong) WH_RoomData *groupRoom;
@end

NS_ASSUME_NONNULL_END
