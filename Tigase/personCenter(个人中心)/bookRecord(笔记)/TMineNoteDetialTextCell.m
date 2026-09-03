//
//  TMineNoteDetialTextCell.m
//  Tigase
//
//  Created by os on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "TMineNoteDetialTextCell.h"
#import "UILabel+Add.h"
#import "TUtils.h"

@interface TMineNoteDetialTextCell ()
 
@property (nonatomic, strong) UILabel *mNicknameLbl;
@property (nonatomic, strong) UILabel *mTimeLbl;
@property (nonatomic, strong) UILabel *mContentLbl;
@end
@implementation TMineNoteDetialTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _mNicknameLbl = [[UILabel alloc] init];
    //        _mContentLbl.textColor = THE_LINE_COLOR;
        _mNicknameLbl.font = [UIFont systemFontOfSize:15];
        _mNicknameLbl.preferredMaxLayoutWidth = JX_SCREEN_WIDTH-15*2;
        _mNicknameLbl.numberOfLines = 0;
        _mNicknameLbl.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:_mNicknameLbl];
        [_mNicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-10);
        }];
        
        _mContentLbl = [[UILabel alloc] init];
    //        _mContentLbl.textColor = THE_LINE_COLOR;
        _mContentLbl.font = [UIFont systemFontOfSize:15];
        _mContentLbl.preferredMaxLayoutWidth = JX_SCREEN_WIDTH-15*2;
        _mContentLbl.numberOfLines = 0;
        _mContentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:_mContentLbl];
        [_mContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_mNicknameLbl.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
        
        
    }
    return self;
}
  
- (void)setData:(NSString *)titleStr contentStr:(NSString *)contentStr{
    
    _mNicknameLbl.text = titleStr;
   // _mContentLbl.text = contentStr;
    NSString *totalStr = [TUtils isEmptyString:contentStr]?@"":contentStr;
    totalStr = [totalStr stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
    _mContentLbl.attributedText = attributedStr;
}
#pragma mark 设置数据
- (void)setData:(NSDictionary *)model {
     
    
}
@end
