//
//  UITapGestureRecognizer+TTapBlockAction.h
//  tio-chat-ios
//
//  Created by wuxiaofang on 2023/3/24.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TTapGestureBlock)(UITapGestureRecognizer *gesture);

@interface UITapGestureRecognizer(TTapBlockAction)

+ (instancetype)initTapGestureWithActionBlock:(TTapGestureBlock)action;

@property (nonatomic) TTapGestureBlock tap_block_action;

@end

NS_ASSUME_NONNULL_END
