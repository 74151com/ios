//
//  JXAVCallViewController.m
//  Tigase_imChatT
//
//  Created by p on 2017/12/26.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "JXAVCallGroupViewController.h"
#import "WH_JXMediaObject.h"
#import <ReplayKit/ReplayKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WH_JXSelectFriends_WHVC.h"
#import "WH_JXCustomButton.h"
#import "UIView+Frame.h"
#import "WH_GKNetworking.h"
#import "UIImage+WH_Color.h"
#import "TimeUtil.h"
#import "JXTalkCell.h"
#import "JXTalkModel.h"
#import "WH_JXSelectFriends_WHVC.h"
     
@interface JXAVCallGroupViewController ()<AgoraRtcEngineDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *viewTop;
@property (strong, nonatomic) UIImageView *headerImage;
@property (strong, nonatomic) UILabel *labelStatus;
@property (strong, nonatomic) UILabel *labelRemoteParty;
@property (strong, nonatomic) UIView *viewCenter;
@property (strong, nonatomic) UIImageView *imageSecure;

@property (strong, nonatomic) UIView *viewBottom;
@property (strong, nonatomic) UIButton *buttonHangup;

@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, strong) UIView *localVideoView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *suspenAddBtn; //加人

@property (nonatomic, strong) UIButton *suspensionBtn;
@property (nonatomic, strong) UILabel *suspensionLabel;
@property (nonatomic, strong) UILabel *showTimeLabel;
@property (nonatomic, assign) CGRect subWindowFrame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerIndex;
@property (nonatomic, strong) UIButton *recorderBtn;
@property (nonatomic, strong) RPPreviewViewController *previewVC;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong)AgoraRtcEngineKit *agorakit;
//@property (nonatomic, strong)JXAVCallVideoView *videoView;

@property (nonatomic, strong)UIView *videoBackView;
@property (nonatomic, strong)UIView *remoteVideo;
@property (nonatomic, strong)UIImageView *remoteVideoMutedIndicator;
@property (nonatomic, strong)UIView *localVideo;
@property (nonatomic, strong)UIView *localVideoMutedIndicator;
@property (nonatomic, strong)UIButton *muteButton;
@property (nonatomic, strong)UIButton *hangUpButton;
@property (nonatomic, strong)UIButton *switchCameraButton;

@property (nonatomic, strong) NSString *tokenStr;
@property (nonatomic, strong) NSString *myRoomNumStr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end


#define Button_Width 80
#define Button_Height (Button_Width+20)
#define BtnImage_big 70
#define BtnImage_small 34

@implementation JXAVCallGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    [g_notify addObserver:self selector:@selector(modelargClieck:) name:@"modelarg" object:nil];
    
    //kXMPPShowMsg_WHNotifaction
    
    
    //[g_server getAgoraInfo:self fileName:@""];
    if (_pSelf) {
        return;
    }
    self.view.backgroundColor = [UIColor blackColor];// HEXCOLOR(0x1F2025);
    g_meeting.isMeeting = YES;

    _pSelf = self;
     [self createSuspensionView];
    
    ZKWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL audioMuted = NO;
        BOOL videoMuted = NO;
        NSString *serverStr;
        if (self.isGroup) {
            serverStr = g_config.jitsiServer;
        }else {
            if ([g_config.isOpenCluster integerValue] == 1 && [self.meetUrl length] > 0) {
                serverStr = self.meetUrl;
            }else {
                serverStr = g_config.jitsiServer;
            }
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",serverStr,self.roomNum];
        if (self.isAudio && self.isGroup) {
            url = [NSString stringWithFormat:@"%@audio%@",serverStr,self.roomNum];
        }
        if (self.isAudio) {
            videoMuted = YES;
        }
        if (!_toUserName) {
            _toUserName = self.roomNum;
        }
        //[self creatLocalVideoView];
        
        //声网
        self.tokenStr = @"";
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:MY_USER_ID forKey:@"userId"];
        [tempDic setValue:self.roomNum forKey:@"channelName"];
        self.myRoomNumStr =[NSString stringWithFormat:@"%@",self.roomNum];
