//
//  JXTopVipCell.m
//  Tigase
//
//  Created by os on 2024/2/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "JXTopVipCellView.h"

@interface JXTopVipCellView()

@property (weak, nonatomic) UILabel *detailLabel;//数据源

@property (weak, nonatomic) UILabel *tipLabel;//数据源
@property (weak, nonatomic) UIButton *goButton;//数据源
@property (weak, nonatomic) UILabel *exipreLabel;//数据源

@property (weak, nonatomic) UIButton *sure_btn;
@property (weak, nonatomic) UIImageView *topView;
@end
@implementation JXTopVipCellView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
       // self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backgroundColor = THE_LINE_COLOR;
        UIImageView *topView  = [UIImageView.alloc init];
        topView.userInteractionEnabled = YES;
        topView.contentMode = UIViewContentModeScaleToFill;
         topView.backgroundColor = RGB(232, 232, 232);
        topView.image = [UIImage imageNamed:@"密达VIP"];
        
        topView.userInteractionEnabled = YES;
        [self addSubview:topView];
        topView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
        _topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipVipClick)]];
        
        UILabel *detailLabel = [UILabel.alloc init];
        detailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        detailLabel.text = @"";
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor whiteColor];//HEXCOLOR(0x9C9C9C);
        [topView addSubview:detailLabel];
       // detailLabel.hidden = YES;
        _detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.centerX.mas_equalTo(topView.mas_centerX);
           // make.left.mas_equalTo(115);
        }];
        UILabel *tipLabel = [UILabel.alloc init];
        tipLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor whiteColor];
        [topView addSubview:tipLabel];
        tipLabel.hidden = YES;
        _tipLabel = detailLabel;
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.left.mas_equalTo(120);
        }];
        
//        UILabel *exipreLabel = [UILabel.alloc init];
//        exipreLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
//        exipreLabel.textAlignment = NSTextAlignmentCenter;
//        exipreLabel.textColor = [UIColor blackColor];
//        [topView addSubview:exipreLabel];
//        _tipLabel = exipreLabel;
//        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(topView.mas_centerY);
//            make.right.mas_equalTo(-135);
//        }];
          
        UIButton *sure_btn = [UIButton.alloc init];
        
         if([g_myself.vip intValue]>0){
             [sure_btn setTitle:@"查看详情" forState:UIControlStateNormal]; ;
           // tipLabel.text = @"💎已开通vip ";
         }else{
             [sure_btn setTitle:@"立即开通" forState:UIControlStateNormal]; ;
            //tipLabel.text = @"💎暂未开通vip ";
         }
        sure_btn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        sure_btn.layer.cornerRadius= 15;
        sure_btn.backgroundColor= RGB(233, 221, 179);//HEXCOLOR(0xFFAD69);
//        sure_btn.layer.borderColor = [UIColor blackColor].CGColor;
        [sure_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        sure_btn.layer.borderWidth =1;
        sure_btn.layer.masksToBounds =YES;
        sure_btn.tag = 1;
        [topView addSubview:sure_btn];
        _sure_btn =  sure_btn;
        
        [sure_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-11);
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
        [sure_btn addTarget:self action:@selector(tipVipClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setVipOpen:(int)vipOpen{
    if(vipOpen>0){
       [_sure_btn setTitle:@"查看详情" forState:UIControlStateNormal]; ;
        _topView.backgroundColor = [UIColor yellowColor];
        
        
    }else{
        
         [_sure_btn setTitle:@"立即开通" forState:UIControlStateNormal]; ;
    
        _topView.backgroundColor = THE_LINE_COLOR;
    }
}
- (void)setUserData:(NSDictionary *)userData{
    _userData = userData;
    NSString *exipreTime = [NSString stringWithFormat:@"%@",[userData objectForKey:@"endTime"]];
    if([exipreTime isKindOfClass:[NSNull class]]||[exipreTime containsString:@"null"]){
        _tipLabel.text = @"";
        _topView.image = [UIImage imageNamed:@"暂未开通"];
    }else{
        _topView.image = [UIImage imageNamed:@"密达VIP"];
       _tipLabel.text = [NSString stringWithFormat:@"%@过期",[self getDateStringWithTimeStr:exipreTime]];
    }
}
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


- (void)tipVipClick{
   
   // [g_server showMsg:@"请输入群名称"];
    if(_vipblcok){
        _vipblcok(@"",@"");
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}
- (void)textFieldDidChange:(UITextField *)textfile{
    
    
}
@end
