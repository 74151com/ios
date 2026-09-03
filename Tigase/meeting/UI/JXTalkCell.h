//
//  JXTalkCell.h
//  shiku_im
//
//  Created by p on 2019/6/18.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXTalkCell : UICollectionViewCell

@property (nonatomic, strong) JXTalkModel *talkModel;

- (void)talkVCCloseBtnAction:(JXTalkModel *)talkModel indexPJoinMeet:(NSInteger )userId  indexRow:(NSInteger )indexRow;;
@end

NS_ASSUME_NONNULL_END
