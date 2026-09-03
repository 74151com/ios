//
//  JXVipButton.m
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "JXScoreButton.h"
#import "UIImage+WH_Tint.h"

#import "UIImage+WH_Color.h"
 

@interface JXScoreButton()

@property (nonatomic,weak) UILabel * leftLabel;
@property (nonatomic,weak) UILabel * btLabel;
@property (nonatomic,weak) UILabel * teVLable;
@property (nonatomic,weak) UILabel * btRightLabel;
   
@end
@implementation JXScoreButton


+ (instancetype)titleButton
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 背景
        
        //titleBtn.backgroundColor = RGB(251, 229, 196);
       // self.layer.borderColor = RGB(235, 159, 63).CGColor;
        
        
//        -(UIImage *) imageWithTintColor:(UIColor * )tintColor;
//        -(UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
         
        [self setBackgroundImage:[UIImage imageNamed:@"矩形 2"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"矩形 1"] forState:UIControlStateSelected];
        
        
        self.titleLabel.font = [UIFont systemFontOfSize:27 weight:UIFontWeightMedium];
        [self setTitleColor:RGB(249, 245, 237) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
          
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self setUpButton];
    }
    return self;
}
- (void)setUpButton{
    
    //RGB(249, 245, 237) 米白
    
    //RGB(253, 249, 232) 浅黄
    //RGB(233, 221, 179) 大黄
    
    //RGB(56, 52, 56) 黑
    
    //RGB(126, 101, 54) 月卡
    
    //RGB(247, 233, 181) 黑
    
    UILabel * introlabel = [[UILabel alloc]init];
    introlabel.text = @"推荐";
    introlabel.textColor = [UIColor whiteColor];
    introlabel.layer.cornerRadius = 4;
    introlabel.textAlignment = NSTextAlignmentCenter;
    introlabel.layer.masksToBounds = YES;
    introlabel.backgroundColor = [UIColor brownColor];
    introlabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [self addSubview:introlabel];
    _introLabel = introlabel;
    [introlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(18);
        
    }];
    
    
    UILabel * contiueLabel = [[UILabel alloc]init];
    contiueLabel.text = @"连续包月";
    contiueLabel.textColor = [UIColor brownColor];
    contiueLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    [self addSubview:contiueLabel];
    [contiueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(28);
        
    }];
    
    
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"月卡";
    leftLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightMedium];
    [self addSubview:leftLabel];
    _leftLabel = leftLabel;
    _leftLabel.hidden=YES;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contiueLabel.mas_bottom).mas_offset(2);
        
    }];
    
    
    UILabel * btRightLabel = [[UILabel alloc]init];
    btRightLabel.text = @"¥3000";
    btRightLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    btRightLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:btRightLabel];
    _btRightLabel = btRightLabel;
    [btRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(leftLabel.mas_bottom).mas_offset(8);
        
    }];
    
    UILabel * orgainPrice = [[UILabel alloc]init];
    orgainPrice.text = @"原价988";
    orgainPrice.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    orgainPrice.textColor = RGB(249, 245, 237);
    [self addSubview:orgainPrice];
    _orgainPrice = orgainPrice;
   
    [orgainPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(btRightLabel.mas_bottom).mas_offset(7);
        
    }];
    
}

-(void)setIndexBtn:(int)indexBtn{
    
    if(indexBtn==0){
        _introLabel.hidden = NO;
        _orgainPrice.hidden = YES;
    }else if(indexBtn==1){
        _orgainPrice.hidden = NO;
        _orgainPrice.text = @"原价54";
        
        _introLabel.hidden = YES;
    }else{ 
        _orgainPrice.hidden = NO;
        _orgainPrice.text = @"原价216";
        
        _introLabel.hidden = YES;
    }
}

- (void)dictData:(NSDictionary *)dict{
     
    
    NSLog(@"月 = %@",dict);
  //  _leftLabel.text = dict[@"levelName"];
    [self setTitle:dict[@"levelName"] forState:UIControlStateNormal];
    _btRightLabel.text = [NSString stringWithFormat:@"¥%@",dict[@"price"]];
//    if(self.tag==0){
//
//        _btRightLabel.text = [NSString stringWithFormat:@"¥%@",@"18"];
//
//    }else if(self.tag==1){
//
//        _btRightLabel.text = [NSString stringWithFormat:@"¥%@",@"48"];
//
//    }else{
//
//        _btRightLabel.text = [NSString stringWithFormat:@"¥%@",@"128"];
//    }
}
@end
