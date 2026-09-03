//
//  JXAVCallViewController.h
//  Tigase_imChatT
//
//  Created by p on 2017/12/26.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h> 
#import <AgoraRtcKit/AgoraRtcKit.h>
 
#import "AgoraModel.h"

@interface JXAVCallGroupVideoViewController : UIViewController//<JitsiMeetViewDelegate>

@property (nonatomic, strong) JXAVCallGroupVideoViewController *pSelf;
@property (nonatomic, weak) NSString *roomNum;
@property (nonatomic, assign) BOOL isAudio;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, copy) NSString *meetUrl;
@property (strong, nonatomic)AgoraModel *model;

@property (nonatomic,strong) NSSet * existSet;
@property (nonatomic, assign) int selelctIndex;
@property (nonatomic, assign) NSUInteger selelctIndexUserId;
@property (nonatomic, assign) NSInteger rxKBitRateIndex;


@property (nonatomic, strong) NSMutableArray *talkArray;
@end
