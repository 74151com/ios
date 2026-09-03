//
//  TMineNoteBookDetialVc.m
//  Tigase
//
//  Created by os on 2024/2/18.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "TMineNoteBookDetialVc.h" 
#import "IQTextView.h"
#import "RITLPhotosViewController.h"
#import "WH_JXCamera_WHVC.h"
#import "WH_JXMediaObject.h"
#import "MediaTypeModel.h"
#import "WH_ImageBrowser_WHViewController.h"

@interface TMineNoteBookDetialVc ()<UIScrollViewDelegate,UITextViewDelegate>
{
    
    UIScrollView* _svImages;
    WH_AudioPlayerTool* _audioPlayer;
    WH_JXVideoPlayer* _videoPlayer;
    NSInteger  _photoIndex;
}


@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *mContentView;
@property (nonatomic, strong) IQTextView *mContentTV;
@property (nonatomic, weak) UITextField *title_tf ;
@property (nonatomic, strong) UILabel *mIsOpenLbl;
@property (nonatomic, strong) UISwitch *mSwitch;
@property (nonatomic, strong) UILabel *mTipLbl1;
@property (nonatomic, strong) UILabel *mTipLbl2;

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation TMineNoteBookDetialVc
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"笔记详情";
        self.wh_isGotoBack = YES;
        [self createHeadAndFoot];
        self.wh_tableBody.frame = CGRectZero;
        
          [self setupUIEdit];
      
          [self wh_showImages];
         
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
    }
    return self;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEMEBACKCOLOR;
     
   
}
 

-(void)wh_showImages{
    int i;
    [g_factory removeAllChild:_svImages];
    _svImages = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, JX_SCREEN_WIDTH-50,110)];
    _svImages.pagingEnabled = YES;
    _svImages.delegate = self;
    _svImages.showsVerticalScrollIndicator = NO;
    _svImages.showsHorizontalScrollIndicator = NO;
    _svImages.backgroundColor = [UIColor brownColor];
    _svImages.userInteractionEnabled = YES;
    [_photoView addSubview:_svImages];
    [_svImages mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
     
    NSInteger n = [_dictArr count];
    CGFloat width = (_svImages.width - 20)/3;
 
    
    for(i=0;i<n&&i<9;i++){
        WH_JXImageView* iv = [[WH_JXImageView alloc]initWithFrame:CGRectMake(i * (width +5), 5, width,width)];
        iv = [[WH_JXImageView alloc]initWithFrame:CGRectMake(10+(i % 3) * (width +5), 8+(i / 3) * (width + 7), width,width)];
        iv.wh_delegate = self;
        iv.userInteractionEnabled = YES;
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        iv.didTouch = @selector(actionImage:);
     
        iv.wh_animationType = WH_JXImageView_Animation_Line;
        iv.tag = i;
        NSDictionary *dictUrl = [_dictArr objectAtIndex:i];
        iv.ourlEdit = [dictUrl objectForKey:@"oUrl"];
        [_svImages addSubview:iv];
    }
    if (n == 9) {
        return;
    }
    
  //  _svImages.contentSize = CGSizeMake( n * (width + 5)+width+5,110);
}

- (void)actionImage:(WH_JXImageView*)sender{
    _photoIndex = sender.tag;
    
    NSDictionary *tempArrDict =_dictArr[_photoIndex];
    NSString *oUrltype = [tempArrDict objectForKey:@"oUrl"];
    if([oUrltype hasSuffix:@".mp4"]) {//判断是否是视频链接
        _videoPlayer= [WH_JXVideoPlayer alloc];
        _videoPlayer.videoFile = oUrltype;
        _videoPlayer.WH_didVideoPlayEnd = @selector(WH_didVideoPlayEnd);
        _videoPlayer.isStartFullScreenPlay = YES; //全屏播放
        _videoPlayer.delegate = self;
        _videoPlayer = [_videoPlayer initWithParent:self.view];
        [_videoPlayer wh_switch];
    }else{
        
        NSMutableArray *imagePathArr = [[NSMutableArray alloc]init];
        [imagePathArr addObject:oUrltype];
        NSMutableArray *tempArr = [NSMutableArray array];
        WH_JXMessageObject* msgImg = [[WH_JXMessageObject alloc]init];
        msgImg.content =oUrltype;
        msgImg.type = [NSNumber numberWithInt:2];
        [tempArr addObject:msgImg];
        
        [WH_ImageBrowser_WHViewController show:self delegate:self type:PhotoBroswerVCTypeModal contentArray:tempArr index:0 imagesBlock:^NSArray *{
            return imagePathArr;
        }];
    }
    
}
 
