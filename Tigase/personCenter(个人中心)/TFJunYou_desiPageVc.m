//
//  JXdesiPageVc.m
//  ZhouXinChat
//
//  Created by lifengye on 2021/10/24.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_desiPageVc.h"
#import "UIView+LK.h"
#import "XMGTitleButton.h"
#import "WH_AddWithdrawalAccount_WalletVc.h"
#import "WH_AddWithdrawa_BankVc.h"

@interface TFJunYou_desiPageVc ()<UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIButton *button_n;
@property (weak, nonatomic) UIView *sliderView;
@property (strong, nonatomic) MASConstraint *sliderViewCenterX;
@property (weak, nonatomic) UIButton *refreshButton;
@property (weak, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *moreBtn;

@property (strong, nonatomic) UIButton *groupBtn;
@property (strong, nonatomic) UIButton *searchBtn;

@property (strong, nonatomic) UILabel *msgNumberBtn ;
@end

@implementation TFJunYou_desiPageVc
  
- (id)init
{
    self = [super init];
    if (self) {
        
         
    }
    return self;
}
  
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     
   
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack = YES;
    self.title = @"提现";
    [self createHeadAndFoot];
    
    
    [self setupNavBar];
    
    [self setupContentView];
    
    [self setupTitlesView];
    
    [self setupChildViewControllers];
    
   
}
 
     
- (void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, JX_SCREEN_TOP, self.view.bounds.size.width, self.view.bounds.size.height-JX_SCREEN_TOP);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.bounces=NO;
     
    NSArray *lastUrl = @[@"支付宝",@"银行卡"];
    
    contentView.contentSize = CGSizeMake(contentView.xmg_width * lastUrl.count, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
  
}
 
-(void)swipeAction:(UISwipeGestureRecognizer *)sender {
 
    if (sender.direction ==UISwipeGestureRecognizerDirectionLeft) {
       
        int index =1;
        [self titleClick:self.titlesView.subviews[index]];
        [self switchController:index];
        
    }else if(sender.direction ==UISwipeGestureRecognizerDirectionRight){
        
        int index =0;
        [self titleClick:self.titlesView.subviews[index]];
        [self switchController:index];
        
    }

    
}

 
 
- (void)setupTitlesView
{
    
    UIView *backView = [[UIView alloc] init];
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backView.frame = CGRectMake(0, JX_SCREEN_TOP, self.view.frame.size.width, 40);
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled=YES;
    [self.view addSubview:backView];
  
    UIView *titlesView = [[UIView alloc] init];
    titlesView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    20 : 33
    CGFloat top = THE_DEVICE_HAVE_HEAD ? 20 : 33;
//    titlesView.frame = CGRectMake(0, (JX_SCREEN_TOP-top)/2+6, self.view.frame.size.width, 34);
    titlesView.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH/2, 40);
    titlesView.userInteractionEnabled = YES;
//    titlesView.layer.borderWidth = 1;
//    titlesView.layer.masksToBounds = YES;
//    titlesView.layer.cornerRadius = 12;
//    titlesView.layer.borderColor = RGB(59, 194, 108).CGColor;
    [backView addSubview:titlesView];
    self.titlesView = titlesView;
    
     //全部
    NSArray *lastUrl = @[@"支付宝",@"银行卡"];
    for (int i=0;i<lastUrl.count; i++) {
        XMGTitleButton *button = [[XMGTitleButton alloc]init];
        [button setTitle:lastUrl[i] forState:UIControlStateNormal];
        button.tag = i;
        [titlesView addSubview:button];
//        if (lastUrl.count == 1) {
//            button.frame = CGRectMake(0, 0, 160, 33);
//        }if (lastUrl.count == 1) {
//            button.frame = CGRectMake(0, 0, 160, 33);
//        }else{
            button.frame = CGRectMake(i*(60+20)+g_factory.globelEdgeInset, 5, 60, 30);
//        }
        if (i==0) {
            button.enabled = NO;
            _selectedButton = button;
        }
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
 

}
// 检查“登录”文本框的内容
- (void)alertTextFieldDidChange:(NSNotification *)notification{
  UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
  if (alertController) {
      UITextField *login = alertController.textFields.firstObject;
      UIAlertAction *okAction = alertController.actions.lastObject;

      // 当输入文字大于2 ,按钮可以点击
      okAction.enabled = login.text.length > 2;
  }
}
  
- (XMGTitleButton *)setupTitleButton:(NSString *)title
{
    XMGTitleButton *button = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.titlesView addSubview:button];
    self.topButton=button;
 
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.titlesView.xmg_width/2);
        make.top.mas_equalTo(JX_SCREEN_HEIGHT>=812?0:0);
        NSUInteger index = self.titlesView.subviews.count - 1;
        if (index == 0) {
            make.left.mas_equalTo(self.titlesView);
        } else {
            make.left.mas_equalTo(self.titlesView.xmg_width/2);
            
        }
    }];
     
   
    return button;
}
 
- (void)titleClick:(UIButton *)button
{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 消除约束
    [self.sliderViewCenterX uninstall];
    self.sliderViewCenterX = nil;
    
    // 添加约束
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.sliderViewCenterX = make.centerX.equalTo(button);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    
     int index = (int)[self.titlesView.subviews indexOfObject:button];
     [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
     
}

- (void)setupNavBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupChildViewControllers
{
    
    WH_AddWithdrawalAccount_WalletVc* videoVC = [WH_AddWithdrawalAccount_WalletVc alloc];
    videoVC = [videoVC init];
    
    [self addChildViewController:videoVC];
    
    
    WH_AddWithdrawa_BankVc *mainVC = [WH_AddWithdrawa_BankVc alloc];
    mainVC = [mainVC init];
    [self addChildViewController:mainVC];
     
    mainVC.view.xmg_y = 0;
    mainVC.view.xmg_width = self.contentView.xmg_width;
    mainVC.view.xmg_height = self.contentView.xmg_height;
    mainVC.view.xmg_x = mainVC.view.xmg_width * 1;
    [self.contentView addSubview:mainVC.view];
    
    
    
    videoVC.view.xmg_y = 0;
    videoVC.view.xmg_width = self.contentView.xmg_width;
    videoVC.view.xmg_height = self.contentView.xmg_height;
    videoVC.view.xmg_x = videoVC.view.xmg_width * 0;  
    [self.contentView addSubview:videoVC.view];
    
    
    
}

- (void)switchController:(int)index
{
     
    if (self.childViewControllers.count>1) {
     
     
    }
    
}

 
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
     
     int index = scrollView.contentOffset.x / scrollView.frame.size.width;
  
     [self titleClick:self.titlesView.subviews[index]];
     [self switchController:index];
    
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView
{
     int a=(int)(scrollView.contentOffset.x / scrollView.frame.size.width);
     
     [self switchController:a];
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end








