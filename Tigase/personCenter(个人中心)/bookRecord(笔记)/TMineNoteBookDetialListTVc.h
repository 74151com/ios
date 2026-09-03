//
//  TMineNoteBookDetialListTVc.h
//  Tigase
//
//  Created by os on 2024/2/29.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXMessageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteBookDetialListTVc : WH_admob_WHViewController

@property(nonatomic,strong) WH_JXMessageObject* msg;
@property(nonatomic,strong) NSArray * dictArr;
@property(nonatomic,copy) NSString* titleStr;
@property(nonatomic,copy) NSString* contentStr;
@property(nonatomic,copy) NSString* noteId;

@property (nonatomic, strong) WH_JXVideoPlayer *player;
@end

NS_ASSUME_NONNULL_END