#pragma mark ==============
#pragma mark 初始化 编辑时候的视图
- (void)setupUIEdit {
    
    NSDictionary *dict = [_dictData objectForKey:@"body"];
    UITextField *title_tf = [[UITextField alloc] init];
    title_tf.placeholder =  @"请输入标题";
    title_tf.userInteractionEnabled = NO;
    title_tf.text =  _titleStr;
    title_tf.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:title_tf];
    _title_tf = title_tf;
   [title_tf mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(15);
       make.right.mas_equalTo(-15);
       make.top.equalTo(self.view).offset(Height_NavBar+10);
       make.height.mas_equalTo(44);
       
   }];
    
    self.mContentTV.text =  _contentStr;
    [self.view addSubview:self.mContentTV];
    [self.mContentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(title_tf.mas_bottom).offset(10);
        make.height.mas_equalTo(150);
    }];
     
    
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.equalTo(self.mContentTV.mas_bottom).offset(10);
        make.height.mas_equalTo(110*3);
        
    }];
    
      
    [self.view addSubview:_mIsOpenLbl];
    _mIsOpenLbl.hidden = YES;
    [_mIsOpenLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.equalTo(_photoView.mas_bottom).offset(10);
        
    }];
     
    
}

- (void)imageTapVideoclickplay{
    
    
    [self.avplayer play];
}
- (void)playbackFinished:(NSNotification *)notif {
    CGFloat a=0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.avplayer seekToTime:dragedCMTime];
    [self.avplayer play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
}
  
#pragma mark 懒加载
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc] init];
        _mScrollView.backgroundColor = [UIColor cyanColor];
        _mScrollView.userInteractionEnabled = YES;
    }
    return _mScrollView;
}
 

- (IQTextView *)mContentTV {
    if (!_mContentTV) {
        _mContentTV = [[IQTextView alloc] init];
        _mContentTV.placeholder = @"说点什么...";
//        _mContentTV.textColor = THEMEBACKCOLOR;
        _mContentTV.font = [UIFont systemFontOfSize:15];
        _mContentTV.editable = NO;
        _mContentTV.selectable = NO;
         
        _mContentTV.delegate = self;
    }
    return _mContentTV;
}
- (UILabel *)mIsOpenLbl {
    if (!_mIsOpenLbl) {
        _mIsOpenLbl = [[UILabel alloc] init];
        _mIsOpenLbl.text = @"视频和图片不宜过多";
        _mIsOpenLbl.hidden = YES;
//        _mContentTV.textColor = THEMEBACKCOLOR;
        _mIsOpenLbl.font = [UIFont systemFontOfSize:15];
    }
    return _mIsOpenLbl;
}
 

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.image =[UIImage imageNamed: @"ic_pengyouquan_publish_add"];
        _photoView.userInteractionEnabled = YES;
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        _photoView.backgroundColor = [UIColor whiteColor];
      //  [_photoView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapclick)]];
     }
    return _photoView;
}

#pragma mark  -------------------服务器返回数据--------------------
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
   [_wait stop];
    if([aDownload.action isEqualToString:act_NoteAddConfig]){
        
        [g_server showMsg:@"发布成功"];
        
        [self actionQuit];
        return;
    }
    if( [aDownload.action isEqualToString:wh_act_UserGet] ){
        
         
    }
     
    
}


#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
  //  [self WH_doUploadError:aDownload];
    [_wait stop];
    if([aDownload.action isEqualToString:act_NoteAddConfig]){
        
    }
    return WH_hide_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    
    [_wait stop];
    if([aDownload.action isEqualToString:act_NoteAddConfig]){
        
    }
    return WH_hide_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    // 撤回加等待符（撤回接口调用很慢）
   [_wait start];
   
}
 
@end
