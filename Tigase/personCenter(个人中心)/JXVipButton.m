//
//  JXVipButton.m
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "JXVipButton.h"
#import "UIImage+WH_Tint.h"

#import "UIImage+WH_Color.h"

@interface JXVipButton()

@property (nonatomic,weak) UILabel * leftLabel;
@property (nonatomic,weak) UILabel * btLabel;
@property (nonatomic,weak) UILabel * teVLable;
@property (nonatomic,weak) UILabel * btRightLabel;
   
@end
@implementation JXVipButton


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
        self.layer.borderColor = RGB(235, 159, 63).CGColor;
        
        
//        -(UIImage *) imageWithTintColor:(UIColor * )tintColor;
//        -(UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
         
        [self setBackgroundImage:[UIImage createImageWithColor:RGB(255, 255, 255)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage createImageWithColor:RGB(251, 229, 196)] forState:UIControlStateSelected];
        
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 2;
        [self setUpButton];
    }
    return self;
}
- (void)setUpButton{
    
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"月费";
    leftLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self addSubview:leftLabel];
    _leftLabel = leftLabel;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12);
        
    }];
    
    
    UILabel * btLabel = [[UILabel alloc]init];
    btLabel.text = @"";
    btLabel.textColor = [UIColor grayColor];
    btLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:btLabel];
    _btLabel = btLabel;
    [btLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(leftLabel.mas_bottom).mas_offset(10);
        
    }];
    
    UILabel * teVLable = [[UILabel alloc]init];
    teVLable.text = @"特惠价:¥3000";
    teVLable.textColor = RGB(235, 159, 63);
    teVLable.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self addSubview:teVLable];
    _teVLable = teVLable;
    [teVLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        
    }];
    
    UILabel * btRightLabel = [[UILabel alloc]init];
    btRightLabel.text = @"¥3000";
    btRightLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [self addSubview:btRightLabel];
    _btRightLabel = btRightLabel;
    [btRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(teVLable.mas_bottom).mas_offset(10);
        
    }];
}


- (void)dictData:(NSDictionary *)dict{
   // {"createTime":1694969024,"id":"65072cc0ce877e57ac8ad867","level":1,"number":1,"price":100}
    
    NSLog(@"月 = %@",dict);
    _leftLabel.text = [NSString stringWithFormat:@"%@个月",dict[@"number"]];
    _teVLable.text = [NSString stringWithFormat:@"特惠价:¥%@",dict[@"price"]];
    long  createTIme  = [[dict objectForKey:@"createTime"] longLongValue];
    _btRightLabel.text = [NSString stringWithFormat:@"有效期%@",[self getTime:createTIme]];
}
// 时间戳转换时间
- (NSString *)getTime:(long )time {
    NSTimeInterval interval    = time;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*currentDateStr = [formatter stringFromDate: date];
    
    return currentDateStr;
}
@end
