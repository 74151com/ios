//
//  TPengyouquanImageCollectionViewCell.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TPengyouquanImageCollectionViewCell.h"

@implementation TPengyouquanImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setData:(TPengyouquanPicModel *)model {
   // if (![TUtils isEmptyString:model.url]) {
        [self.mIV sd_setImageWithURL: [NSURL URLWithString:model.url]];
   // }
}

- (void)setDataDict:(NSDictionary *)model{
    
    NSString *oUrltype = [model objectForKey:@"oUrl"];
//    if([oUrltype hasSuffix:@".mp4"]){
//      UIImage *videoImg =   [FileInfo  getVideoFirstViewImage:[NSURL URLWithString:oUrltype]];
//       [self.mIV setImage:videoImg];
//    }else{
//    }
    _mHeaderIV.hidden = NO;
    if([oUrltype hasSuffix:@".mp4"]) {//判断是否是视频链接
        [FileInfo getFirstImageFromVideo:oUrltype imageView:_mIV];
    }else if (isFileExist(oUrltype)){//判断是否是本地路径
        [FileInfo getFirstImageFromVideo:oUrltype imageView:_mIV];
    }else {//oUrltype是图片地址 直接显示
        _mHeaderIV.hidden = YES;
        [self.mIV sd_setImageWithURL:[NSURL URLWithString:oUrltype] placeholderImage:[UIImage imageNamed:@"WH_PocketArea"]];

    }
    
}


//    if ([model.filetype isEqualToString:@"2"]) {
//        if (![TUtils isEmptyString:model.videourl]) {
//
//            if (self.playerLayer != nil) {
//                [self.playerLayer removeFromSuperlayer];
//            }
//            [self.mCollectionView removeGestureRecognizer:self.tapGesture];
//            [self.mCollectionView addGestureRecognizer:self.tapGesture];
//            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.videourl]];
//            self.avplayer =[[AVPlayer alloc] initWithPlayerItem:self.playerItem];
//            self.avplayer.volume = 0;
//
//            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
//            self.playerLayer.frame = self.mCollectionView.bounds;
//            [self.mCollectionView.layer addSublayer:self.playerLayer];
//            self.playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
//            [self.avplayer play];
//        }
//    } else {
//        [self.mCollectionView removeGestureRecognizer:self.tapGesture];
//    }

#pragma mark 初始化视图
-(void)setupUI {
    [self.contentView addSubview:self.mIV];
    [self.mIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self addSubview:self.mHeaderIV];
    [self.mHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.width.height.mas_equalTo(30);
    }];
    
}

#pragma mark 懒加载
-(UIImageView *)mIV {
    if (!_mIV) {
        _mIV = [[UIImageView alloc] init];
        _mIV.contentMode = UIViewContentModeScaleAspectFill;
        _mIV.clipsToBounds = true;
        _mIV.layer.cornerRadius = 5;
        _mIV.layer.masksToBounds = true;
    }
    return _mIV;
}
-(UIImageView *)mHeaderIV {
    if (!_mHeaderIV) {
        _mHeaderIV = [[UIImageView alloc] init];
        _mHeaderIV.contentMode = UIViewContentModeScaleAspectFill;
        _mHeaderIV.clipsToBounds = true;
        _mHeaderIV.layer.cornerRadius = 5;
        _mHeaderIV.hidden = YES;
        _mHeaderIV.layer.masksToBounds = true;
        _mHeaderIV.image = [UIImage imageNamed:@"playAudio"];
       // UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mHeaderIVGestureRecognizerAction:)];
        _mHeaderIV.userInteractionEnabled = YES;
       // [_mHeaderIV addGestureRecognizer:tap];
    }
    return _mHeaderIV;
}
@end
