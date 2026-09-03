//
//  WH_NewGroupView.m
//  Tigase
//
//  Created by os on 2024/1/30.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_NewGroupView.h"

@interface WH_NewGroupView()

@property (weak, nonatomic) UILabel *detailLabel;//数据源

@property (weak, nonatomic) UITextField *search_tf;//数据源
@property (weak, nonatomic) UITextField *number_tf;//数据源

@end
@implementation WH_NewGroupView

-(void)setNumberStr:(int)numberStr{
    _numberStr  = numberStr;
    
    _number_tf.placeholder = [NSString stringWithFormat:@"群最大人数 %d人",_numberStr];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
           UIView *topView  = [UIView.alloc init];
        topView.layer.cornerRadius= 5;
        topView.layer.masksToBounds =YES;
            topView.userInteractionEnabled = YES;
            topView.backgroundColor = [UIColor whiteColor];//
            [self addSubview:topView];
          [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(100);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(250);
        }];
      
            
            UILabel *detailLabel = [UILabel.alloc init];
            detailLabel.font = [UIFont systemFontOfSize:14];
            detailLabel.text = @"创建群组";
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.textColor = HEXCOLOR(0x9C9C9C);
            [topView addSubview:detailLabel];
            _detailLabel = detailLabel;
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(20);
            }];
            
        {   UITextField *search_tf = [UITextField.alloc initWithFrame:CGRectMake(5, 75, JX_SCREEN_WIDTH-10, 44)];
            search_tf.layer.cornerRadius= 5;
            search_tf.layer.masksToBounds =YES;
            search_tf.layer.borderWidth = 2;
            search_tf.layer.backgroundColor= THE_LINE_COLOR.CGColor;
            search_tf.placeholder = @"群名称";
            search_tf.backgroundColor = [UIColor whiteColor];
            [topView addSubview:search_tf];
            _search_tf = search_tf;
            [_search_tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(detailLabel.mas_bottom).mas_offset(20);
            }];
            
            [search_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar"]];
            UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 7, 10, 30)];
            imageView.center = leftView.center;
            [leftView addSubview:imageView];
            search_tf.leftView = leftView;
            search_tf.leftViewMode = UITextFieldViewModeAlways;
            search_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            search_tf.leftView = leftView;
            
        }
        {
            UITextField *number_tf = [UITextField.alloc initWithFrame:CGRectMake(5, 75, JX_SCREEN_WIDTH-10, 44)];
            number_tf.layer.cornerRadius= 5;
            number_tf.layer.masksToBounds =YES;
            number_tf.layer.borderWidth = 2;
            number_tf.layer.backgroundColor= THE_LINE_COLOR.CGColor;
            number_tf.placeholder = [NSString stringWithFormat:@"群最大人数 %d人",_numberStr];
            number_tf.keyboardType = UIKeyboardTypePhonePad;
            number_tf.backgroundColor = [UIColor whiteColor];
            [topView addSubview:number_tf];
            [number_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            _number_tf = number_tf;
            [_number_tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(_search_tf.mas_bottom).mas_offset(8);
            }];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar"]];
            UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 7, 10, 30)];
            imageView.center = leftView.center;
            [leftView addSubview:imageView];
            number_tf.leftView = leftView;
            number_tf.leftViewMode = UITextFieldViewModeAlways;
            number_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            number_tf.leftView = leftView;
             
        
        }
        
        
        UIButton *cancel_btn = [UIButton.alloc init];
        [cancel_btn setTitle:@"取消" forState:UIControlStateNormal]; ;
        [cancel_btn setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal]; ;
        cancel_btn.layer.cornerRadius= 5;
        cancel_btn.layer.masksToBounds =YES;
        cancel_btn.layer.borderWidth = 1;
        cancel_btn.tag = 0;
        [topView addSubview:cancel_btn];
        [cancel_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo((JX_SCREEN_WIDTH-140)/2);
            make.bottom.mas_equalTo(-15);
        }];
        [cancel_btn addTarget:self action:@selector(cancelSureClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sure_btn = [UIButton.alloc init];
        [sure_btn setTitle:@"确定" forState:UIControlStateNormal]; ;
        sure_btn.layer.cornerRadius= 5;
        sure_btn.backgroundColor= HEXCOLOR(0xFFAD69);
        sure_btn.layer.masksToBounds =YES;
        sure_btn.tag = 1;
        [topView addSubview:sure_btn];
        [sure_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo((JX_SCREEN_WIDTH-140)/2);
            make.bottom.mas_equalTo(-15);
        }];
        
        [sure_btn addTarget:self action:@selector(cancelSureClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)cancelSureClick:(UIButton *)sender{
  
  
    if(sender.tag ==0){
        
        [self removeFromSuperview];
    }else{
        if(_search_tf.text.length==0){
            
            [g_server showMsg:@"请输入群名称"];
            return;
        }
        if(_number_tf.text.length==0){
            
            [g_server showMsg:@"请输入建群人数"];
            return;
        }
        if(_groupblcok){
            _groupblcok(_search_tf.text,_number_tf.text);
        }
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}
- (void)textFieldDidChange:(UITextField *)textfile{
    
    if([textfile.text intValue]>_numberStr){
        textfile.text = [NSString stringWithFormat:@"%d",_numberStr];
        [g_server showMsg:@"超过最大建群人数"];
    }
    
}
@end
