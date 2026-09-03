//
//  TMineNoteListCell.m
//  tio-chat-ios
//
//  Created by os on 2023/12/19.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TMineNoteListCell.h"
//#import "FrameAccessor.h"
#import <Photos/Photos.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UITapGestureRecognizer+TTapBlockAction.h"
//#import <libkern/OSAtomic.h>
#import "WH_ImageBrowser_WHViewController.h"


#import "TPengyouquanListTableViewCell.h"
#import "UIButton+Enlarge.h"
#import "TPengyouquanImageCollectionViewCell.h"
#import "TPengyouquanVideoCollectionViewCell.h"
#import "UILabel+Add.h"
#import "TUtils.h"
//#import <YBImageBrowser.h>
//#import <YBImageBrowser/YBIBVideoData.h>
//#import "UITapGestureRecognizer+TTapBlockAction.h"
 
@interface TMineNoteListCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
 
@property (nonatomic,   strong) NSDictionary *pengyouquanListModel;
@end

@implementation TMineNoteListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 如果不可以交互 | 隐藏 | 透明度太小 3者任意一个都忽略不能点击
    if(!self.userInteractionEnabled || self.hidden || self.alpha<=0.01){
        return nil;
    }
    
    UIView *view = [super hitTest:point withEvent:event];

    if ([view isKindOfClass:[UICollectionView class]] ||
        [view isKindOfClass:[TPengyouquanImageCollectionViewCell class]] || [view isKindOfClass:[TPengyouquanVideoCollectionViewCell class]]) {
        return self;
    }
    return view;
}

-(void)setDatabb:(NSDictionary *)model{
//    _vipLabel.text = [NSString stringWithFormat:@"%@",model[@"body"][@"title"]];
//    _expireLabel.text = [NSString stringWithFormat:@"%@",model[@"body"][@"text"]];
     
    NSArray *videoUrlsArr = model[@"body"][@"images"];
    NSString *videoUrl = [videoUrlsArr.firstObject objectForKey:@"oUrl"];
    // 测试用途，请忽略不严谨逻辑 type 1图片 2 视频
    CGFloat padding = 5, imageViewLength = ([UIScreen mainScreen].bounds.size.width - padding * 2) / 3 - 10, scale = [UIScreen mainScreen].scale;
    CGSize imageViewSize = CGSizeMake(imageViewLength * scale, imageViewLength * scale);
     
    if (videoUrlsArr.count>0) {
        NSString *imageStr = videoUrl;
        if ([imageStr hasSuffix:@".mp4"]) {
            
            AVURLAsset *avAsset = nil;
            if ([imageStr hasPrefix:@"http"]||[imageStr hasPrefix:@"https"]) {
                avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:imageStr]];
            } else {
                NSString *path = [[NSBundle mainBundle] pathForResource:imageStr.stringByDeletingPathExtension ofType:imageStr.pathExtension];
                avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
            }
            
            if (avAsset) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                    generator.appliesPreferredTrackTransform = YES;
                    generator.maximumSize = imageViewSize;
                    NSError *error = nil;
                    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                    UIImage *resultImg = [UIImage imageWithCGImage:cgImage];
                    if (cgImage) CGImageRelease(cgImage);
                    dispatch_async(dispatch_get_main_queue(), ^{
                      //  self.contentVideoView.image = resultImg;
                    });
                });
            }
            
        }
        else{
            
          //  [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:videoUrl] placeholderImage:nil];
        }
        
    }
    
    
}
#pragma mark 设置数据
- (void)setData:(NSDictionary *)model {
    
    self.pengyouquanListModel = model;
    
//    if (![TUtils isEmptyString:model[@"userId"]]) {
//      //  [self.mHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.avatar.tio_resourceURLString] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
//    }
    
     _mNicknameLbl.text = [NSString stringWithFormat:@"%@",model[@"body"][@"title"]];
    NSString *textStr =  [NSString stringWithFormat:@"%@",model[@"body"][@"text"]];
    self.mTimeLbl.text = @"";
    
    [self.mContentLbl setLineSpaceWithTotalString:textStr LineSpace:kLineSpace];
     
    
    [self.mCollectionView reloadData];
    [self.mContentView layoutIfNeeded];
    [self layoutIfNeeded];
    NSArray *videoUrlsArr = model[@"body"][@"images"];
    NSLog(@"xxxxxxxxx%f", self.mFlowLayout.collectionViewContentSize.height);
    if ([videoUrlsArr count]==0) {
        [self.mCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        [self.mCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (videoUrlsArr.count % 3 == 0) {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(videoUrlsArr.count/3)+10*((videoUrlsArr.count/3-1)));
            } else {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(videoUrlsArr.count/3+1)+10*((videoUrlsArr.count/3)));
            }
            
        }];
    }
    

}

