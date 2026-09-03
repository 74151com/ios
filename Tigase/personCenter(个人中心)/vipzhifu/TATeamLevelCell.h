//
//  TATeamLevelCell.h
//  tio-chat-ios
//
//  Created by os on 2023/8/31.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h> 
typedef void(^TapIconImgBlock)(NSString *userInfo);

NS_ASSUME_NONNULL_BEGIN

@interface TATeamLevelCell : UITableViewCell
 
@property (nonatomic, copy) TapIconImgBlock iconImgBlock;
@property (nonatomic, strong) WH_JXUserObject *user;
@property (nonatomic, strong) NSDictionary *userData;
@end

NS_ASSUME_NONNULL_END
