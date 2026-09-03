//
//  TMineNoteBookListVc.h
//  tio-chat-ios
//
//  Created by os on 2023/12/19.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>
  
@class TMineNoteBookListVc;
@protocol noteBookVCDelegate <NSObject>
- (void) noteBookVc:(TMineNoteBookListVc *)weiboVC didSelectWithData:(NSDictionary *)data;
@end


NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteBookListVc : WH_admob_WHViewController
   
@property (nonatomic ,weak) id<noteBookVCDelegate> delegate;
@property (nonatomic, strong) NSDictionary *wh_currentData;

@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isMine;

@end

NS_ASSUME_NONNULL_END
