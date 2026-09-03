//
//  TMineVipCell.m
//  tio-chat-ios
//
//  Created by os on 2023/11/28.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TMineVipCell.h"

@interface TMineVipCell()
@property (weak, nonatomic) IBOutlet UILabel *toolLabel;

@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@end

@implementation TMineVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor =RGB(249, 245, 237);// [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIndexPathRow:(NSInteger)indexPathRow{
    _indexPathRow = indexPathRow;
    if(indexPathRow==0){
        self.contentView.backgroundColor =RGB(56, 52, 56);
        _toolLabel.textColor = [UIColor redColor];
        _normalLabel.textColor = [UIColor redColor];;
        _vipLabel.textColor= [UIColor redColor];;
        
    }else{
        self.contentView.backgroundColor =RGB(249, 245, 237);
        _toolLabel.textColor = RGB(51, 51, 51);
        _normalLabel.textColor = RGB(51, 51, 51);
        _vipLabel.textColor= RGB(51, 51, 51);
    }
}
-(void)setDataDict:(NSDictionary *)dataDict{
    
    _dataDict = dataDict;
    
    
    _toolLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"function"]];
    _normalLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"normal"]];
    
    NSString *vipText = [dataDict objectForKey:@"vip"];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];

    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"hvip"]; ;
    attch.bounds = CGRectMake(0,  -3.5, 16, 16); //这个-2.5是为了调整下标签跟文字的位置
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    NSAttributedString *stringxtTe = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",vipText]];
    [attri appendAttributedString:stringxtTe];
    
    if(_indexPathRow==0){
      //  _vipLabel.text = [NSString stringWithFormat:@" %@",[dataDict objectForKey:@"vip"]];
        _vipLabel.attributedText = attri;
    }else{
        _vipLabel.text = [NSString stringWithFormat:@" %@",[dataDict objectForKey:@"vip"]];
    }
 
}
@end
