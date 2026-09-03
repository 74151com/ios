//
//  TMineNoteDetialCell.h
//  Tigase
//
//  Created by os on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
 

typedef void(^TapHeaderImageBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteDetialCell : UITableViewCell

@property (nonatomic) TapHeaderImageBlock tapHeaderImageBlock;

@property (nonatomic, strong) UIImageView *mHeaderIV;
@property (nonatomic, strong) UIImageView *mImgPlayIV;
@property (nonatomic, strong) WH_JXVideoPlayer *player;
 

-(void)setData:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
