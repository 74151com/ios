//
//  TPengyouquanVideoCollectionViewCell.h
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TPengyouquanListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPengyouquanVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *mHeaderIV;
-(void)setData:(TPengyouquanListModel *)model;
@end

NS_ASSUME_NONNULL_END
