//
//  JXTalkModel.h
//  shiku_im
//
//  Created by p on 2019/6/18.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTalkModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) long talkTime;

@property (nonatomic, assign) int status;
 
@property (nonatomic, copy) NSString *roomId;

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *callId;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
