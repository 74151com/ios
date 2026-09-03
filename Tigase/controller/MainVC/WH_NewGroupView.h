//
//  WH_NewGroupView.h
//  Tigase
//
//  Created by os on 2024/1/30.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GroupBlock)(NSString *nameStr,NSString *numStr);

NS_ASSUME_NONNULL_BEGIN

@interface WH_NewGroupView : UIView

@property (nonatomic,assign) int   numberStr;
@property (nonatomic,copy) GroupBlock  groupblcok;
@end

NS_ASSUME_NONNULL_END
