//
//  TMineNoteBookVc.m
//  tio-chat-ios
//
//  Created by os on 2023/12/24.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TMineNoteBookVc.h"
#import "IQTextView.h"
#import "RITLPhotosViewController.h"
#import "WH_JXCamera_WHVC.h"
#import "WH_JXMediaObject.h"
#import "MediaTypeModel.h"
#import "WH_ImageBrowser_WHViewController.h"

@interface TMineNoteBookVc () <UITextViewDelegate,CLLocationManagerDelegate,RITLPhotosViewControllerDelegate,LXActionSheetDelegate,WH_JXActionSheet_WHVCDelegate,WH_JXCamera_WHVCDelegate>
{
    
    UIScrollView* _svImages;
    UIScrollView* _svVideos;
    
    int  _buildHeight;
    WH_AudioPlayerTool* _audioPlayer;
    WH_JXVideoPlayer* _videoPlayer;
    NSMutableArray* _array;
    NSMutableArray* _images;
    NSMutableArray* _imageStrings;
    NSMutableArray* _imageVideoStrings;
    NSMutableArray* _videosArr;
    NSMutableArray* _videoStrings;
    NSString* tUrl;
    NSString* oUrl;
    int _nSelMenu;
    NSInteger  _photoIndex;
}

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint oraginPoint;
@property (nonatomic, assign) CGPoint newPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) NSMutableArray* imageViewArray;
@property (nonatomic, strong) NSMutableArray* VideoViewArray;
@property (nonatomic, assign) NSTimeInterval intoBorderTime;
@property (nonatomic, assign) NSTimeInterval stayBorderTime;
@property (nonatomic, assign) BOOL inBorder;
@property (nonatomic, assign) BOOL isUpdateImage;



@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *mContentView;
@property (nonatomic, strong) IQTextView *mContentTV;
@property (nonatomic, weak) UITextField *title_tf ;
@property (nonatomic, strong) UILabel *mIsOpenLbl;
@property (nonatomic, strong) UISwitch *mSwitch;
@property (nonatomic, strong) UILabel *mTipLbl1;
@property (nonatomic, strong) UILabel *mTipLbl2;
//@property (nonatomic, strong) JXLocationVC *JKMapVC;

/**选择图片View*/
@property (nonatomic, strong) UIImageView *photoView;
/**图片管理器*/
//@property (nonatomic, strong) HXPhotoManager *photoManager;

///资源保存数组
@property (nonatomic, strong) NSMutableArray *assetArray;
/**是否原图*/
@property (nonatomic) BOOL isOriginal;
/**判断是否视频还是图片*/
@property (nonatomic, assign) BOOL isPhotos;

/**图片上传路径**/
@property (nonatomic, strong) NSMutableArray *urlStringArray;
/**图片上传路径**/
@property (nonatomic, strong) NSMutableString *urlStringMutable;
@property (nonatomic, strong) NSMutableString *urlVideoMutable;
/**视频上传路径*/
@property (nonatomic, copy) NSString *videoUrlString;
/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager * locationManager;


@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation TMineNoteBookVc
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"发布笔记";
        self.wh_isGotoBack = YES;
        [self createHeadAndFoot];
        self.wh_tableBody.frame = CGRectZero;
        _videosArr = [[NSMutableArray alloc]init];
        _videoStrings = [[NSMutableArray alloc] init];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
        [btn addTarget:self action:@selector(publishButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.wh_tableHeader addSubview:btn];
        
        if(_isEdit){
            UIButton *moreBtn = [UIFactory WH_create_WHButtonWithImage:@"gengxin"
                                                             highlight:nil target:self selector:@selector(publishButtonItemClicked)];
                                  moreBtn.custom_acceptEventInterval = 1.0f;
            moreBtn.frame = CGRectMake(BTN_RANG_UP * 2, BTN_RANG_UP, NAV_BTN_SIZE, NAV_BTN_SIZE);
            [btn addSubview:moreBtn];
        }else{
            
            UIButton *moreBtn = [UIFactory WH_create_WHButtonWithImage:@"fabuxiangmufaqifabu"
                                       highlight:nil target:self selector:@selector(publishButtonItemClicked)];
            moreBtn.custom_acceptEventInterval = 1.0f;
            moreBtn.frame = CGRectMake(BTN_RANG_UP * 2, BTN_RANG_UP, NAV_BTN_SIZE, NAV_BTN_SIZE);
            [btn addSubview:moreBtn];
        }
        
    }
    return self;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEMEBACKCOLOR;
    
    _images = [[NSMutableArray alloc]init];
    _imageStrings = [[NSMutableArray alloc] init];
    
    _imageVideoStrings = [[NSMutableArray alloc] init];
    if(_isEdit){
//
        NSDictionary *dict = [_dictData objectForKey:@"body"];
//        [_imageVideoStrings addObjectsFromArray:dict[@"images"]];
        //如果是更新的话 先判断，从列列表点击进来的 数据是否包含 图片或者视频，如果包含了就先保存
        for (NSDictionary *dictImgs in dict[@"images"]) {
            [_imageStrings addObject:dictImgs[@"oUrl"]];
            [_images addObject:dictImgs[@"oUrl"]];
        }
 
        [self setupUIEdit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
    }else{
       [self setupUI];
    }
    
    [self wh_showImages];
 
}

