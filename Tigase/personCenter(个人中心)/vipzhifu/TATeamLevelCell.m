//
//  TATeamLevelCell.m
//  tio-chat-ios
//
//  Created by os on 2023/8/31.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TATeamLevelCell.h"
#import "UIView+LK.h"

@interface TATeamLevelCell ()
@property (nonatomic,   strong) UIImageView *iconImgv;
@property (nonatomic,   strong) UILabel *detailLabel;
@property (nonatomic,   strong) UILabel *priceLabel;
@end

@implementation TATeamLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
         
        UIImageView *iconImgv  = [UIImageView.alloc init];
        iconImgv.image = [UIImage imageNamed:@"start_video"];
        iconImgv.layer.cornerRadius= 5;
        iconImgv.layer.masksToBounds =YES;
        iconImgv.userInteractionEnabled = YES;
        [self.contentView addSubview:iconImgv];
        self.iconImgv = iconImgv;
        [iconImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
        [iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        UILabel *detailLabel = [UILabel.alloc init];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.text = @"kitty ";
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImgv.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        UILabel *priceLabel = [UILabel.alloc init];
        priceLabel.text = @"0.11 ¥";
        priceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}
//1ae018722f3b29bda354c342190219ecbae6a122
- (void)tapClick{
    
    if(_iconImgBlock){
        _iconImgBlock(@"");
    }
    
}
 
-(void)setUserData:(NSDictionary *)userData{
    _userData = userData;
    
    
   [g_server WH_getHeadImageSmallWIthUserId:[userData objectForKey:@"userId"] userName:[userData objectForKey:@"username"] imageView:_iconImgv];
  // [_iconImgv tio_imageUrl:user.avatar placeHolderImageName:user.nick radius:1];

    if([userData.allKeys containsObject:@"score"]){
        _priceLabel.text = [NSString stringWithFormat:@"%@",[userData objectForKey:@"score"]];
    }else{
        _priceLabel.text = @"¥0";
    }
    [self.detailLabel setText:[userData objectForKey:@"nickname"]];
}
-(void)setUser:(WH_JXUserObject *)user{
     
    _user = user;
     
    [g_server WH_getHeadImageSmallWIthUserId:user.userId userName:user.userNickname imageView:_iconImgv];
   // [_iconImgv tio_imageUrl:user.avatar placeHolderImageName:user.nick radius:1];
     
     [self.detailLabel setText:user.userNickname];
}
- (void)setDetailText:(NSString *)detailText
{
    [self.detailLabel setText:detailText];
    [self.detailLabel sizeToFit];
}

@end