//        [g_App showAlert:self.roomNum];
        [self getTokenWithparams:tempDic success:^(id responseObject) {
            NSLog(@"token刷新成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initializeAgoraEngine];
                if (!_isAudio) {
                    _model;
                    [self customView];
                    [self setLocalVideo];
                    [self setupVideo];
                    

                }
                [self joinChannel];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 38, 38)];
                [btn setImage:[UIImage imageNamed:@"callHideN"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(hideAudioView) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
                [self.view bringSubviewToFront:btn];
                
            });
        }failure:^(NSError *error) {
            NSLog(@"token刷新失败");
        }];
       
    });
    
    [g_notify addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsg_WHNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(callEndNotification:) name:kCallEnd_WHNotification object:nil];
    _talkArray;
    _startTime = 0;
    [self networkStatusChange];
    
    __block int count = 40;
    // 队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建定时器
    dispatch_source_t timerGCD = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置时间
    uint64_t start = 2.0;
    uint64_t interval = 1.0;
    dispatch_source_set_timer(timerGCD, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    // 设置回调
    dispatch_source_set_event_handler(timerGCD, ^{
       // NSLog(@"111 %d",count);
        count--;
        if (count <= 0) {
           
            for (int i=0; i<_talkArray.count; i++) {
                JXTalkModel *model = _talkArray[i];
                if([model.type intValue]!=1){
                    [_talkArray removeObjectAtIndex:i];
                    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                     
                }
            }
            dispatch_cancel(timerGCD);
            // 取消定时器
        }
    });
    // 启动定时器
    dispatch_resume(timerGCD);
     

    
     
}
- (void)modelargClieck:(NSNotification *)note{
    
    AgoraModel *dict = note.object;
    _model = dict;
}
- (UILabel *)showTimeLabel{
    if(_showTimeLabel == nil){
        _showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, 20)];
        _showTimeLabel.textColor = THEMECOLOR;
        _showTimeLabel.textAlignment = NSTextAlignmentCenter;
        _showTimeLabel.font = [UIFont systemFontOfSize:13];
        _showTimeLabel.text = @"00:00";
    }
    return _showTimeLabel;
}
- (void)initializeAgoraEngine{
    
//    if (_model==nil) {
//        NSDictionary *dict = [g_default objectForKey:@"currentModel"];
//
//      _model = [AgoraModel mj_objectWithKeyValues:dict];
//    }
    
    
    //zhan
    _model = [[AgoraModel alloc]init];
    _model.appId = @"1224e8e20bcf4c3186b8b7679643131f";
//    _model.ownToken = @"007eJxTYODfIs983HyrxKEOiz9ahxlro6apufHvPMvh0/k0t31nH78Cg6GRkUmqRaqRQVJymkmysaGFWZJFkrmZuaWZibGhsWGamemDlIZARobfvssYGRkgEMRnYTAAAgYGAH/UHBM=";
//    _model.channel = @"0000";
    _model.ownToken = self.tokenStr;
    _model.channel = self.myRoomNumStr;
    _model.uid = MY_USER_ID;
    
     self.agorakit = [AgoraRtcEngineKit sharedEngineWithAppId:self.model.appId delegate:self];
     //[self.agorakit setVolumeOfEffect:1 withVolume:1];
    //[self.agorakit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [ self.agorakit enableAudio];
   // [self.agorakit enableLocalAudio:YES];
 
    //设置频道场景
    //   [self.agorakit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
       //设置用户角色
   //    [self.agorakit setClientRole:AgoraClientRoleBroadcaster];
   
}
- (void)joinChannel{
   ZKWeakSelf
    NSLog(@"加入聊天token：%@/n频道号%@/n自己id：%@/n myName:%@/n touserid：%@/n touserName:%@",_model.ownToken,_model.channel,MY_USER_ID,MY_USER_NAME,self.toUserId,self.toUserName);
    
//    [self.agorakit joinChannelByUserAccount:MY_USER_ID token:_model.ownToken channelId:_model.channel joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
//
//    }];
    [self.agorakit joinChannelByToken:_model.ownToken channelId:_model.channel info:MY_USER_ID uid:[MY_USER_ID integerValue] joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
        [self setLocalVideo];
       
        NSLog(@"joinChannelByToken %lu",(unsigned long)uid);
        NSLog(@"joinChannelByToken channel %@",_model.channel);
        [weakSelf.agorakit setEnableSpeakerphone:YES];
       dispatch_async(dispatch_get_main_queue(), ^{
           _startTime = [[NSDate date] timeIntervalSince1970];
           
           weakSelf.timerIndex = 0;
           // 通话计时
           weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerAction:) userInfo:nil repeats:YES];
           weakSelf.session = nil;
           weakSelf.localVideoView.hidden = YES;
           [weakSelf.previewLayer removeFromSuperlayer];
           [weakSelf.localVideoView removeFromSuperview];
           weakSelf.localVideoView = nil;
           if (weakSelf.isAudio) {
               [weakSelf customView];
           }else{

               weakSelf.remoteVideoMutedIndicator.hidden  = YES;
               weakSelf.localVideoMutedIndicator.hidden = YES;
           }
           
       });
      [weakSelf.agorakit setEnableSpeakerphone:YES];
      [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
   }];
   
}
#pragma mark =--- 挂断电话

