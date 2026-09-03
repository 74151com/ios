//
//  AAShen_RoomInputPwdView.m
//  shiku_im
//
//  Created by hellkit on 2023/3/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "AAShen_RoomInputPwdView.h"

@interface AAShen_RoomInputPwdView()
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
@implementation AAShen_RoomInputPwdView

- (IBAction)closebtn:(id)sender {
    
    [self removeFromSuperview];
}
+(instancetype)XIBAAShen_RoomInputPwdView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"AAShen_RoomInputPwdView" owner:self options:nil].firstObject;
}
- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.masksToBounds = 4;
    
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.masksToBounds = 4;
    
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keybordHidden)]];
    
}
- (void)keybordHidden{
    
    [_tf_pwd resignFirstResponder];
}
- (void)sureBtnClick{
    
    if(_tf_pwd.text.length==0){
        
        [g_App showAlert:@"请输入密码"];
        return;
    }
    if(_blockpw){
        
        _blockpw(_tf_pwd.text);
    }
}
@end