#pragma mark 发布 ---  更新
-(void)publishButtonItemClicked {
    [self.view endEditing:true];
    if ([self.mContentTV.text length]==0) {
        [g_server showMsg:@"请输入内容"];
        return;
    }
    if ([self.title_tf.text length]==0) {
        [g_server showMsg:@"请输入标题"];
        return;
    }
    if (_imageStrings.count > 0) {
        NSString *localStr = @"";
        for (NSString *urllocalStr in _imageStrings) {
            if( [urllocalStr containsString:@"/var/mobile/Containers/Data"]){
                localStr = urllocalStr;
            }
        }
        if(localStr.length>0){
            for (NSString *urllocalStr in _imageStrings) {
                if([urllocalStr containsString:@"https://"]||[urllocalStr containsString:@"http://"]){
                }else{
                    [g_server uploadFile:urllocalStr validTime:@"-1" messageId:MY_USER_ID toView:self];
                }
            }
        }
        else{
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSString *urllocalStr in _imageStrings) {
                NSDictionary *dict = @{@"oFileName":@"imageStr",@"oUrl":urllocalStr,@"length":@0,@"size":@0,@"tUrl":urllocalStr};
                [tempArr addObject:dict];
            }
            if(_isEdit){
                [g_server WH_getact_NoteUpdateConfigUserId:[_dictData objectForKey:@"noteId"] imagesJson:tempArr body:self.mContentTV.text title:_title_tf.text toView:self];
            }else{
                 [g_server WH_getact_NoteAddConfigUserId:tempArr body:self.mContentTV.text title:_title_tf.text toView:self];
            }
        }
    }else{
        if(_isEdit){
            [g_server WH_getact_NoteUpdateConfigUserId:[_dictData objectForKey:@"noteId"] imagesJson:_imageVideoStrings body:self.mContentTV.text title:_title_tf.text toView:self];
        }else{
             [g_server WH_getact_NoteAddConfigUserId:_imageVideoStrings body:self.mContentTV.text title:_title_tf.text toView:self];
        }
         
    }
    
 
  //  NSString *timeSp = [NSString stringWithFormat:@"%.0lf", (double)[[NSDate  date] timeIntervalSince1970]*1000];
  //  [g_server uploadFile:urllocalStr validTime:@"-1" messageId:timeSp toView:self];
  //  [g_server uploadFile:_images audio:@"" video:@"" file:@"" type:2+1 validTime:@"-1" timeLen:0 toView:self];
    
     
  
}
 
