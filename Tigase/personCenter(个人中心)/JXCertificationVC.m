//
//  JXCertificationVC.m
//  shiku_im
//
//  Created by IMAC on 2020/3/23.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "JXCertificationVC.h"
#import "ImageResize.h"
#import "WH_JXActionSheet_WHVC.h"
 
#import "WH_JXCamera_WHVC.h"
//#import "JXTelAreaListVC.h"
#define HEIGHT 56
#define LINE_WH 1

@interface JXCertificationVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WH_JXActionSheet_WHVCDelegate,WH_JXCamera_WHVCDelegate,UIAlertViewDelegate>
{
    NSString* _faceCardImage;
    NSString* _reverseCardImage;
    BOOL isFaceCard;
    UIButton *_areaCodeBtn;
}
@property(nonatomic, strong) UITextField *name;
@property(nonatomic, strong) UITextField *idCard;
@property(nonatomic, strong) UITextField *phone;
@property(nonatomic, strong) WH_JXImageView *faceCardImgView;
@property(nonatomic, strong) WH_JXImageView *reverseCardImgView;
@end

@implementation JXCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack = YES;
    [self createHeadAndFoot];
    
    self.title = @"实名认证";
#ifdef IS_Adapt_NightMode
    self.wh_tableBody.backgroundColor = JX_LightColorF2F2F2;
#else
    self.wh_tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
#endif
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, JX_SCREEN_WIDTH, HEIGHT*3 + 40)];
#ifdef IS_Adapt_NightMode
    baseView.backgroundColor = JX_LightColorWhite;
#else
    baseView.backgroundColor = [UIColor whiteColor];
#endif
    [self.wh_tableBody addSubview:baseView];
    
    
    int h = 12;
    WH_JXImageView* iv;
    
    iv = [self createButton:@"姓名" drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, JX_SCREEN_WIDTH, HEIGHT);
    _name = [self createTextField:iv default:nil hint:@"请输入您的姓名"];
    h+=iv.frame.size.height;
    [_name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_name];
    
    
    iv = [self createButton:@"身份证" drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, JX_SCREEN_WIDTH, HEIGHT);
    _idCard = [self createTextField:iv default:nil hint:@"请输入您的身份证号"];
    _idCard.keyboardType = UIKeyboardTypeNumberPad;
    h+=iv.frame.size.height;
    
    //    iv = [self createPhoneButton:Localized(@"JX_MobilePhoneNo.") drawTop:NO drawBottom:YES must:NO click:nil];
    //    iv.frame = CGRectMake(0, h, JX_SCREEN_WIDTH, HEIGHT);
    //
    //    NSString *areaStr;
    //    if (![g_default objectForKey:kMY_USER_AREACODE]) {
    //        areaStr = @"+86";
    //    } else {
    //        areaStr = [NSString stringWithFormat:@"+%@",[g_default objectForKey:kMY_USER_AREACODE]];
    //    }
    //    _areaCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, HEIGHT/2-11, HEIGHT-5, 22)];
    //    [_areaCodeBtn setTitle:areaStr forState:UIControlStateNormal];
    //    _areaCodeBtn.titleLabel.font = SYSFONT(16);
    //#ifdef IS_Adapt_NightMode
    //    [_areaCodeBtn setTitleColor:JX_LightTextColorBlack forState:UIControlStateNormal];
    //#else
    //    [_areaCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //#endif
    ////            [_areaCodeBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    //    _areaCodeBtn.custom_acceptEventInterval = 1.0f;
    //    [_areaCodeBtn addTarget:self action:@selector(areaCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self resetBtnEdgeInsets:_areaCodeBtn];
    //    [iv addSubview:_areaCodeBtn];
    //
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(HEIGHT-5+20, HEIGHT/2-11, LINE_WH, 22)];
    //    lineView.backgroundColor = THE_LINE_COLOR;
    //    [iv addSubview:lineView];
    //
    //    _phone = [self createPhoneTextField:iv default:nil hint:Localized(@"JX_InputPhone")];
    //    _phone.keyboardType = UIKeyboardTypeNumberPad;
    //    h+=iv.frame.size.height;
    
    //    iv = [self createButton:Localized(@"JX_IDCard") drawTop:NO drawBottom:NO must:NO click:nil];
    //    iv.frame = CGRectMake(0, h, JX_SCREEN_WIDTH, HEIGHT);
    //
    //    h+=iv.frame.size.height;
    
    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, h, JX_SCREEN_WIDTH, 260)];
