//
//  JXTalkViewController.h
//  shiku_im
//
//  Created by p on 2019/6/18.
//  Copyright © 2019年 Reese. All rights reserved.
// 
#import "WH_admob_WHViewController.h"


NS_ASSUME_NONNULL_BEGIN

@protocol JXTalkViewControllerDelegate <NSObject>

- (void)talkVCCloseBtnAction;
- (void)talkVCTalkStart;
- (void)talkVCTalkStop;

@end

@interface JXTalkViewController : WH_admob_WHViewController

@property (nonatomic, weak) id<JXTalkViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *roomNum;

@end

NS_ASSUME_NONNULL_END
