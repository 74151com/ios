//
//  TMineNoteListCell.h
//  tio-chat-ios
//
//  Created by os on 2023/12/19.
//  Copyright © 2023 刘宇. All rights reserved.
//
// 行间距
#define kLineSpace 8

#import <UIKit/UIKit.h> 
//#import "YBIBIconManager.h"
//#import "UIImageView+Web.h"
typedef void(^TapHeaderImageBlock)(void);

typedef void(^TapVideoImageBlock)(NSString *oUrltype);

typedef void(^NoteBookEditBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteListCell : UITableViewCell
@property (nonatomic) TapVideoImageBlock tapVideoImageBlock;
@property (nonatomic) TapHeaderImageBlock tapHeaderImageBlock;

@property (nonatomic) NoteBookEditBlock editBlock;
 
@property (nonatomic, strong) UIView *mContentView;
@property (nonatomic, strong) UIImageView *mHeaderIV;
@property (nonatomic, strong) UILabel *mNicknameLbl;
@property (nonatomic, strong) UILabel *mTimeLbl;
@property (nonatomic, strong) UILabel *mContentLbl;
@property (nonatomic, strong) UICollectionViewFlowLayout *mFlowLayout;
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) UIButton *mCommentNumBtn;
@property (nonatomic, strong) UIButton *mLikeBtn;
@property (nonatomic, strong) UIButton *mMoreBtn; 
 
@property (nonatomic, strong) WH_JXVideoPlayer *player;
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic,   copy) void (^switchCallback)(TMineNoteListCell *cell, BOOL open);
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) BOOL hasIndiractor;
@property (nonatomic,   weak) UILabel *vipLabel;
@property (nonatomic,   weak) UILabel *expireLabel;

@property (nonatomic,   copy) NSString *detailText;

-(void)setDatabb:(NSDictionary *)model;

-(void)setData:(NSDictionary *)model;
 
@end

NS_ASSUME_NONNULL_END
