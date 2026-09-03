//
//  TPengyouquanListTableViewCell.h
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//
#define CBWeakSelf __weak __typeof__(self) WeakSelf = self;
#define CBStrongSelf __strong __typeof__(self) self = WeakSelf;

#import <UIKit/UIKit.h>
#import "TPengyouquanListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapHeaderImageBlock)(void);

@interface TPengyouquanListTableViewCell : UITableViewCell
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
@property (nonatomic) TapHeaderImageBlock tapHeaderImageBlock;

-(void)setData:(TPengyouquanListModel *)model;

@property (nonatomic, assign) BOOL isPraise; // 是否点赞
@property (nonatomic, assign) BOOL isCollect; // 是否收藏
@end

NS_ASSUME_NONNULL_END