- (void)onCancel{
    
    ZKWeakSelf
    [self.agorakit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //        _startTime = [[NSDate date] timeIntervalSince1970];
//            if (!self.isGroup) {
//    //        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
            int type = kWCMessageTypeVideoChatEnd;
            if (self.isAudio) {
                type = kWCMessageTypeAudioChatEnd;
            }
            [g_meeting sendEnd:type toUserId:_toUserId toUserName:self.toUserName timeLen:self.timerIndex];
        });
    }];
    if (!self.isGroup) {
//        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
    int type = kWCMessageTypeVideoChatEnd;
    if (self.isAudio) {
        type = kWCMessageTypeAudioChatEnd;
    }
        /**
         {"messageId":"f12ea4e7fec34b3c9bb4f69b905bef0a","fromUserId":"10000462","fromUserName":"小逗比","toUserId":"10000460","content":"结束了语音通话,时长:137秒","timeLen":137,"timeSend":1693589050.0200472,"other":"","type":104,"toUserName":"Yea ","deleteTime":0}
         */
  //  [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
}
    [self actionQuit];
    self.session = nil;
    self.localVideoView.hidden = YES;
    [self.previewLayer removeFromSuperlayer];
    [self.localVideoView removeFromSuperview];
    [self.videoBackView removeFromSuperview];
    self.localVideoView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)setupVideo{
    [self.agorakit enableVideo];
    //CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
  AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc]initWithSize:CGSizeZero frameRate:AgoraVideoFrameRateFps15 bitrate:15 orientationMode:AgoraVideoOutputOrientationModeAdaptative mirrorMode:AgoraVideoMirrorModeAuto];
   
    
    [self.agorakit setVideoEncoderConfiguration:configuration];
    
}
- (void)setLocalVideo{
   // [self.agorakit setVideoProfile:AgoraVideoProfilePortrait360P swapWidthAndHeight:NO];
    
    AgoraRtcVideoCanvas*canvas = [[AgoraRtcVideoCanvas alloc]init];
    canvas.uid =  [MY_USER_ID integerValue];
    canvas.view = self.localVideo;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agorakit setupLocalVideo:canvas];
}
- (void) customView {
  
    if (_isAudio) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
           
       // layout.sectionInset =UIEdgeInsetsMake(0,0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,88,self.view.frame.size.width,self.view.frame.size.height - 290) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        [_collectionView registerClass:[JXTalkCell class] forCellWithReuseIdentifier:NSStringFromClass([JXTalkCell class])];
        [self.view addSubview:_collectionView];
        
        //_toUserName;
        self.showTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(_collectionView.frame)+5, JX_SCREEN_WIDTH, 20);
        [self.view addSubview:self.showTimeLabel];
        
        _viewBottom = [[UIView alloc] init];
        _viewBottom.frame = CGRectMake(0, JX_SCREEN_HEIGHT*3.2/5, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT/2);
        _viewBottom.userInteractionEnabled = YES;
        [self.view addSubview:_viewBottom];
    
        _buttonHangup = [self createBottomButtonWithImage:@"hangupN" SelectedImg:nil selector:@selector(onCancel) btnWidth:Button_Width imageWidth:BtnImage_big];
        [_buttonHangup setTitle:Localized(@"JXMeeting_Hangup") forState:UIControlStateNormal];
        _buttonHangup.frame = CGRectMake((JX_SCREEN_WIDTH - Button_Width)*0.5, JX_SCREEN_HEIGHT/4 - (Button_Height/2)-5-20, Button_Width, Button_Height);
        
        UIButton *muteButton = [UIButton buttonWithType:0];
        [muteButton setImage:[UIImage imageNamed:@"mic"] forState:0];
        [muteButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateSelected];
        muteButton.frame  = CGRectMake(_buttonHangup.left-28-80, _buttonHangup.top, 80, 80);
        [muteButton addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBottom addSubview:muteButton];
        self.muteButton = muteButton ;
        
        UIButton *switchSpeakerButton= [UIButton buttonWithType:0];
         [switchSpeakerButton setImage:[UIImage imageNamed:@"btn_speakerN"] forState:0];
        [switchSpeakerButton setImage:[UIImage imageNamed:@"btn_speaker_blueN"] forState:UIControlStateSelected];
        switchSpeakerButton.selected = YES;
         switchSpeakerButton.frame  = CGRectMake(_buttonHangup.right+28, _buttonHangup.top+5, 70, 70);
         [switchSpeakerButton addTarget:self action:@selector(speakerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_viewBottom addSubview:switchSpeakerButton];
         
        
            
    }else{
        
        UIView *videoBackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //videoBackView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:videoBackView];
        self.videoBackView = videoBackView;
        
        UIView *remoteVideo = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        remoteVideo.backgroundColor = HEXCOLOR(0x484258);
        [videoBackView addSubview:remoteVideo];
        self.remoteVideo = remoteVideo;
        
        UIImageView *remoteVideoMutedIndicator = [[UIImageView alloc]initWithFrame:CGRectMake((JX_SCREEN_WIDTH-100)*0.5, (JX_SCREEN_HEIGHT-100)*0.5, 100, 100)];
        remoteVideoMutedIndicator.image =[UIImage imageNamed:@"big_logo"];
        [videoBackView addSubview:remoteVideoMutedIndicator];
        self.remoteVideoMutedIndicator = remoteVideoMutedIndicator;
        
        UIView *localVideo = [[UIView alloc]initWithFrame:CGRectMake(JX_SCREEN_WIDTH-85-25, 36, 85, 113.5)];
        localVideo.backgroundColor = HEXCOLOR(0x827B92);
        [videoBackView addSubview:localVideo];
        self.localVideo = localVideo;
        
//        UIView *localVideoMutedIndicator = [[UIView alloc]initWithFrame:CGRectMake(JX_SCREEN_WIDTH-85-25, 36, 85, 113.5)];
//        localVideoMutedIndicator.backgroundColor = HEXCOLOR(0x827B92);
//        [videoBackView addSubview:localVideoMutedIndicator];
//        self.localVideoMutedIndicator = localVideoMutedIndicator;
//
//        UIImageView *localVideoImage = [[UIImageView alloc]initWithFrame:CGRectMake((85-36)*0.5, (113.5-36)*0.5, 36, 36)];
//        localVideoImage.image = [UIImage imageNamed:@"logo"];
//        [localVideoMutedIndicator addSubview:localVideo];
        
        self.showTimeLabel.frame = CGRectMake(0, Height_NavBar, JX_SCREEN_WIDTH, 20);
        [videoBackView addSubview:self.showTimeLabel];
        
        UIButton *hangUpButton  = [UIButton buttonWithType:0];
        [hangUpButton setImage:[UIImage imageNamed:@"hangupN"] forState:0];
        hangUpButton.frame  = CGRectMake((JX_SCREEN_WIDTH-80)*0.5, JX_SCREEN_HEIGHT-80-45, 80, 80);
        [hangUpButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [videoBackView addSubview:hangUpButton];
        self.hangUpButton = hangUpButton;
        
        UIButton *muteButton = [UIButton buttonWithType:0];
        [muteButton setImage:[UIImage imageNamed:@"mic"] forState:0];
        [muteButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateSelected];
        muteButton.frame  = CGRectMake(hangUpButton.left-28-80, hangUpButton.top, 80, 80);
        [muteButton addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [videoBackView addSubview:muteButton];
        self.muteButton = muteButton ;
        
        UIButton *switchCameraButton= [UIButton buttonWithType:0];
        [switchCameraButton setImage:[UIImage imageNamed:@"switchN"] forState:0];
        switchCameraButton.frame  = CGRectMake(hangUpButton.right+28, hangUpButton.top, 80, 80);
        [switchCameraButton addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [videoBackView addSubview:switchCameraButton];
        self.switchCameraButton = switchCameraButton;
    }

    //

}

 
#pragma mark- <AgoraRtcEngineDelegate>


-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    NSLog(@"firstRemoteVideoFrameOfUid:Uid %zd",uid);
}
// self joined success 成功加入频道回调。
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    
    NSLog(@"elf joined success 成功加入频道回调 %zd",uid);
}

