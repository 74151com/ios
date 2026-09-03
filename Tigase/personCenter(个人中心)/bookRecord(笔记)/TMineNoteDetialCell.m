//
//  TMineNoteDetialCell.m
//  Tigase
//
//  Created by os on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "TMineNoteDetialCell.h"
#import "NSString+ContainStr.h"
  
#import <Photos/Photos.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UITapGestureRecognizer+TTapBlockAction.h"

#import "TPengyouquanListTableViewCell.h"
#import "UIButton+Enlarge.h"
#import "TPengyouquanImageCollectionViewCell.h"
#import "TPengyouquanVideoCollectionViewCell.h"
#import "UILabel+Add.h"
#import "TUtils.h"
 
@interface TMineNoteDetialCell () 
 
@property (nonatomic,   strong) NSDictionary *pengyouquanListModel;
@end

@implementation TMineNoteDetialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
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
        [self.contentView addSubview:_mHeaderIV];
        [self.mHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
        
        _mImgPlayIV = [[UIImageView alloc] init];
        _mImgPlayIV.image = [UIImage imageNamed:@"icon_collectionVideoPlay"];
        [self.contentView addSubview:_mImgPlayIV];
        [_mImgPlayIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_mHeaderIV.mas_centerX);
//            make.top.mas_equalTo(15);
            make.centerY.mas_equalTo(_mHeaderIV.mas_centerY);
        }];
        
    }
    return self;
}
  
#pragma mark 设置数据
- (void)setData:(NSDictionary *)model {
    
    self.pengyouquanListModel = model;
    
   NSString *imageStr = [model objectForKey:@"oUrl"];
   // 测试用途，请忽略不严谨逻辑 type 1图片 2 视频
   CGFloat padding = 5, imageViewLength = ([UIScreen mainScreen].bounds.size.width - padding * 2) / 3 - 10, scale = [UIScreen mainScreen].scale;
   CGSize imageViewSize = CGSizeMake(imageViewLength * scale, imageViewLength * scale);
      
    if ([imageStr hasSuffix:@".mp4"]) {
        _mImgPlayIV.hidden = NO;
        if([imageStr isUrl]) {//判断是否是视频链接
            [FileInfo getFirstImageFromVideo:imageStr imageView:_mHeaderIV];
        }else if (isFileExist(imageStr)){//判断是否是本地路径
            [FileInfo getFirstImageFromVideo:imageStr imageView:_mHeaderIV];
        }else {//fileName既不是有效的网路路径，也不是本地路径，只能从content中取值
            [FileInfo getFirstImageFromVideo:imageStr imageView:_mHeaderIV];
        }
    }
    else{
        _mImgPlayIV.hidden = YES;
        
        [self.mHeaderIV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
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

