//
//  JXVipOpenSystemCell.m
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "JXVipOpenSystemCell.h"

@interface JXVipOpenSystemCell()
 

@property (nonatomic, weak)  UILabel* titleLabel;
@property (nonatomic, weak)  UILabel* btLabel;
@property (nonatomic, weak)  UILabel* teVLable;
@property (nonatomic, weak)  UIImageView* iconImg;

@property (nonatomic, weak)  UIButton* seletBtnImg;

@end
@implementation JXVipOpenSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.image = [UIImage imageNamed:@"payment_zhifubao"];
        [self.contentView addSubview:iconImg];
        _iconImg = iconImg;
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(42);
            
        }];
        
        
        UILabel * btLabel = [[UILabel alloc]init];
        btLabel.text = @"余额支付";
        btLabel.textColor = [UIColor grayColor];
        btLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        [self addSubview:btLabel];
        _btLabel = btLabel;
        [btLabel mas_makeConstraints:^(MASConstraintMaker *make) { 
            make.left.mas_equalTo(iconImg.mas_right).mas_offset(10);
            make.top.mas_equalTo(iconImg.mas_top).mas_offset(0);
            
        }];
        
        UILabel * teVLable = [[UILabel alloc]init];
        teVLable.text = @"亿万用户的选择,更快更安全";
        teVLable.textColor = RGB(211, 211, 211);
        teVLable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self addSubview:teVLable];
        _teVLable = teVLable;
        [teVLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImg.mas_right).mas_offset(10);
            make.bottom.mas_equalTo(iconImg.mas_bottom).mas_offset(0);
        }];
        
//        UILabel * btRightLabel = [[UILabel alloc]init];
//        btRightLabel.text = @"¥3000";
//        btRightLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
//        [self addSubview:btRightLabel];
//        _btRightLabel = btRightLabel;
//        [btRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-12);
//            make.top.mas_equalTo(teVLable.mas_bottom).mas_offset(10);
//
//        }];
        
        
        
        UIButton* seletBtnImg = [[UIButton alloc] init];
        [seletBtnImg setImage:[UIImage imageNamed:@"selected_true"] forState:UIControlStateNormal];
        [self.contentView addSubview:seletBtnImg];
        _seletBtnImg = seletBtnImg;
        [seletBtnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            
        }];
        
        //[seletBtnImg addTarget:self action:@selector(contentBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JXVipOpenSystemCell";
    JXVipOpenSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JXVipOpenSystemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setMusic:(NSDictionary *)music
{
    _music = music; 
  
}

-(void)setFrame:(CGRect)frame{
    
    frame.size.height-=1;
    frame.origin.y+=1;
    
    [super setFrame:frame];
}
@end