#pragma mark ---
#pragma mark ---远端用户（加入当前频道回调。 重新加入
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine
 didRejoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed{
    for (int i=0; i<self.talkArray.count; i++) {
        JXTalkModel *model = _talkArray[i];
        if([model.userId isEqualToString:[NSString stringWithFormat:@"%zd",uid]]){
            _selelctIndexUserId = i;
            model.type = @"1";
            [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            return;;
        }
    }
    JXTalkModel *modelFist = _talkArray.lastObject;
     JXTalkModel *modelS  = [[ JXTalkModel alloc]init];
     modelS.userId = [NSString stringWithFormat:@"%zd",uid];
    // memberData *model =  [memberData fetchAllMembersInfo:modelFist.roomId userId:modelS.userId];
   
    // modelS.userName = model.userName;
     modelS.type = @"1";
     [_talkArray insertObject:modelS atIndex:0];
    
     [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
     
    NSLog(@"成功加入频道回调1:重新 自己的UserId%@  %zd",MY_USER_ID,uid);
}

#pragma mark ---
#pragma mark ---远端用户（加入当前频道回调。 新加入频道
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
 
    NSLog(@"成功加入频道回调2 新人: 自己的UserId%@  %zd",MY_USER_ID,uid);
 
    for (int i=0; i<_talkArray.count; i++) {
        JXTalkModel *model = _talkArray[i];
        //       [_talkArray removeObjectAtIndex:i];
        //       [_talkArray insertObject:model atIndex:i];
        if([model.userId isEqualToString:[NSString stringWithFormat:@"%zd",uid]]){
           if([model.type intValue]!=1){
                model.type = @"1";
                [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            }
            return;;
        }
    }
    JXTalkModel *modelFist = _talkArray.lastObject;
    
    JXTalkModel *modelS  = [[ JXTalkModel alloc]init];
    modelS.userId = [NSString stringWithFormat:@"%zd",uid];
   // memberData *model =  [memberData fetchAllMembersInfo:modelFist.roomId userId:modelS.userId];
    
   // modelS.userName = model.userName.length>0?model.userName:model.userNickName;
    modelS.type = @"1";
    [_talkArray insertObject:modelS atIndex:0];
    
   // [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_talkArray.count-1 inSection:0]]];
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    return;
     
    if(self.isGroup){
        
        for (int i=0; i<self.talkArray.count; i++) {
            JXTalkModel *model = _talkArray[i];
            model.type = @"1";
            
           [_talkArray removeObjectAtIndex:i];
           [_talkArray insertObject:model atIndex:i];
            if([model.userId isEqualToString:[NSString stringWithFormat:@"%zd",uid]]){
                [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];

            }else{
                 
                for (int i=0; i<self.talkArray.count; i++) {
                    JXTalkModel *model = _talkArray[i];
                    if(!([model.userId intValue] == uid)){
                       JXTalkModel *modelS  = [[ JXTalkModel alloc]init];
                        modelS.userId = [NSString stringWithFormat:@"%zd",uid];
                        modelS.type = @"1";
                        [_talkArray addObject:modelS];
                        [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                    }
                }
               
            }
        }
        
        return;
    }
     AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc]init];
     canvas.uid = uid;
     canvas.view = self.remoteVideo;
     canvas.renderMode = AgoraVideoRenderModeHidden;
     [self.agorakit setupRemoteVideo:canvas];
     
    
}

//离开频道回调。
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine
didLeaveChannelWithStats:(AgoraChannelStats * _Nonnull)stats{
    
    NSLog(@"离开频道回调。回调:Uid %zd",stats);
    
}
 
#pragma mark ---
#pragma mark ---远端用户 --离开--  当前频道回调。
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    
    if(self.isGroup){
        for (int i=0; i<self.talkArray.count; i++) {
            JXTalkModel *model = _talkArray[i];
            if([model.userId intValue]==uid){
                [_talkArray removeObjectAtIndex:i];
                //   NSLog(@"离开的人 %zd %@",i,[model mj_keyValues]);
                [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            }
        }
      //  NSLog(@"didOfflineOfUid %zd",uid);
        if(_talkArray.count==0){
            
            [self onCancel];
        }
        return;
    }
     
    ZKWeakSelf
    [self.agorakit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
//            dispatch_async(dispatch_get_main_queue(), ^{
//        //        _startTime = [[NSDate date] timeIntervalSince1970];
//                weakSelf.session = nil;
//                weakSelf.localVideoView.hidden = YES;
//                [weakSelf.previewLayer removeFromSuperlayer];
//                [weakSelf.localVideoView removeFromSuperview];
//                weakSelf.localVideoView = nil;
//                [weakSelf.videoBackView removeFromSuperview];
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            });
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        _startTime = [[NSDate date] timeIntervalSince1970];
        self.session = nil;
        self.localVideoView.hidden = YES;
        [self.previewLayer removeFromSuperlayer];
        [self.localVideoView removeFromSuperview];
        self.localVideoView = nil;
        [self.videoBackView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    [self actionQuit];
//    [self appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Uid:%lu didOffline reason:%lu", (unsigned long)uid, (unsigned long)reason]];
}

//监测到活跃用户的回调
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine activeSpeaker:(NSUInteger)speakerUid{
    
    NSLog(@"监测到活跃用户的回调 %zd ",speakerUid);
    
}
#pragma mark ---提示频道内谁正在说话、说话者音量及本地用户是否在说话的回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo*> *_Nonnull)speakers totalVolume:(NSInteger)totalVolume{
    _rxKBitRateIndex = totalVolume;
    for (int i=0; i<speakers.count; i++) {
        AgoraRtcAudioVolumeInfo *sperakinfo = speakers[i];
       // NSLog(@"speakers1 %zd %d",i,sperakinfo.uid);
        for (int j=0; j<_talkArray.count; j++) {
            JXTalkModel *model = _talkArray[j];
            if([model.userId intValue]== sperakinfo.uid){// &&!([MY_USER_ID intValue]== sperakinfo.uid)
                _selelctIndexUserId = sperakinfo.uid;
            
                [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:j inSection:0]]];
            }
        }
        
    }
 //   NSLog(@"提示频道内谁正在说话 %@ totalVolume-%zd",speakers,totalVolume);
    
}
//远端用户信息已更新回调。
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didUserInfoUpdatedWithUserId:(NSUInteger)uid userInfo:(AgoraUserInfo* _Nonnull)userInfo{
     
    NSLog(@"远端用户信息已更新回调。Uid %zd",uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRegisteredLocalUser:(NSString * _Nonnull)userAccount withUid:(NSUInteger)uid{
    
       NSLog(@"didRegisteredLocalUser:Uid %zd",uid);
}
 
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didUpdatedUserInfo:(AgoraUserInfo * _Nonnull)userInfo withUid:(NSUInteger)uid{
    
       NSLog(@"didUpdatedUserInfo:Uid %zd",uid);
}
 
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole{
    
       NSLog(@"didClientRoleChanged:Uid %zd",oldRole);
    
}


- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine audioTransportStatsOfUid:(NSUInteger)uid delay:(NSUInteger)delay lost:(NSUInteger)lost rxKBitRate:(NSUInteger)rxKBitRate{
    
    
//    _selelctIndexUserId = uid;
//    _rxKBitRateIndex = rxKBitRate;
//    if(rxKBitRate>1){
        
//        for (int i=0; i<_talkArray.count; i++) {
//            JXTalkModel *model = _talkArray[i];
//            if([model.userId isEqualToString:[NSString stringWithFormat:@"%zd",uid]]){
//               // [UIView performWithoutAnimation:^{ }];
//
//             [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
//
//            }
//        }
        
//    }
    
 //   NSLog(@"audioUid = %zd %zd",uid,rxKBitRate);
}




//Token 已过期回调。
- (void)rtcEngineRequestToken:(AgoraRtcEngineKit * _Nonnull)engine{
    //    [self.agoraKit renewToken:@""];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:MY_USER_ID forKey:@"userId"];
        [tempDic setValue:self.myRoomNumStr forKey:@"channelName"];
        [self getTokenWithparams:tempDic success:^(id responseObject) {
            NSLog(@"token刷新成功");
            NSString *token = responseObject;
            if(token.length){
                [self.agorakit renewToken:responseObject];
            }else{
                [g_App showAlert:@"请求token失败"];
            }
        } failure:^(NSError *error) {
            NSLog(@"token刷新失败");
        }];
}

//Token 服务将在30s内过期回调。
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine
tokenPrivilegeWillExpire:(NSString *_Nonnull)token{
    //    [self.agoraKit renewToken:@""];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:MY_USER_ID forKey:@"userId"];
        [tempDic setValue:self.myRoomNumStr forKey:@"channelName"];
        [self getTokenWithparams:tempDic success:^(id responseObject) {
            NSLog(@"token刷新成功");
            NSString *token = responseObject;
            if(token.length){
                [self.agorakit renewToken:responseObject];
            }else{
                [g_App showAlert:@"请求token失败"];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"token刷新失败");
        }];
    }
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
     NSLog(@"网络连接 服务将在30s内过期回调。");
    NSLog(@"%@",engine);
//    [self appendInfoToTableViewWithInfo:@"ConnectionDidInterrupted"];
}
//网络连接状态已改变回调

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    NSLog(@"Lost");
    NSLog(@"离开频道回调。回调:rtcEngineConnectionDidLost %@",engine);
//    [self appendInfoToTableViewWithInfo:@"ConnectionDidLost"];
    ZKWeakSelf
    if(self.isGroup){
        return;
    }
    [self.agorakit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
        //        _startTime = [[NSDate date] timeIntervalSince1970];
                weakSelf.session = nil;
                weakSelf.localVideoView.hidden = YES;
                [weakSelf.previewLayer removeFromSuperlayer];
                [weakSelf.localVideoView removeFromSuperview];
                weakSelf.localVideoView = nil;
                [weakSelf.videoBackView removeFromSuperview];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
    }];

}
//发生错误回调。
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
  
    
    NSLog(@"网络连接 发生错误回调。 %ld %@",(long)errorCode,engine);
     
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine lastmileQuality:(AgoraNetworkQuality)quality {
    NSString *string;
    switch (quality) {
        case AgoraNetworkQualityExcellent:      string = @"excellent";   break;
        case AgoraNetworkQualityGood:           string = @"good";        break;
        case AgoraNetworkQualityPoor:           string = @"poor";        break;
        case AgoraNetworkQualityBad:            string = @"bad";         break;
        case AgoraNetworkQualityVBad:           string = @"very bad";    break;
        case AgoraNetworkQualityDown:           string = @"down";        break;
        case AgoraNetworkQualityUnknown:        string = @"unknown";     break;
        case AgoraNetworkQualityDetecting:      string = @"detecting";   break;
        case AgoraNetworkQualityUnsupported:    string = @"unsupported"; break;
    }
      string;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioRouteChanged:(AgoraAudioOutputRouting)routing {
    switch (routing) {
        case AgoraAudioOutputRoutingDefault:
            NSLog(@"AgoraRtc_AudioOutputRouting_Default");
            break;
        case AgoraAudioOutputRoutingHeadset:
            NSLog(@"AgoraRtc_AudioOutputRouting_Headset");
            break;
        case AgoraAudioOutputRoutingEarpiece:
            NSLog(@"AgoraRtc_AudioOutputRouting_Earpiece");
            break;
        case AgoraAudioOutputRoutingHeadsetNoMic:
            NSLog(@"AgoraRtc_AudioOutputRouting_HeadsetNoMic");
            break;
        case AgoraAudioOutputRoutingSpeakerphone:
            NSLog(@"AgoraRtc_AudioOutputRouting_Speakerphone");
            break;
        case AgoraAudioOutputRoutingLoudspeaker:
            NSLog(@"AgoraRtc_AudioOutputRouting_Loudspeaker");
            break;
        case AgoraAudioOutputRoutingHeadsetBluetooth:
            NSLog(@"AgoraRtc_AudioOutputRouting_HeadsetBluetooth");
            break;
        default:
            break;
    }
}

#pragma mark ---------------------------------
#pragma mark =========== 重新添加好友 ===========
- (void)panActionAdd:(UIButton *)pan {
    
    NSMutableSet* p = [[NSMutableSet alloc]init];
    
    WH_JXSelectFriends_WHVC* vc = [WH_JXSelectFriends_WHVC alloc];
    vc.isNewRoom = NO;
    vc.isShowMySelf = NO;
//    vc.bbbbbb = YES;
    vc.type = JXSelectFriendTypeSelMembers;
    JXTalkModel *model = _talkArray.lastObject;
    WH_RoomData* room =  [[WH_RoomData alloc]init];
    room.roomId = model.roomId;
    room.roomJid = model.objectId;
     vc.room = room;
    vc.existSet = p;
    vc.delegate = self;
    vc.didSelect = @selector(meetingAddMember:);
    vc = [vc init];
    //    [g_window addSubview:vc.view];
    [self presentViewController:vc animated:YES completion:^{
        
        
    }];
    
}

-(void)meetingAddMember:(WH_JXSelectFriends_WHVC*)vc{
    int type= kWCMessageTypeAudioMeetingInvite;
    NSMutableArray *sendArr = [NSMutableArray array];  //这个数组就是保存了你选择了多少人 用来发消息用，ios 这边就是每次只发送一个人的消息，我这边是先保存我所有选择的人，每次发消息就吧之前保存的所有人全部发送
    JXTalkModel *model = _talkArray.lastObject;
    for(NSNumber* n in vc.set){
        memberData *user;
        if (vc.seekTextField.text.length > 0) {
            user = vc.searchArray[[n intValue] % 1000];
        }else{
            user = [[vc.letterResultArr objectAtIndex:[n intValue] / 1000] objectAtIndex:[n intValue] % 1000];
        }
        
        NSString* s = [NSString stringWithFormat:@"%ld",user.userId];
         NSDictionary *dict= @{@"userId":s,@"userName":user.userName.length>0?user.userName:user.userNickName,@"objectId":model.objectId.length>0?model.objectId:@"",@"callId":model.callId.length>0?model.callId:@"",@"type":@"120",@"roomId":model.roomId};
         [sendArr addObject:dict];
    }
     NSDictionary *dict= @{@"userId":MY_USER_ID,@"userName":MY_USER_NAME.length>0?MY_USER_NAME:kMY_USER_NICKNAME,@"objectId":model.objectId.length>0?model.objectId:@"",@"callId":model.callId.length>0?model.callId:@"",@"type":@"120",@"roomId":model.roomId};
     [sendArr addObject:dict];
    
    NSMutableArray *tempArr = [NSMutableArray array];//这个数组就是保存了你选择了多少人 本地展示
    for(NSNumber* n in vc.set){
        memberData *user;
        if (vc.seekTextField.text.length > 0) {
            user = vc.searchArray[[n intValue] % 1000];
        }else{
            user = [[vc.letterResultArr objectAtIndex:[n intValue] / 1000] objectAtIndex:[n intValue] % 1000];
        }
        NSString* s = [NSString stringWithFormat:@"%ld",user.userId];
        NSDictionary *dict= @{@"userId":s,@"userName":user.userName.length>0?user.userName:user.userNickName,@"objectId":model.objectId.length>0?model.objectId:@"",@"callId":model.callId.length>0?model.callId:@"",@"type":@"120",@"roomId":model.roomId};
       JXTalkModel *model =[JXTalkModel mj_objectWithKeyValues:dict];
       [tempArr addObject:model];
     //  [g_meeting sendMeetingInvite:s toUserName:user.userName roomJid:model.objectId callId:model.callId callUser:sendArr type:[model.type intValue]];
    }
    
//    for (JXTalkModel *model  in sendArr) {
//        [_talkArray addObject:model];
//    }
//    NSSet *existSet = [[NSSet alloc]init];
//    for (JXTalkModel *modelset in _talkArray) {
//        [existSet setByAddingObject:modelset.userId];
//    }
//    for(NSInteger i=[_talkArray count]-1;i>=0;i--){
//        JXTalkModel* p = [_talkArray objectAtIndex:i];
//        if([existSet containsObject:[NSString stringWithFormat:@"%@",p.userId]]>0)
//            [_talkArray removeObjectAtIndex:i];
//    }
//
//    [_collectionView reloadData];
      
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionQuit {
    
    if (_recorderBtn.selected) {
        [self stopRecord];
    }
    
    [g_App endCall];
    [self.timer invalidate];
    self.timer = nil;
    g_meeting.isMeeting = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [g_subWindow removeFromSuperview];
    g_subWindow = nil;
    [self.view removeFromSuperview];
    _pSelf = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    });
}

