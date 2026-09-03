//
//  JXVipButton.h
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXScoreButton : UIButton

@property (nonatomic,assign) int indexBtn;
@property (nonatomic,weak) UILabel * introLabel;

@property (nonatomic,weak) UILabel * orgainPrice;

+ (instancetype)titleButton;

- (void)dictData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
