//
//  TPengyouquanListTableViewCell.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TPengyouquanListTableViewCell.h"
#import "UIButton+Enlarge.h"
#import "TPengyouquanImageCollectionViewCell.h"
#import "TPengyouquanVideoCollectionViewCell.h"
#import "UITapGestureRecognizer+TTapBlockAction.h"
#import "UILabel+Add.h"
#import "TUtils.h"
//#import "UITapGestureRecognizer+TTapBlockAction.h"

@interface TPengyouquanListTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) TPengyouquanListModel *pengyouquanListModel;
@end

@implementation TPengyouquanListTableViewCell

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

#pragma mark 设置数据
- (void)setData:(TPengyouquanListModel *)model {
    
    self.pengyouquanListModel = model;
    
    if (![TUtils isEmptyString:model.avatar]) {
        [self.mHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    }
    
    self.mNicknameLbl.text = model.nick;
    
    self.mTimeLbl.text = model.createtime;
    
    [self.mContentLbl setLineSpaceWithTotalString:model.body LineSpace:1];
    
    [self.mCommentNumBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)model.comments.count] forState:UIControlStateNormal];
    
    [self.mLikeBtn setTitle:[NSString stringWithFormat:@"%d", model.praiseNum] forState:UIControlStateNormal];
    [self.mLikeBtn setTitle:[NSString stringWithFormat:@"%d",model.praiseNum] forState:UIControlStateSelected];
    [self.mLikeBtn setSelected:model.isPraise];
    
    
    [self.mCollectionView reloadData];
    [self.mContentView layoutIfNeeded];
    [self layoutIfNeeded];
    NSLog(@"xxxxxxxxx%f", self.mFlowLayout.collectionViewContentSize.height);
    if ([model.fileType isEqualToString:@"0"]) {
        [self.mCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else if ([model.fileType isEqualToString:@"1"]) {
        [self.mCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (model.fileUrls.count % 3 == 0) {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(model.fileUrls.count/3)+10*((model.fileUrls.count/3-1)));
            } else {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(model.fileUrls.count/3+1)+10*((model.fileUrls.count/3)));
            }
            
        }];
    }else if ([model.fileType isEqualToString:@"2"]) {
        [self.mCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (model.videoUrls.count % 3 == 0) {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(model.videoUrls.count/3)+10*((model.fileUrls.count/3-1)));
            } else {
                make.height.mas_equalTo(((JX_SCREEN_WIDTH-15*2-10*2)/3-1)*(model.videoUrls.count/3+1)+10*((model.videoUrls.count/3)));
            }
            
        }];
    }
    
    
//    if ([model.fileType isEqualToString:@"2"]) {
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
}