- (void)dealloc {
    NSLog(@"%@ -- dealloc",NSStringFromClass([self class]));
    [g_notify removeObserver:self];
}
-(WH_JXCustomButton *)createBottomButtonWithImage:(NSString *)Image SelectedImg:(NSString *)selectedImage selector:(SEL)selector btnWidth:(CGFloat)btnWidth imageWidth:(CGFloat)imageWidth{
    WH_JXCustomButton * button = [WH_JXCustomButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:Image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.titleRect = CGRectMake(0, imageWidth+(btnWidth-imageWidth)/2, btnWidth, 20);
    button.imageRect = CGRectMake((btnWidth-imageWidth)/2, (btnWidth-imageWidth)/2, imageWidth, imageWidth);
    if (selector)
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [_viewBottom addSubview:button];
    return button;
}

-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
     _model = [AgoraModel mj_objectWithKeyValues:dict];
     
}


- (void)getTokenWithparams:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // 推荐列表//NSString *url = @"http://1.15.75.207:8092/acoustic/getRctToken";
    NSString *url = @"http://1.15.75.207:8092/agora/info";
    NSLog(@"请求token入参，url：%@ \n param:%@",url,params);
    [WH_GKNetworking get:url params:params success:^(id  _Nonnull responseObject) {
        NSLog(@"刷新token返回%@", responseObject);
        NSString *token = @"";
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            NSString *data = responseObject[@"data"];
            self.tokenStr = [NSString stringWithFormat:@"%@",data];
//            [self.agoraKit renewToken:data];
            token = self.tokenStr;
        }else {
            
        }
        !success ? : success(token);
    } failure:^(NSError * _Nonnull error) {
        !failure ? : failure(error);
    }];
    
}
- (void)recorderBtnAction:(UIButton *)btn {

    if (!btn.selected) {
        self.isRecording = NO;
        //如果还没有开始录制，判断系统是否支持
        if ([RPScreenRecorder sharedRecorder].isAvailable && [[UIDevice currentDevice].systemVersion floatValue] > 9.0) {
            //如果支持，就使用下面的方法可以启动录制回放
            [btn setTitle:Localized(@"JX_Opening") forState:UIControlStateDisabled];
            btn.enabled = NO;
            [self startRecord];

        } else {
            [JXMyTools showTipView:Localized(@"JX_NotScreenRecording")];
        }
    }else {
        [btn setTitle:Localized(@"JX_Stopping") forState:UIControlStateDisabled];
        btn.enabled = NO;
        [self stopRecord];
    }
}