#pragma mark uicollectionView -- delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *videoUrlsArr = self.pengyouquanListModel[@"body"][@"images"];
     
    return videoUrlsArr.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *videoUrlsArr = self.pengyouquanListModel[@"body"][@"images"];
    if ([videoUrlsArr count]>0) {
        return CGSizeMake((JX_SCREEN_WIDTH-15*2-10*2)/3-1, (JX_SCREEN_WIDTH-15*2-10*2)/3-1);
    } else {
        return CGSizeZero;
        
   }
   
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *videoUrlsArr = self.pengyouquanListModel[@"body"][@"images"];
      
    if ([videoUrlsArr count]>0) {
        // 图片
        TPengyouquanImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPengyouquanImageCollectionViewCell class]) forIndexPath:indexPath];
        [cell setDataDict:videoUrlsArr[indexPath.row]];
        return cell;
    }  else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }
        // 视频
//        TPengyouquanVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPengyouquanVideoCollectionViewCell class]) forIndexPath:indexPath];
//        [cell setDataDict:self.pengyouquanListModel];
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *videoUrlsArr = self.pengyouquanListModel[@"body"][@"images"];
    NSDictionary *modelDict = videoUrlsArr[indexPath.row];
    NSString *oUrltype = [modelDict objectForKey:@"oUrl"];
    if([oUrltype hasSuffix:@".mp4"]) {//判断是否是视频链接
        
        _player= [WH_JXVideoPlayer alloc];
        _player.type = JXVideoTypeChat;
        _player.isShowHide = YES; //播放中点击播放器便销毁播放器
        _player.isStartFullScreenPlay = YES; //全屏播放
        _player.WH_didVideoPlayEnd = @selector(WH_didVideoPlayEnd);
        _player.delegate = self;
     
        if (oUrltype) {
            _player.videoFile = oUrltype;
        }else  if(isFileExist(oUrltype)) {
            _player.videoFile = oUrltype;
        }
        
        _player = [_player initWithParent:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_player wh_switch];
        });
        
    }else{
        
        if(_tapVideoImageBlock){
            _tapVideoImageBlock(oUrltype);
        }
        
        
    }
    if ([self.pengyouquanListModel[@"body"][@"text"] isEqualToString:@"1"]) {
        // 图片
//        NSMutableArray *imageDatas = [NSMutableArray array];
//        for (int i = 0; i < self.pengyouquanListModel.picList.count; i ++) {
//            YBIBImageData *imageData = [[YBIBImageData alloc] init];
//            imageData.imageURL = [NSURL URLWithString:self.pengyouquanListModel.picList[i].url];
//            [imageDatas addObject:imageData];
//        }
//        YBImageBrowser *ybimageBrowser = [YBImageBrowser new];
//        ybimageBrowser.dataSourceArray = imageDatas;
//        ybimageBrowser.currentPage = indexPath.row;
//
//        [ybimageBrowser show];
    } else if ([self.pengyouquanListModel[@"body"][@"text"]  isEqualToString:@"2"]) {
        // 视频
//        NSMutableArray *imageDatas = [NSMutableArray array];
//        YBIBVideoData *videoData = [YBIBVideoData new];
//        videoData.videoURL = [NSURL URLWithString:self.pengyouquanListModel.videourl];
//
//        [imageDatas addObject:videoData];
//        YBImageBrowser *ybimageBrowser = [YBImageBrowser new];
//        ybimageBrowser.dataSourceArray = imageDatas;
//        ybimageBrowser.currentPage = 0;
//
//        [ybimageBrowser show];
    } else {
        
    }

}

#pragma mark 初始化视图
-(void)setupUI {
    [self.contentView addSubview:self.mContentView];
    [self.mContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.mContentView addSubview:self.mHeaderIV];
    [self.mHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mContentView).offset(5);
        make.top.equalTo(self.mContentView).offset(15);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    [self.mContentView addSubview:self.mNicknameLbl];
    [self.mNicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mHeaderIV.mas_right).offset(10);
        make.top.equalTo(self.mHeaderIV).offset(4);
    }];
    
    [self.mContentView addSubview:self.mMoreBtn];
    _mMoreBtn.hidden = YES;
    [self.mMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mNicknameLbl);
        make.width.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
      
    [self.mContentView addSubview:self.mContentLbl];
    [self.mContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mContentView).offset(15);
        make.right.equalTo(self.mContentView).offset(-15);
      //  make.top.equalTo(self.mHeaderIV.mas_bottom).offset(10);
        make.top.equalTo(self.mNicknameLbl.mas_bottom).offset(10);
    }];
    
    [self.mContentView addSubview:self.mCollectionView];
    [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mContentView).offset(15);
        make.right.equalTo(self.mContentView).offset(-15);
        make.top.equalTo(self.mContentLbl.mas_bottom).offset(10);
        make.bottom.equalTo(self.mContentView).offset(-15); //这个是去调了评论需要增加这个
        make.height.mas_equalTo(0);
    }];
    
//    [self.mContentView addSubview:self.mCommentNumBtn];
//    [self.mCommentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.equalTo(self.mCollectionView.mas_bottom).offset(15);
//        make.bottom.equalTo(self.mContentView).offset(-15);
//        make.height.mas_equalTo(20);
//    }];
//
//    [self.mContentView addSubview:self.mLikeBtn];
//    [self.mLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mCommentNumBtn.mas_right).offset(100);
//        make.height.centerY.equalTo(self.mCommentNumBtn);
//    }];
}