#pragma mark uicollectionView -- delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.pengyouquanListModel.fileType isEqualToString:@"0"]) {
        return 0;
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"1"]) {
        return self.pengyouquanListModel.fileUrls.count;
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"2"]) {
       // if ([TUtils isEmptyString:self.pengyouquanListModel.videourl]) {
        if(self.pengyouquanListModel.videoUrls.count==0) {
            return 0;
        } else {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_pengyouquanListModel.fileType isEqualToString:@"0"]) {
        return CGSizeZero;
        
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"1"]) {
//        if (self.pengyouquanListModel.picList.count == 1) {
//            return CGSizeMake(150, 150);
//        } else {
            return CGSizeMake((JX_SCREEN_WIDTH-15*2-10*2)/3-1, (JX_SCREEN_WIDTH-15*2-10*2)/3-1);
//        }
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"2"]) {
       // if ([TUtils isEmptyString:self.pengyouquanListModel.videourl]) {
        if(self.pengyouquanListModel.videoUrls.count==0) {
            return CGSizeZero;
        } else {
            return CGSizeMake(150, 150);
        }
    }
    return CGSizeZero;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pengyouquanListModel.fileType isEqualToString:@"1"]) {
        // 图片
        TPengyouquanImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPengyouquanImageCollectionViewCell class]) forIndexPath:indexPath];
        [cell setData:self.pengyouquanListModel.fileUrls[indexPath.row]];
        return cell;
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"2"]) {
        // 视频
        TPengyouquanVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPengyouquanVideoCollectionViewCell class]) forIndexPath:indexPath];
        
        [cell setData:self.pengyouquanListModel];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pengyouquanListModel.fileType isEqualToString:@"1"]) {
        // 图片
        NSMutableArray *imageDatas = [NSMutableArray array];
        for (int i = 0; i < self.pengyouquanListModel.fileUrls.count; i ++) {
//            YBIBImageData *imageData = [[YBIBImageData alloc] init];
//            imageData.imageURL = [NSURL URLWithString:self.pengyouquanListModel.fileUrls[i].url];
//            [imageDatas addObject:imageData];
        }
//        YBImageBrowser *ybimageBrowser = [YBImageBrowser new];
//        ybimageBrowser.dataSourceArray = imageDatas;
//        ybimageBrowser.currentPage = indexPath.row;
//
//        [ybimageBrowser show];
    } else if ([self.pengyouquanListModel.fileType isEqualToString:@"2"]) {
        // 视频
        NSDictionary *model = self.pengyouquanListModel.videoUrls.firstObject;
        
        NSMutableArray *imageDatas = [NSMutableArray array];
//        YBIBVideoData *videoData = [YBIBVideoData new];
//        videoData.videoURL = [NSURL URLWithString:model[@"url"]];//self.pengyouquanListModel.videourl];
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
        make.left.equalTo(self.mContentView).offset(15);
        make.top.equalTo(self.mContentView).offset(15);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.mContentView addSubview:self.mNicknameLbl];
    [self.mNicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mHeaderIV.mas_right).offset(10);
        make.top.equalTo(self.mHeaderIV).offset(4);
    }];
    
    [self.mContentView addSubview:self.mMoreBtn];
    [self.mMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mNicknameLbl);
        make.width.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    [self.mContentView addSubview:self.mTimeLbl];
    [self.mTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mNicknameLbl);
        make.bottom.equalTo(self.mHeaderIV).offset(-2);
    }];
    
    [self.mContentView addSubview:self.mContentLbl];
    [self.mContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mContentView).offset(15);
        make.right.equalTo(self.mContentView).offset(-15);
        make.top.equalTo(self.mHeaderIV.mas_bottom).offset(10);
    }];
    
    [self.mContentView addSubview:self.mCollectionView];
    [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mContentView).offset(15);
        make.right.equalTo(self.mContentView).offset(-15);
        make.top.equalTo(self.mContentLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    [self.mContentView addSubview:self.mCommentNumBtn];
    [self.mCommentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.mCollectionView.mas_bottom).offset(15);
        make.bottom.equalTo(self.mContentView).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.mContentView addSubview:self.mLikeBtn];
    [self.mLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mCommentNumBtn.mas_right).offset(100);
        make.height.centerY.equalTo(self.mCommentNumBtn);
    }];
}

#pragma mark 懒加载
-(UIView *)mContentView {
    if (!_mContentView) {
        _mContentView = [[UIView alloc] init];
        _mContentView.backgroundColor = [UIColor whiteColor];
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
        _mHeaderIV.backgroundColor = [UIColor lightGrayColor];
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
        _mNicknameLbl.textColor = THEMEBACKCOLOR;
        _mNicknameLbl.font = [UIFont boldSystemFontOfSize:15];
    }
    return _mNicknameLbl;
}

-(UILabel *)mTimeLbl {
    if (!_mTimeLbl) {
        _mTimeLbl = [[UILabel alloc] init];
        _mTimeLbl.textColor = THEMEBACKCOLOR;
        _mTimeLbl.font = [UIFont systemFontOfSize:13];
    }
    return _mTimeLbl;
}

- (UILabel *)mContentLbl {
    if (!_mContentLbl) {
        _mContentLbl = [[UILabel alloc] init];
        _mContentLbl.textColor = THEMEBACKCOLOR;
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
        [_mCommentNumBtn setTitleColor:THEMEBACKCOLOR forState:UIControlStateNormal];
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
        [_mLikeBtn setTitleColor:THEMEBACKCOLOR forState:UIControlStateNormal];
        [_mLikeBtn setTitleColor:THEMEBACKCOLOR forState:UIControlStateSelected];
    }
    return _mLikeBtn;
}

- (void)setIsPraise:(BOOL)isPraise {
    _isPraise = isPraise;
    _mLikeBtn.selected = isPraise;
}

-(UIButton *)mMoreBtn {
    if (!_mMoreBtn) {
        _mMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mMoreBtn setImage:[UIImage imageNamed:@"ic_pengyouquan_more"] forState:UIControlStateNormal];
    }
    return _mMoreBtn;
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