- (void)startRecord {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isRecording) {

            [self startRecord];
        }
    });
    NSLog(@"recorder -- OK");
    [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
        if (!error) {
            NSLog(@"recorder -- 已开启");
            self.isRecording = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                _recorderBtn.enabled = YES;
                _recorderBtn.selected = YES;
            });
        }
        //处理发生的错误，如设用户权限原因无法开始录制等
    }];
}

- (void)stopRecord {
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"stopRecord");

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isRecording) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    _recorderBtn.enabled = YES;
                    _recorderBtn.selected = NO;
                });

                [JXMyTools showTipView:@"录屏失败，请重新录制"];

//                [self stopRecord];
            }
        });

        //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            _previewVC = previewViewController;

            self.isRecording = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                _recorderBtn.enabled = YES;
                _recorderBtn.selected = NO;
            });

            NSLog(@"recorder -- stop");
            if (error) {
                NSLog(@"recorder -- errro:%@", error);
                //处理发生的错误，如磁盘空间不足而停止等
            }else {
                NSURL *url = [_previewVC valueForKey:@"movieURL"];


//                [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL URLWithString:str] error:nil];
////                [[NSFileManager defaultManager] moveItemAtURL:url toURL:[NSURL URLWithString:str] error:nil];
//
//                NSString *str = [FileInfo getUUIDFileName:@"mp4"];
//                JXMediaObject* p = [[JXMediaObject alloc]init];
//                p.userId = g_server.myself.userId;
//                p.fileName = str;
//                p.isVideo = [NSNumber numberWithBool:YES];
//                //                    p.timeLen = [NSNumber numberWithInteger:timeLen];
//                [p insert];

                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    if (error) {
                        [JXMyTools showTipView:Localized(@"JX_SaveFiled")];
                    }else {
                        [JXMyTools showTipView:Localized(@"JX_SaveSuessed")];
                    }
                }];