#ifdef IS_Adapt_NightMode
    imageBgView.backgroundColor = [UIColor blackColor];;
#else
    imageBgView.backgroundColor = [UIColor whiteColor];
#endif
    _faceCardImgView = [[WH_JXImageView alloc]initWithFrame:CGRectMake(15, 10, JX_SCREEN_WIDTH-30,(JX_SCREEN_WIDTH-30)/490*284-10)];
    _faceCardImgView.layer.cornerRadius = 10;
    _faceCardImgView.layer.masksToBounds = YES;
    _faceCardImgView.didTouch = @selector(facePickImage);
    _faceCardImgView.wh_delegate = self;
    _faceCardImgView.backgroundColor = [UIColor redColor];
    _faceCardImgView.image = [UIImage imageNamed:@"img_face_card"];
    
    [imageBgView addSubview:_faceCardImgView];
    
    _reverseCardImgView = [[WH_JXImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_faceCardImgView.frame)+10, JX_SCREEN_WIDTH-30, (JX_SCREEN_WIDTH-30)/490*284-10)];
    _reverseCardImgView.layer.cornerRadius = 10;
    _reverseCardImgView.layer.masksToBounds = YES;
    _reverseCardImgView.image = [UIImage imageNamed:@"img_reverse_card"];
    _reverseCardImgView.didTouch = @selector(reversePickImage);
    _reverseCardImgView.wh_delegate = self;
    _reverseCardImgView.backgroundColor = [UIColor redColor];
    [imageBgView addSubview:_reverseCardImgView];
    CGRect imageBgViewFrame =imageBgView.frame;
    imageBgViewFrame.size.height = CGRectGetMaxY(_reverseCardImgView.frame)+30;
    imageBgView.frame =imageBgViewFrame;
    h+=imageBgView.frame.size.height;
    [self.wh_tableBody addSubview:imageBgView];
    
    
    
    
    UIButton *btn = [UIFactory WH_create_WHCommonButton:@"提交" target:self action:@selector(openCommit)];
    btn.custom_acceptEventInterval = 1.f;
    btn.frame = CGRectMake(15,h + 28, JX_SCREEN_WIDTH-30, 40);
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    btn.backgroundColor = THEMECOLOR;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 7.f;
    [self.wh_tableBody addSubview:btn];
    
    UIView *placeHoldBgView = [[UIView alloc] initWithFrame:CGRectMake(0,h + 28+40, JX_SCREEN_WIDTH, 80)];
    [self.wh_tableBody addSubview:placeHoldBgView];
    self.wh_tableBody.contentSize = CGSizeMake(self_width, h + 28+40+80);
    
}
//在监听中，过滤非中文字符，并且限制中文字符长度
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    //过滤非汉字字符
    _name.text = [self filterCharactor:_name.text withRegex:@"[^\u4e00-\u9fa5]"];
    
    if (_name.text.length >= 10) {
        _name.text = [_name.text substringToIndex:10];
    }
    return NO;
}

