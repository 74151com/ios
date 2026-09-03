//
//  TMineVipCell.h
//  tio-chat-ios
//
//  Created by os on 2023/11/28.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMineVipCell : UITableViewCell

@property (nonatomic,   copy) NSDictionary *dataDict;
@property (nonatomic,   assign) NSInteger indexPathRow;
@end

NS_ASSUME_NONNULL_END