//                if (_previewVC) {
//                    //设置预览页面到代理
//                    _previewVC.previewControllerDelegate = self;
//
//                    [g_window addSubview:_previewVC.view];
//                    [g_navigation.subViews.lastObject presentViewController:previewViewController animated:YES completion:nil];
//                }

            }

        }];
    });
}

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    ZKWeakSelf
    [self.agorakit leaveChannel:^(AgoraChannelStats *stat) {
         [weakSelf dismissViewControllerAnimated:YES completion:nil];
     }];
}

- (void)creatLocalVideoView {
    
    self.localVideoView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.localVideoView.backgroundColor = HEXCOLOR(0x1F2025);
    [g_window addSubview:self.localVideoView];
    
    // 获取需要的设备
    AVCaptureDevice *device =  [self cameraWithPosition:AVCaptureDevicePositionFront];
    if (self.isAudio || !device) {
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH / 2 - 50, JX_SCREEN_HEIGHT / 2 - 110, 100, 100)];
        headImage.layer.cornerRadius = headImage.frame.size.width / 2;
        headImage.layer.masksToBounds = YES;
        headImage.image = [UIImage imageNamed:@"酷聊120"];
        [self.localVideoView addSubview:headImage];
        
    }else {
        NSError *error = nil;
        
        // 初始化会话
        _session = [[AVCaptureSession alloc] init];
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                            error:&error];
        [_session addInput:input];
        [_session startRunning];
        
        //预览层的生成，实时获取摄像头数据
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        self.previewLayer.frame = [UIScreen mainScreen].bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.localVideoView.layer addSublayer:self.previewLayer];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, JX_SCREEN_HEIGHT / 2, JX_SCREEN_WIDTH, 20)];
    label.font =[UIFont systemFontOfSize:17];
    label.text = Localized(@"JX_Connection");
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.localVideoView addSubview:label];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)createSuspensionView {
    _suspensionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    _suspensionBtn.backgroundColor = [UIColor whiteColor];
    _suspensionBtn.layer.cornerRadius = 2.0;
    _suspensionBtn.layer.masksToBounds = YES;
    _suspensionBtn.layer.borderWidth = 0.5;
    _suspensionBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [_suspensionBtn addTarget:self action:@selector(showAudioView) forControlEvents:UIControlEventTouchUpInside];
    g_subWindow.frame = CGRectMake(JX_SCREEN_WIDTH - 80 - 10, 50, _suspensionBtn.frame.size.width, _suspensionBtn.frame.size.height);
    g_subWindow.backgroundColor = [UIColor cyanColor];
    [g_subWindow addSubview:_suspensionBtn];
    g_subWindow.hidden = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [g_subWindow addGestureRecognizer:pan];
    
    UIImageView *suspensionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    suspensionImage.image = [UIImage imageNamed:@"callShow"];
    suspensionImage.center = CGPointMake(_suspensionBtn.frame.size.width / 2, _suspensionBtn.frame.size.height / 2 - 10);
    [_suspensionBtn addSubview:suspensionImage];
    
    
    //添加
     UIButton *suspenAddBtn= [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-60, 30, 44, 44)];
    [suspenAddBtn setImage:[UIImage imageNamed:@"person_add"]  forState:UIControlStateNormal];
    [self.view addSubview:suspenAddBtn];
    [suspenAddBtn addTarget:self action:@selector(panActionAdd:) forControlEvents:UIControlEventTouchUpInside];
    
     
    _suspensionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(suspensionImage.frame) + 5, _suspensionBtn.frame.size.width, 20)];
    _suspensionLabel.textColor = THEMECOLOR;
    _suspensionLabel.textAlignment = NSTextAlignmentCenter;
    _suspensionLabel.font = [UIFont systemFontOfSize:13];
    _suspensionLabel.text = @"00:00";
    [_suspensionBtn addSubview:_suspensionLabel];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.subWindowFrame = g_subWindow.frame;
    }
    CGPoint offset = [pan translationInView:g_App.window];
    CGPoint offset1 = [pan translationInView:g_subWindow];
    NSLog(@"pan - offset = %@, offset1 = %@", NSStringFromCGPoint(offset), NSStringFromCGPoint(offset1));
    
    CGRect frame = self.subWindowFrame;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    g_subWindow.frame = frame;
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (frame.origin.x <= JX_SCREEN_WIDTH / 2) {
            frame.origin.x = 10;
        }else {
            frame.origin.x = JX_SCREEN_WIDTH - frame.size.width - 10;
        }
        if (frame.origin.y < 0) {
            frame.origin.y = 10;
        }
        if ((frame.origin.y + frame.size.height) > JX_SCREEN_HEIGHT) {
            frame.origin.y = JX_SCREEN_HEIGHT - frame.size.height - 10;
        }
        [UIView animateWithDuration:0.5 animations:^{
            
            g_subWindow.frame = frame;
        }];
    }
}
- (void)callTimerAction:(NSTimer *)timer {
    self.timerIndex ++;
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", self.timerIndex / 60,self.timerIndex % 60];
    self.suspensionLabel.text = str;
    self.showTimeLabel.text = str;
    
    
}

