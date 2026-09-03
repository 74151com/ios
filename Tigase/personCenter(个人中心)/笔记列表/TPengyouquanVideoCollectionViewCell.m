//
//  TPengyouquanVideoCollectionViewCell.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TPengyouquanVideoCollectionViewCell.h"

@interface TPengyouquanVideoCollectionViewCell()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) TPengyouquanListModel *mPengyouquanListModel;
@end

@implementation TPengyouquanVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
    }
    return self;
}
#pragma mark 初始化视图
-(void)setupUI {
    
    [self addSubview:self.mHeaderIV];
    [self.mHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-15);
        make.width.height.mas_equalTo(30);
    }];
}
-(UIImageView *)mHeaderIV {
    if (!_mHeaderIV) {
        _mHeaderIV = [[UIImageView alloc] init];
        _mHeaderIV.contentMode = UIViewContentModeScaleAspectFill;
        _mHeaderIV.clipsToBounds = true;
        _mHeaderIV.layer.cornerRadius = 5;
        _mHeaderIV.layer.masksToBounds = true;
        _mHeaderIV.image = [UIImage imageNamed:@"playAudio"];
       // UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mHeaderIVGestureRecognizerAction:)];
        _mHeaderIV.userInteractionEnabled = YES;
       // [_mHeaderIV addGestureRecognizer:tap];
    }
    return _mHeaderIV;
}

- (void)mHeaderIVGestureRecognizerAction:(UITapGestureRecognizer*)tap{
     
}

- (void)setData:(TPengyouquanListModel *)model {
    self.mPengyouquanListModel = model;
    if (self.playerLayer != nil) {
        [self.playerLayer removeFromSuperlayer];
    }
    
    NSDictionary *modelx = model.videoUrls.firstObject;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:modelx[@"url"]]];
    self.avplayer =[[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.avplayer.volume = 0;
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    self.playerLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:self.playerLayer];
    self.playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
    [self.avplayer pause];
    
    
   [self setupUI];
}

-(void)playbackFinished:(NSNotification *)notif {
    CGFloat a=0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.avplayer seekToTime:dragedCMTime];
    [self.avplayer play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
}

 

@end
