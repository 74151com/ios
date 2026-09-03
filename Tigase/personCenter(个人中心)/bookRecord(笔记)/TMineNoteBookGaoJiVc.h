//
//  TMineNoteBookGaoJiVc.h
//  Tigase
//
//  Created by os on 2024/2/15.
//  Copyright © 2024 Reese. All rights reserved.
//
#define video_tag -100
#define insert_photo_tag -100000


#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteBookGaoJiVc : WH_admob_WHViewController

@property(nonatomic,retain) NSString* wh_audioFile;
@property(nonatomic,retain) NSString* wh_videoFile;
@property(nonatomic,retain) NSString* wh_fileFile;
@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic, assign) SEL        didSelect;

@property (nonatomic,assign) int wh_maxImageCount;
@property(nonatomic,assign)int  dataType;
@property (nonatomic, assign) BOOL      isEdit;
@property (nonatomic, strong) NSDictionary *dictData;

@property (nonatomic,weak) UIImageView *videoView;
@end

NS_ASSUME_NONNULL_END

/**
 
 - (void)xxx{
     NSArray *images = @[
        ];
     NSArray *images111 = @[ @{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/t/1d48b9fe485841d69163fa12db77bf60.jpg",
         @"type":@"2"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/t/1d48b9fe485841d69163fa12db77bf60.jpg",
         @"type":@"2"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/39ae3b439af4475e820dfaca771a2b91.mp4",
         @"type":@"4"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/39ae3b439af4475e820dfaca771a2b91.mp4",
         @"type":@"4"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/t/1d48b9fe485841d69163fa12db77bf60.jpg",
         @"type":@"2"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/cf7fabcd808c4ab986fe8fe7a9b15da4.mp4",
         @"type":@"4"
     },@{
         @"ourl":@"http://82.157.30.116:8089/u/8/10000008/202402/39ae3b439af4475e820dfaca771a2b91.mp4",
         @"type":@"4"
     }];
     [g_server WH_getact_NoteAddConfigUserId:images body:@"我是内容开始了收 老师老师快递两件事的000" title:@"我是标题222" toView:self];
     
      
  */
     
