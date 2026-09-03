//
//  AAShen_RoomInputPwdView.h
//  shiku_im
//
//  Created by hellkit on 2023/3/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PwdBlcok)(NSString * _Nonnull pwd);

NS_ASSUME_NONNULL_BEGIN

@interface AAShen_RoomInputPwdView : UIView

@property (nonatomic, copy) PwdBlcok blockpw;

+(instancetype)XIBAAShen_RoomInputPwdView;
@end

NS_ASSUME_NONNULL_END