#pragma mark 懒加载
-(UIView *)mContentView {
    if (!_mContentView) {
        _mContentView = [[UIView alloc] init];
        _mContentView.backgroundColor = [UIColor whiteColor]; //HMRandomColor;//
    }
    return _mContentView;
}

-(UIImageView *)mHeaderIV {
    if (!_mHeaderIV) {
        _mHeaderIV = [[UIImageView alloc] init];
        _mHeaderIV.contentMode = UIViewContentModeScaleAspectFill;
        _mHeaderIV.clipsToBounds = true;
        _mHeaderIV.layer.cornerRadius = 5;
        _mHeaderIV.layer.masksToBounds = true;
        _mHeaderIV.userInteractionEnabled = YES;
        CBWeakSelf
        UITapGestureRecognizer* tap = [UITapGestureRecognizer initTapGestureWithActionBlock:^(UITapGestureRecognizer * _Nonnull gesture) {
            CBStrongSelf
            if(self.tapHeaderImageBlock){
                self.tapHeaderImageBlock();
            }
        }];
        [_mHeaderIV addGestureRecognizer:tap];
    }
    return _mHeaderIV;
}

-(UILabel *)mNicknameLbl {
    if (!_mNicknameLbl) {
        _mNicknameLbl = [[UILabel alloc] init];
//        _mNicknameLbl.textColor = THE_LINE_COLOR;
        _mNicknameLbl.font = [UIFont boldSystemFontOfSize:15];
    }
    return _mNicknameLbl;
}

-(UILabel *)mTimeLbl {
    if (!_mTimeLbl) {
        _mTimeLbl = [[UILabel alloc] init];
        _mTimeLbl.textColor = THE_LINE_COLOR;
        _mTimeLbl.font = [UIFont systemFontOfSize:13];
    }
    return _mTimeLbl;
}

- (UILabel *)mContentLbl {
    if (!_mContentLbl) {
        _mContentLbl = [[UILabel alloc] init];
//        _mContentLbl.textColor = THE_LINE_COLOR;
        _mContentLbl.font = [UIFont systemFontOfSize:15];
        _mContentLbl.preferredMaxLayoutWidth = JX_SCREEN_WIDTH-15*2;
        _mContentLbl.numberOfLines = 0;
        _mContentLbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _mContentLbl;
}

-(UICollectionViewFlowLayout *)mFlowLayout {
    if (!_mFlowLayout) {
        _mFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _mFlowLayout;
}

- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mFlowLayout];
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        _mCollectionView.backgroundColor = self.mContentView.backgroundColor;
        [_mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_mCollectionView registerClass:[TPengyouquanImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TPengyouquanImageCollectionViewCell class])];
        [_mCollectionView registerClass:[TPengyouquanVideoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TPengyouquanVideoCollectionViewCell class])];
    }
    return _mCollectionView;
}

-(UIButton *)mCommentNumBtn {
    if (!_mCommentNumBtn) {
        _mCommentNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mCommentNumBtn verticalLayoutWithInsetsStyle:ButtonStyleRight Spacing:-5];
        [_mCommentNumBtn setImage:[UIImage imageNamed:@"ic_pengyouquan_comment"] forState:UIControlStateNormal];
        _mCommentNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_mCommentNumBtn setTitle:@"0" forState:UIControlStateNormal];
        [_mCommentNumBtn setTitleColor:THE_LINE_COLOR forState:UIControlStateNormal];
    }
    return _mCommentNumBtn;
}

-(UIButton *)mLikeBtn {
    if (!_mLikeBtn) {
        _mLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mLikeBtn verticalLayoutWithInsetsStyle:ButtonStyleRight Spacing:-5];
        [_mLikeBtn setImage:[UIImage imageNamed:@"ic_pengyouquan_like"] forState:UIControlStateNormal];
        [_mLikeBtn setImage:[UIImage imageNamed:@"ic_pengyouquan_liked"] forState:UIControlStateSelected];
        _mLikeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_mLikeBtn setTitle:@"0" forState:UIControlStateNormal];
        [_mLikeBtn setTitle:@"0" forState:UIControlStateSelected];
        [_mLikeBtn setTitleColor:THE_LINE_COLOR forState:UIControlStateNormal];
        [_mLikeBtn setTitleColor:THE_LINE_COLOR forState:UIControlStateSelected];
    }
    return _mLikeBtn;
}

-(UIButton *)mMoreBtn {
    if (!_mMoreBtn) {
        _mMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mMoreBtn setImage:[UIImage imageNamed:@"newicon_moreMenu"] forState:UIControlStateNormal];
        [_mMoreBtn addTarget:self action:@selector(mMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mMoreBtn;
}
- (void)mMoreBtnClick{
    
    if(_editBlock){
        _editBlock(self.tag);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