- (void)hideAudioView {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, self.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        g_subWindow.hidden = NO;
        self.view.hidden = YES;
    }];
}

- (void)showAudioView {
    g_subWindow.hidden = YES;
    self.view.hidden = NO;
    self.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, self.view.frame.size.width, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

-(void)newMsgCome:(NSNotification *)notifacation{
   
    WH_JXMessageObject *msg = (WH_JXMessageObject *)notifacation.object;
    
    NSLog(@"newMsgCome = %@ %@ %@  %@ %d",msg.content,msg.fromUserId,msg.fromUserName,msg.toUserId,[msg.type intValue]);
     
    if ([msg.type intValue] == kWCMessageTypeVideoChatEnd || [msg.type intValue] == kWCMessageTypeAudioChatEnd || [msg.type intValue] == kWCMessageTypeAudioChatCancel || [msg.type intValue] == kWCMessageTypeVideoChatCancel) {
        if ([msg.fromUserId isEqualToString:self.toUserId]) {
            [self actionQuit];
        }
    }
}

// 监听网络状态
- (void)networkStatusChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self actionQuit];
        }
    }];
}

-(void)callEndNotification:(NSNotification *)notifacation{
    [self onCancel];
    
    if (self.timerIndex == 5) {
        return;
    }
    if (!self.isGroup) {
        //        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
        int type = kWCMessageTypeVideoChatEnd;
        if (self.isAudio) {
            type = kWCMessageTypeAudioChatEnd;
        }
        [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
    }
    
    [self actionQuit];
}


-(void)muteBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (_isAudio) {
        [self.agorakit muteLocalAudioStream:btn.selected];
    }else{
//        [self.agorakit muteLocalVideoStream:btn.selected];
        [self.agorakit muteLocalAudioStream:btn.selected];
    }
}
-(void)cameraBtnClick{
   // [self.agorakit setCameraAutoExposureFaceModeEnabled:YES];
    [self.agorakit switchCamera];
    
}

-(void)speakerBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    [self.agorakit setEnableSpeakerphone:btn.selected];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UICollectionView delegate

#pragma mark-----每一个的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(92, 110);
}
#pragma mark-----每一个边缘留白
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark-----最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}
#pragma mark-----最小竖间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark-----返回每个单元格是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark-----多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark-----多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _talkArray.count;//>0?self.talkArray.count:12;
}

#pragma mark-----创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JXTalkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JXTalkCell class]) forIndexPath:indexPath];
   // cell.backgroundColor =[UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:(arc4random_uniform(256))/255.0];// [UIColor whiteColor];
    
     JXTalkModel *model = [_talkArray objectAtIndex:indexPath.row];
   
    [cell talkVCCloseBtnAction:model indexPJoinMeet:_selelctIndexUserId indexRow:_rxKBitRateIndex];
    return cell;
    
}
#pragma mark-----点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     
}

@end