- (void)textFiledEditChanged:(id)notification{
    
     
    UITextRange *selectedRange = _name.markedTextRange;
    UITextPosition *position = [_name positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        //过滤非汉字字符
//        companyNameTF.text = [self filterCharactor:self.companyNameTF.text withRegex:@"[^\u4e00-\u9fa5]"];
        _name.text = [self filterCharactor:_name.text withRegex:@"[^\u4e00-\u9fa5]"];
        
        if (_name.text.length >= 14) {
            _name.text = [_name.text substringToIndex:4];
        }
    }else { //有高亮文字
        //do nothing
    }
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
- (void)openCommit{
    NSString *idCardStr =self.idCard.text;
    NSString *nameStr =self.name.text;
//    NSString *phoneStr = self.phone.text;
    if(!nameStr || nameStr.length<=0){
        [JXMyTools showTipView:@"请输入你的姓名"];
        return;
    }
    if(!idCardStr || idCardStr.length<=0){
        [JXMyTools showTipView:@"请输入你的省份证号"];
        return;
    }
//    if(!phoneStr || phoneStr.length<=0){
//        [JXMyTools showTipView:Localized(@"JX_InputPhone")];
//        return;
//    }
    if(!_faceCardImage || _faceCardImage.length<=0){
        [JXMyTools showTipView:Localized(@"JX_PlaceUploadFaceCardImage")];
        return;
    }
    if(!_reverseCardImage || _reverseCardImage.length<=0){
        [JXMyTools showTipView:Localized(@"JX_PlaceUploadBackCardImage")];
        return;
    }
    [g_server realNameCertifiedWithIDCard:idCardStr withRealName:nameStr phone:@"" frontImageUrl:_faceCardImage backImageUrl:_reverseCardImage toView:self];
}
-(WH_JXImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click{
    WH_JXImageView* btn = [[WH_JXImageView alloc] init];
#ifdef IS_Adapt_NightMode
    btn.backgroundColor = [UIColor blackColor];;
#else
    btn.backgroundColor = [UIColor whiteColor];
#endif
    btn.userInteractionEnabled = YES;
    btn.wh_delegate = self;
    if(click)
        btn.didTouch = click;
    [self.wh_tableBody addSubview:btn];
    
    if(must){
        UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, 5, 20, HEIGHT-5)];
        p.text = @"*";
        p.font = g_factory.font18;
        p.backgroundColor = [UIColor clearColor];
        p.textColor = [UIColor redColor];
        p.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:p];
    }
    
    JXLabel* p = [[JXLabel alloc] initWithFrame:CGRectMake(20, 0, JX_SCREEN_WIDTH/2-40, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
#ifdef IS_Adapt_NightMode
    p.textColor = [UIColor whiteColor ];
#else
    p.textColor = [UIColor blackColor];
#endif
    [btn addSubview:p];
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-LINE_WH,JX_SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}

-(WH_JXImageView *)createPhoneButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click{
    WH_JXImageView* btn = [[WH_JXImageView alloc] init];
#ifdef IS_Adapt_NightMode
    btn.backgroundColor = [UIColor blackColor];
#else
    btn.backgroundColor = [UIColor whiteColor];
#endif
    btn.userInteractionEnabled = YES;
    btn.wh_delegate = self;
    if(click)
        btn.didTouch = click;
    [self.wh_tableBody addSubview:btn];
     
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-LINE_WH,JX_SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}

-(UITextField*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH/2-50,INSETS,JX_SCREEN_WIDTH/2-15+50,HEIGHT-INSETS*2)];
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeWhileEditing;
    p.textAlignment = NSTextAlignmentRight;
    p.userInteractionEnabled = YES;
    p.text = s;
    p.placeholder = hint;
    p.font = g_factory.font16;
    [parent addSubview:p];
    
    return p;
}

-(UITextField*)createPhoneTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(HEIGHT-5+40,INSETS,JX_SCREEN_WIDTH-(HEIGHT-5)-60,HEIGHT-INSETS*2)];
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeWhileEditing;
    p.textAlignment = NSTextAlignmentLeft;
    p.userInteractionEnabled = YES;
    p.text = s;
    p.placeholder = hint;
    p.font = g_factory.font16;
    [parent addSubview:p];
    
    return p;
}


