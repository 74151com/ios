//
//  JXVipButton.h
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXVipButton : UIButton

+ (instancetype)titleButton;

- (void)dictData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