- (void)donone{
    
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 1;//最大的选择数目
    photoController.configuration.containVideo = YES;//选择类型，目前只选择图片不选择视频
    photoController.configuration.containImage = NO;//选择类型，目前只选择视频不选择图片
    photoController.photo_delegate = self;
//    photoController.thumbnailSize = CGSizeMake(220, 220);//缩略图的尺寸
    //    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    photoController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoController animated:true completion:^{}];
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
     
    NSInteger n = [_images count];
    CGFloat width = (_svImages.width - 20)/3;
    NSMutableArray *tempArr = [NSMutableArray array];
//    if(_isEdit){
//        NSDictionary *dict = [_dictData objectForKey:@"body"];
//        for (NSDictionary *dictObj in dict[@"images"]) {
//            //if([dictObj[@"oFileName"] hasSuffix:@".jpg"]){}
//             [tempArr addObject:dictObj[@"oUrl"]];
//
//        }
//        n = tempArr.count;
//    }
    
   // _svImages.frame = CGRectMake(_svImages.frame.origin.x, _svImages.frame.origin.y, _svImages.width, _svImages.contentSize.height);
   // _svImages.contentSize = CGSizeMake( n * (width + 5),110*3);
   // _svImages.contentSize = CGSizeMake(_svImages.width, (n / 3 + 1) * (width + 5));
    for(i=0;i<n&&i<9;i++){
        WH_JXImageView* iv = [[WH_JXImageView alloc]initWithFrame:CGRectMake(i * (width +5), 5, width,width)];
        iv = [[WH_JXImageView alloc]initWithFrame:CGRectMake(10+(i % 3) * (width +5), 8+(i / 3) * (width + 7), width,width)];
        iv.wh_delegate = self;
        iv.userInteractionEnabled = YES;
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        iv.didTouch = @selector(actionImage:);
        [iv addLongPressGesture];
        [iv addTapGesture];
        iv.wh_animationType = WH_JXImageView_Animation_Line;
        iv.tag = i;
        if([[_images objectAtIndex:i] isKindOfClass:[UIImage class]] ){
            iv.image = [_images objectAtIndex:i];
        }else{
            iv.ourlEdit = [_images objectAtIndex:i];
        }
//        if(_isEdit){
//            iv.ourlEdit = [tempArr objectAtIndex:i];
//        }else{
//
//            iv.image = [_images objectAtIndex:i];
//        }
        [_svImages addSubview:iv];
    }
    if (n == 9) {
        return; 
    }
    
    _imageViewArray = [NSMutableArray arrayWithArray:_svImages.subviews];
    _svImages.contentSize = CGSizeMake( n * (width + 5)+width+5,110);
    //添加图片
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"newicon_publishImage"] forState:UIControlStateNormal];
    [_svImages addSubview:addImageBtn];
 //   addImageBtn.frame = CGRectMake(10+i* (width +5), 10, width, width);
    addImageBtn.frame = CGRectMake(10+(i % 3) * (width +5), 8+(i / 3) * (width + 7), width, width);
    addImageBtn.tag = insert_photo_tag;
    [addImageBtn addTarget:self action:@selector(actionImage:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)getTouchWhenMove:(WH_JXImageView *)imageView withTouch:(NSSet *)touch withEvent:(UIEvent *)event withLongPressGes:(UILongPressGestureRecognizer *)lpGes{
    UITouch *mytouch = touch.allObjects.lastObject;
    CGPoint inWindow = [mytouch locationInView:nil];
    if ((inWindow.x > JX_SCREEN_WIDTH - 30 && inWindow.x < JX_SCREEN_WIDTH && _svImages.contentOffset.x == 0) || (inWindow.x < 30 && _svImages.contentOffset.x > 0)) {
        if (_inBorder) {
            _stayBorderTime = mytouch.timestamp - _intoBorderTime;
            if (_stayBorderTime > 0.3) {
                [self changeWhenPan:imageView gesture:lpGes];
            }
        }else{
            _inBorder = YES;
            _intoBorderTime = mytouch.timestamp;
        }
    }else{
        _inBorder = NO;
        _intoBorderTime = 0;
    }
}

- (void)changeWhenPan:(WH_JXImageView *)sender gesture:(UILongPressGestureRecognizer *)sender2{
    BOOL isBorderStart = NO;
    if (sender2.state == UIGestureRecognizerStateBegan) {
        [_svImages setScrollEnabled:NO];
        sender.alpha = 0.5;
        self.startPoint = [sender2 locationInView:_svImages];
        CGPoint inWindow = [sender2 locationInView:nil];
        if ((inWindow.x > JX_SCREEN_WIDTH - 30 && inWindow.x < JX_SCREEN_WIDTH && _svImages.contentOffset.x == 0) || (inWindow.x < 30 && _svImages.contentOffset.x > 0)) {
            isBorderStart = YES;
        }else{
            isBorderStart = NO;
        }
        self.oraginPoint = sender.center;
        _lastPoint = _oraginPoint;
        [self.view bringSubviewToFront:_svImages];
        [_svImages bringSubviewToFront:sender];
    }else if (sender2.state == UIGestureRecognizerStateChanged) {
        self.newPoint = [sender2 locationInView:_svImages];
        CGFloat xChange = _newPoint.x - _startPoint.x;
        CGFloat yChange = _newPoint.y - _startPoint.y;
        sender.center = CGPointMake(_oraginPoint.x + xChange, _oraginPoint.y + yChange);
        CGPoint inWindow = [sender2 locationInView:nil];
        if (isBorderStart) {
            if ((inWindow.x < JX_SCREEN_WIDTH - 30 && _svImages.contentOffset.x == 0) && (inWindow.x > 30 && _svImages.contentOffset.x > 0)){
                isBorderStart = NO;
            }
        }
        if (inWindow.x < 30 && _svImages.contentOffset.x > 0 && !isBorderStart && _stayBorderTime > 0.3) {
            for (int num = 0; num <_imageViewArray.count; num++) {
                WH_JXImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                [_svImages setContentOffset:CGPointMake(0, 0)];
            }];
            _stayBorderTime = 0;
            _inBorder = NO;
            NSInteger index = sender.tag;
            for (NSInteger i = index - 1; i > -1; i--) {
                WH_JXImageView *imgView = _imageViewArray[i];
                [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:imgView.tag + 1];
                [UIView animateWithDuration:0.5 animations:^{
                    imgView.tag = imgView.tag + 1;
                    CGPoint center = imgView.center;
                    imgView.center = _lastPoint;
                    _lastPoint = center;
                }];
            }
            sender.tag = 0;

        }else if (inWindow.x > g_window.frame.size.width - 30 && _newPoint.x < _svImages.contentSize.width && !isBorderStart && _stayBorderTime > 0.3) {
            for (int num = 0; num <_imageViewArray.count; num++) {
                WH_JXImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                [_svImages setContentOffset:CGPointMake(_svImages.contentSize.width - JX_SCREEN_WIDTH, 0)];
            }];
            _stayBorderTime = 0;
            _inBorder = NO;
            NSInteger index = sender.tag;
            for (NSInteger i = index + 1; i < _imageViewArray.count; i++) {
                WH_JXImageView *imgView = _imageViewArray[i];
                [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:imgView.tag - 1];
                [UIView animateWithDuration:0.5 animations:^{
                    imgView.tag = imgView.tag - 1;
                    CGPoint center = imgView.center;
                    imgView.center = _lastPoint;
                    _lastPoint = center;
                }];
            }
            sender.tag = _imageViewArray.count - 1;

        }else{
            for (int num = 0; num <_imageViewArray.count; num++) {
                WH_JXImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            for (NSInteger i = 0;i < _imageViewArray.count; i++) {
                WH_JXImageView * imgView = _imageViewArray[i];
                if (CGRectContainsPoint(imgView.frame, _newPoint)) {
                    if (imgView == sender) {
                        continue;
                    }
                    [UIView animateWithDuration:0.3 animations:^{
                        CGPoint point = imgView.center;
                        imgView.center = _lastPoint;
                        _lastPoint = point;
                    }];
                    [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:sender.tag];
                    NSInteger l = imgView.tag;
                    imgView.tag = sender.tag;
                    sender.tag = l;
                }
            }
            if (!CGRectContainsPoint(_svImages.bounds, _newPoint)) {
                [sender2 setState:UIGestureRecognizerStateEnded];
            }
        }
    
    }else if(sender2.state == UIGestureRecognizerStateEnded) {
        sender.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            sender.center = _lastPoint;
        }];
        [_svImages setScrollEnabled:YES];
    }
}