#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
      
    if ([aDownload.action isEqualToString:act_RealNameCertified_New]) {
        [JXMyTools showTipView:@"已提交实名认证"];
        if (self.certificeSuccess) {
            self.certificeSuccess();
        }
        [self actionQuit];
    }
    
    if([aDownload.action isEqualToString:wh_act_UploadFile]){
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"images"]];
        if (array.count > 0) {
            NSDictionary *imgDic = array[0];
            NSString *str = [imgDic objectForKey:@"oFileName"];
            NSString *imgUrl = [imgDic objectForKey:@"oUrl"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if([str isEqualToString:@"faceCard.jpg"]){
                _faceCardImage = imgUrl;
                _faceCardImgView.image = image;
            }else{
                _reverseCardImage = imgUrl;
                _reverseCardImgView.image = image;
            }
        }
        
        
    }
    
}

 

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_RealNameCertified_New]) {
        if([[dict objectForKey:@"resultCode"] intValue] == 100444){
    
            [g_App showAlert:Localized(@"JX_RealNameAuthenticationReview")];
            return WH_hide_error;
        }
        if([[dict objectForKey:@"resultCode"] intValue] == 100435  ){
            [g_App showAlert:Localized(@"JX_HasBeenAuthenticationRealName")];
            return WH_show_error;
        }
           
    }
    
    return WH_show_error;
}
#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    
    return WH_show_error;
}

 
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
 

-(void) didServerConnectStart:(WH_JXConnection *)aDownload{
    [_wait start];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage * image = [ImageResize image: fillSize:CGSizeMake(640, 640)];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

    [self uploadCardImage:image isFace:isFaceCard];
    [picker dismissViewControllerAnimated:YES completion:nil];
  
}


-(void)hideKeyboard{
    
    [self.view endEditing:YES];

}

- (void)facePickImage
{
    [self hideKeyboard];
    isFaceCard = true;
    WH_JXActionSheet_WHVC *actionVC = [[WH_JXActionSheet_WHVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
}
-(void)reversePickImage{
    [self hideKeyboard];
    isFaceCard = false;
    WH_JXActionSheet_WHVC *actionVC = [[WH_JXActionSheet_WHVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)actionSheet:(WH_JXActionSheet_WHVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        //选择图片模式
        ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
        //    [g_window addSubview:ipc.view];
        if (IS_PAD) {
            UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
            [pop presentPopoverFromRect:CGRectMake((self.view.frame.size.width - 320) / 2, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
        
    }else {
        WH_JXCamera_WHVC *vc = [WH_JXCamera_WHVC alloc];
        vc.cameraDelegate = self;
        vc.isPhoto = YES;
        vc = [vc init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)cameraVC:(WH_JXCamera_WHVC *)vc didFinishWithImage:(UIImage *)image {
//    UIImage * fimage = [ImageResize image:image fillSize:CGSizeMake(640, 640)];
    //    [_image retain];

    [self uploadCardImage:image isFace:isFaceCard];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)areaCodeBtnClick:(UIButton *)but{
    [self.view endEditing:YES];
//    JXTelAreaListVC *telAreaListVC = [[JXTelAreaListVC alloc] init];
//    telAreaListVC.telAreaDelegate = self;
//    telAreaListVC.didSelect = @selector(didSelectTelArea:);
////    [g_window addSubview:telAreaListVC.view];
//    [g_navigation pushViewController:telAreaListVC animated:YES];
}
- (void)didSelectTelArea:(NSString *)areaCode{
    [_areaCodeBtn setTitle:[NSString stringWithFormat:@"+%@",areaCode] forState:UIControlStateNormal];
    [self resetBtnEdgeInsets:_areaCodeBtn];
}
- (void)resetBtnEdgeInsets:(UIButton *)btn{
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.frame.size.width-2, 0, btn.imageView.frame.size.width+2)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width+2, 0, -btn.titleLabel.frame.size.width-2)];
}

-(void)uploadCardImage:(UIImage *)image isFace:(BOOL)isFace{
    
    [g_server uploadFileData:UIImageJPEGRepresentation(image, 0.5) key:isFace?@"faceCard.jpg":@"reverseCard.jpg" toView:self];
}


@end
