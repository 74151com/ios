//
//  WH_JXTransfer_WHCell.h
//  Tigase_imChatT
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "WH_JXBaseChat_WHCell.h"

@class WH_JXChat_WHViewController;
@interface WH_JXNoteBook_WHCell : WH_JXBaseChat_WHCell 

@property (nonatomic,strong) UIImageView * imageBackground;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * cardHeadImage;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *title;


- (void)sp_getUserFollowSuccess;
@end