- (void)updateUI {
    int h=9,w=JX_SCREEN_WIDTH-9*2;
    CGFloat maxY = 0;
    
    
}
- (void)actionImage:(WH_JXImageView*)sender{
    _photoIndex = sender.tag;
//    [self pickImages:YES];
//
//    return;
    if(_photoIndex==insert_photo_tag&&[_images count]>8){
        [g_App showAlert:Localized(@"addMsgVC_SelNinePhoto")];
        return;
    }else if(_photoIndex==insert_photo_tag){
        
        WH_JXActionSheet_WHVC *actionVC = [[WH_JXActionSheet_WHVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
        actionVC.delegate = self;
        actionVC.wh_tag = 111;
        [self presentViewController:actionVC animated:NO completion:nil];
        
        return;
    }
    LXActionSheet* _menu = [[LXActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:Localized(@"JX_Cencal")
                            destructiveButtonTitle:Localized(@"JX_Update")
                            otherButtonTitles:@[Localized(@"JX_Delete")]];
      _menu = [[LXActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:Localized(@"JX_Cencal")
                            destructiveButtonTitle:@"查看"
                            otherButtonTitles:@[Localized(@"JX_Delete")]];
    
    [g_window addSubview:_menu];
//    [_menu release];
}


- (void)actionSheet:(WH_JXActionSheet_WHVC *)actionSheet didButtonWithIndex:(NSInteger)index {

    if (index == 0) {
        
        self.wh_maxImageCount = self.wh_maxImageCount - (int)[_images count];
        self.isUpdateImage = NO;
        [self pickImages:YES];
        
    }else {
        WH_JXCamera_WHVC *vc = [WH_JXCamera_WHVC alloc];
        vc.cameraDelegate = self;
        vc.isPhoto = YES;
        vc = [vc init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

#pragma mark - 拍摄视频
- (void)cameraVC:(WH_JXCamera_WHVC *)vc didFinishWithImage:(UIImage *)image {
    [_images addObject:image];
    [self wh_showImages];
    
    if ([g_config.isOpenOSStatus integerValue]) {
        // 普通图片
        NSString *name = @"jpg";
        
        NSString *file = [FileInfo getUUIDFileName:name];
        //图片存储到本地
        [g_server WH_saveImageToFileWithImage:image file:file isOriginal:YES];
        
        [_imageStrings addObject:file];
    }
}
- (void)cameraVC:(WH_JXCamera_WHVC *)vc didFinishWithVideoPath:(NSString *)filePath timeLen:(NSInteger)timeLen{
    
    
    
}
- (void)didClickOnButtonIndex:(LXActionSheet*)sender buttonIndex:(int)buttonIndex{
    if(buttonIndex<0)
        return;
    _nSelMenu = buttonIndex;
    [self doOutputMenu];
}


- (void)doOutputMenu{
    if(_nSelMenu==0){
       
        if(_photoIndex == video_tag){
            [self onAddVideo];
            return;
        }
        self.isUpdateImage = YES;
//        [self pickImages:NO];  //更新
        NSString *oUrltype =_imageStrings[_photoIndex];;
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
    if(_nSelMenu==1){
      
        if(_photoIndex == video_tag){
            [self onDelVideo];
            return;
        }
        
        [_imageStrings removeObjectAtIndex:_photoIndex];
        [_images removeObjectAtIndex:_photoIndex];
        [self wh_showImages];
    }
}

- (BOOL) hideKeyboard {
    [self.view endEditing:YES];
    return YES;
}
- (void)onAddVideo{
    [self hideKeyboard];
  
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 1;//最大的选择数目
    photoController.configuration.containVideo = YES;//选择类型，目前只选择图片不选择视频
    photoController.configuration.containImage = NO;//选择类型，目前只选择视频不选择图片
    photoController.photo_delegate = self;
//    photoController.thumbnailSize = CGSizeMake(220, 220);//缩略图的尺寸
    //    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    photoController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoController animated:true completion:^{}];
}

- (void)onDelVideo{
    _wh_videoFile = nil;
    
}

- (void)showTheVideo{
    _videoPlayer= [WH_JXVideoPlayer alloc];
    _videoPlayer.videoFile = _wh_videoFile;
    _videoPlayer.WH_didVideoPlayEnd = @selector(WH_didVideoPlayEnd);
    _videoPlayer.isStartFullScreenPlay = YES; //全屏播放
    _videoPlayer.delegate = self;
    _videoPlayer = [_videoPlayer initWithParent:self.view];
    [_videoPlayer wh_switch];
}

 


- (void)pickImages:(BOOL)Multi{
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
   
    if (!self.isUpdateImage) {
        photoController.configuration.maxCount = 9 - _images.count;//最大的选择数目
    }else {
        photoController.configuration.maxCount = 1;//最大的选择数目
    }
    
    
    
  //  photoController.configuration.containVideo = NO;//选择类型，目前只选择图片不选择视频
    
    photoController.photo_delegate = self;
    photoController.thumbnailSize = CGSizeMake(320, 320);//缩略图的尺寸
    //    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    photoController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoController animated:true completion:^{}];
 
}

#pragma mark - 发送原图
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos {
   
    
    if (self.isUpdateImage) {
        if(images.count>0){
            _images[_photoIndex] = images.firstObject;
            //  [_images replaceObjectAtIndex:_photoIndex withObject:images.firstObject];
        }
    }else {
        [_images addObjectsFromArray:images.mutableCopy];
    }
    [self wh_showImages];
}
#pragma mark - 发送缩略图
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos {
    
    if (self.isUpdateImage) {
        if(thumbnailImages.count>0){
            _images[_photoIndex] = thumbnailImages.firstObject;
            //  [_images replaceObjectAtIndex:_photoIndex withObject:thumbnailImages.firstObject];
        }
    }else {
        [_images addObjectsFromArray:thumbnailImages.mutableCopy];
    }
    
    [self wh_showImages];
}

#pragma mark - 发送图片
- (void)photosViewController:(UIViewController *)viewController datas:(NSArray <id> *)datas; {
     
    for (int i = 0; i < datas.count; i++) {
        // 普通图片
        UIImage *chosedImage = datas[i];
        NSString *name = @"jpg";
        NSString *file = [FileInfo getUUIDFileName:name];
        //图片存储到本地
        [g_server WH_saveImageToFileWithImage:chosedImage file:file isOriginal:YES];
        if (self.isUpdateImage) {
            [_imageStrings replaceObjectAtIndex:_photoIndex withObject:file];
        }else{
            
           [_imageStrings addObject:file];
        }
        
    }
    
}
 
#pragma mark - 发送视频
- (void)photosViewController:(UIViewController *)viewController media:(WH_JXMediaObject *)media {
//    [_images removeAllObjects];
    media.userId = g_myself.userId;
    media.isVideo = [NSNumber numberWithBool:YES];
    [media insert];
    
    NSString* file = media.fileName;
    UIImage *image = [FileInfo getFirstImageFromVideo:file];
     _wh_videoFile = [file copy];
//     file = [NSString stringWithFormat:@"%@.jpg",[file stringByDeletingPathExtension]];
//     [_videosArr addObject:[UIImage imageWithContentsOfFile:file]];
     [_videosArr addObject:image];
    NSString *name = @"jpg";
    NSString *imagefile = [FileInfo getUUIDFileName:name];
    [_videoStrings addObject:_wh_videoFile];
  
    if (self.isUpdateImage) {
        _images[_photoIndex] = image;
        [_imageStrings replaceObjectAtIndex:_photoIndex withObject:file];
      //  [_images replaceObjectAtIndex:_photoIndex withObject:thumbnailImages.firstObject];
    }else {
        [_imageStrings addObject:file];
        [_images addObject:image];
    }
    
    
    NSLog(@"file,_wh_videoFile=%@ %@",file,_wh_videoFile);
    NSLog(@"imagefile = %@",imagefile);
    
    if ([g_config.isOpenOSStatus integerValue]) {
        NSString *name = @"jpg";
        NSString *imagefile = [FileInfo getUUIDFileName:name];
        //图片存储到本地
        [g_server WH_saveImageToFileWithImage:image file:imagefile isOriginal:YES];
        [_imageStrings addObject:imagefile];
        
    }
    
  //  [self showVideos];
    [self wh_showImages];
    
}
#pragma mark ==============
#pragma mark 初始化 编辑时候的视图
- (void)setupUIEdit {
    
    NSDictionary *dict = [_dictData objectForKey:@"body"];
   UITextField *title_tf = [[UITextField alloc] init];
    title_tf.placeholder =  @"请输入标题";
    title_tf.text =  [dict objectForKey:@"title"];
    title_tf.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:title_tf];
    _title_tf = title_tf;
   [title_tf mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(15);
       make.right.mas_equalTo(-15);
       make.top.equalTo(self.view).offset(Height_NavBar+10);
       make.height.mas_equalTo(44);
       
   }];
    
    self.mContentTV.text =  [dict objectForKey:@"text"];
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

#pragma mark 初始化视图
- (void)setupUI {
    self.wh_isGotoBack = YES;
    self.title = @"发布";
   
    [self createHeadAndFoot];
    self.wh_tableBody.frame = CGRectZero;
    // 发布
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
    [btn addTarget:self action:@selector(publishButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.wh_tableHeader addSubview:btn];
    UIButton *moreBtn = [UIFactory WH_create_WHButtonWithImage:@"fabuxiangmufaqifabu"
                                  highlight:nil   target:self   selector:@selector(publishButtonItemClicked)];
    moreBtn.custom_acceptEventInterval = 1.0f;
    moreBtn.frame = CGRectMake(BTN_RANG_UP * 2, BTN_RANG_UP, NAV_BTN_SIZE, NAV_BTN_SIZE);;
    [btn addSubview:moreBtn];
    
   
    //[self.view addSubview:self.mScrollView];
//    [self.mScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).offset(Height_NavBar);
//    }];
    
    
   UITextField *title_tf = [[UITextField alloc] init];
    title_tf.placeholder = @"请输入标题";
    title_tf.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:title_tf];
    _title_tf = title_tf;
   [title_tf mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(15);
       make.right.mas_equalTo(-15);
       make.top.equalTo(self.view).offset(Height_NavBar+10);
       make.height.mas_equalTo(44);
       
   }];
    
   
    [self.view addSubview:self.mContentTV];
    [self.mContentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(title_tf.mas_bottom).offset(10);
        make.height.mas_equalTo(150);
    }];
     
     
    
    [self.view addSubview:self.photoView];
    _photoView.userInteractionEnabled = YES;
    _photoView.backgroundColor = [UIColor cyanColor];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.equalTo(self.mContentTV.mas_bottom).offset(10);
        make.height.mas_equalTo(110*3);
        
    }];
      
    
}

 
//视频选择
- (void)imageTapVideoclick{
    
    
}
//图片选择
- (void)imageTapclick{
    
    // 一个方法调用
    

    // 照片选择控制器
//    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithManager:self.photoManager delegate:self];
//    [self presentViewController:nav animated:YES completion:nil];

}
/**
点击完成按钮

@param photoNavigationViewController self
@param allList 已选的所有列表(包含照片、视频)
@param photoList 已选的照片列表
@param videoList 已选的视频列表
@param original 是否原图
*/
 

/**
点击取消

@param photoNavigationViewController self
*/
 
  
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange == nil) {
        if (textView.text.length > 155) {
            textView.text = [textView.text substringToIndex:155];
        }
    }
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
 

- (NSMutableArray *)assetArray {
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
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
    if([aDownload.action isEqualToString:wh_act_UploadFile]){
        NSDictionary* p = nil;
        if([[dict objectForKey:@"audios"] count]>0)
            p = [[dict objectForKey:@"audios"] objectAtIndex:0];
        if([[dict objectForKey:@"images"] count]>0)
            p = [[dict objectForKey:@"images"] objectAtIndex:0];
        if([[dict objectForKey:@"videos"] count]>0)
            p = [[dict objectForKey:@"videos"] objectAtIndex:0];
        if(p==nil)
            p = [[dict objectForKey:@"others"] objectAtIndex:0];
         [_imageVideoStrings addObject:p];
        NSLog(@"和 == %zd",_imageStrings.count+_videoStrings.count);
        NSLog(@"和2 ==%@",_imageVideoStrings);
        for (NSString *imageStr in _imageStrings) {
            if([imageStr hasPrefix:@"http://"]||[imageStr hasPrefix:@"https://"]){
                NSDictionary *dict = @{@"oFileName":@"imageStr",@"oUrl":imageStr,@"length":@0,@"size":@0,@"tUrl":imageStr};
                 [_imageVideoStrings addObject:dict];
            }
        }
        if (_imageVideoStrings.count==_imageStrings.count) { 
            if(_isEdit){
                [g_server WH_getact_NoteUpdateConfigUserId:[_dictData objectForKey:@"noteId"] imagesJson:_imageVideoStrings body:self.mContentTV.text title:_title_tf.text toView:self];
            }else{
                 [g_server WH_getact_NoteAddConfigUserId:_imageVideoStrings body:self.mContentTV.text title:_title_tf.text toView:self];
            } 
       
        }
        
        p = nil;
        
    }
    if( [aDownload.action isEqualToString:wh_act_UserGet] ){
  
         
    }
    if( [aDownload.action isEqualToString:act_NoteUpdateConfig] ){
        
        [self actionQuit];
        [g_server showMsg:@"更新成功"];
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
