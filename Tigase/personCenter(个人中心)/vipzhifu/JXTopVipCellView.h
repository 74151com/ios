//
//  JXTopVipCell.h
//  Tigase
//
//  Created by os on 2024/2/2.
//  Copyright © 2024 Reese. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^VipOpenBlock)(NSString *nameStr,NSString *numStr);
NS_ASSUME_NONNULL_BEGIN

@interface JXTopVipCellView : UIView
 
@property (nonatomic,copy) VipOpenBlock vipblcok;
@property (nonatomic, strong) NSDictionary *userData;

@property (nonatomic, assign) int  vipOpen;
@end

NS_ASSUME_NONNULL_END
