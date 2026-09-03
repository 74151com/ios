//
//  AAShen_RoomInputPwdVc.m
//  shiku_im
//
//  Created by hellkit on 2023/3/15.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "AAShen_RoomInputPwdVc.h"

@interface AAShen_RoomInputPwdVc ()<UITextFieldDelegate>
{
    UITextField* _pwd;
    UITextField* _phone;
    UIButton* _send;
    
}
@end

@implementation AAShen_RoomInputPwdVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.heightHeader = JX_SCREEN_TOP;
//    self.heightFooter = 0;
//    self.isGotoBack   = NO;
//    self.title = @"";
////    self.tableBody.frame = CGRectZero;
//    [self createHeadAndFoot];
    //密码
    _pwd = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, JX_SCREEN_WIDTH-50*2, 56)];
    _pwd.delegate = self;
//    _pwd.font = g_factory.font16;
    _pwd.autocorrectionType = UITextAutocorrectionTypeNo;
    _pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _pwd.enablesReturnKeyAutomatically = YES;
//        _pwd.borderStyle = UITextBorderStyleRoundedRect;
    _pwd.returnKeyType = UIReturnKeyDone;
    _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入编辑内容" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _pwd.secureTextEntry = YES;
    _pwd.userInteractionEnabled = YES;
    
    [self.view addSubview:_pwd];
    
    _send = [UIButton buttonWithType:0];
    [_send setTitle:@"确认" forState:0];
    [_send setTitleColor:[UIColor whiteColor] forState:0];
    _send.titleLabel.font = [UIFont systemFontOfSize:14];
    _send.frame = CGRectMake(50, CGRectGetMaxY(_pwd.frame)+30, JX_SCREEN_WIDTH-50*2, 44);
    [_send addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    _send.backgroundColor = HEXCOLOR(0x3F94F7);
    _send.layer.masksToBounds = YES;
    _send.layer.cornerRadius = _send.frame.size.height/2;
    [self.view addSubview:_send];
 
}
- (void)sendSMS{
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
