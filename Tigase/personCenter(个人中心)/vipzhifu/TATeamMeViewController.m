//
//  TATeamMeViewController.m
//  tio-chat-ios
//
//  Created by os on 2023/8/26.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TATeamMeViewController.h"
#import "TATeamMeNextVc.h"

@interface TATeamMeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
{
    BOOL _isLoading;
    //refresh一次page＋1
    int  _page;
      
    int _tableHeight;
    UIButton *_footerView ;
}
@property(nonatomic,assign) BOOL wh_isTotalNum;
@property(nonatomic,assign) BOOL wh_isShowHeaderPull;
@property(nonatomic,assign) BOOL wh_isShowFooterPull;
@property (nonatomic, strong) NSMutableArray *cells;
 
@property (weak,    nonatomic) UITableView *tableView;
@property (weak,    nonatomic) UIView *topView;
@property (weak,    nonatomic) UILabel *scoreLabel ;
@property (weak,    nonatomic) UILabel *numberLabel ;
@property (weak,    nonatomic) UILabel *detailLabel;

@property (weak,    nonatomic) UITextField *search_tf;

@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation TATeamMeViewController

 
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"邀请联系人";
        self.wh_isGotoBack = YES;
        [self createHeadAndFoot];
        
        _searchArray = [NSMutableArray array];
        _cells = [NSMutableArray array];
        self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
        self.wh_tableBody.frame = CGRectZero;
        // Do any adURL    http://198.44.160.137:6060/mytio/user/curr
        [self setupUI];
        _wh_isTotalNum = YES;
        [self getNetwok];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self.wh_tableHeader addSubview:btn];
        
         UIButton *moreBtn = [UIFactory WH_create_WHButtonWithRect:CGRectMake(0, 0, NAV_BTN_SIZE+10, NAV_BTN_SIZE+10) title:@"兑换" titleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] titleColor:[UIColor redColor] normal:@"兑换" selected:@"兑换" selector:@selector(moreClick) target:self];
         moreBtn.custom_acceptEventInterval = 1.0f;
        [btn addSubview:moreBtn];
        
        [g_server getUser:MY_USER_ID toView:self];
        
    }
    return self;
}
- (void)moreClick{
    [g_App showAlert:[NSString stringWithFormat:@"%@积分可以兑换会员",g_config.exchangeVipScore] delegate:self tag:0 onlyConfirm:NO];
     
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        [g_server WH_Apiuset_UserexchangeVip:@"" toView:self];

    }
         
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    
}
- (void)getNetwok{
   
    [g_server WH_Apiuset_UserSelectInviteUserList:@"1" toView:self];
}

- (void)setupUI
{
    
    {
        UIView *topView  = [UIView.alloc initWithFrame:CGRectMake(1, Height_NavBar, JX_SCREEN_WIDTH, 171)];
        topView.userInteractionEnabled = YES;
        topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:topView];
        self.topView = topView;
        
        
        UILabel *numberLabel  = [UILabel.alloc init];
        numberLabel.text = @"10000 分";
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor redColor];
        [topView addSubview:numberLabel];
        self.numberLabel = numberLabel;
        self.numberLabel.left = 10;
        numberLabel.top = 5;
         self.numberLabel.width = JX_SCREEN_WIDTH-20;
        self.numberLabel.height = 50;
        
        
        UILabel *scoreLabel  = [UILabel.alloc init];
        scoreLabel.text = @"积分";
        scoreLabel.textColor = [UIColor redColor];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        self.scoreLabel.left = 10;
        scoreLabel.top = 5+CGRectGetMaxY(numberLabel.frame);
       // self.iconImgv.centerY = self.topView.middleY;
         self.scoreLabel.width = JX_SCREEN_WIDTH-20;
       // self.iconImgv.right = 10;
        self.scoreLabel.height = 50;
        
        
        UILabel *detailLabel = [UILabel.alloc initWithFrame:CGRectMake(0, CGRectGetMaxY(scoreLabel.frame)+6, JX_SCREEN_WIDTH, 50)];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.text = @"我已邀请x人";
        detailLabel.backgroundColor =  HEXCOLOR(0xFFAD69);//
        detailLabel.textAlignment = NSTextAlignmentCenter;
//        detailLabel.textColor = HEXCOLOR(0x9C9C9C);
        [topView addSubview:detailLabel];
        _detailLabel = detailLabel;
        
//        UITextField *search_tf = [UITextField.alloc initWithFrame:CGRectMake(5, 75, JX_SCREEN_WIDTH-10, 44)];
//        search_tf.layer.cornerRadius= 15;
//        search_tf.layer.masksToBounds =YES;
//        search_tf.layer.borderWidth = 2;
//        search_tf.layer.borderColor= HEXCOLOR(0xF8F8F8).CGColor;
//        search_tf.placeholder = @"搜索下级";
//        search_tf.backgroundColor = [UIColor whiteColor];
//        [topView addSubview:search_tf];
//        [search_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _search_tf = search_tf;
//
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar"]];
//        UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 7, 30, 30)];
//        imageView.center = leftView.center;
//        [leftView addSubview:imageView];
//        search_tf.leftView = leftView;
//        search_tf.leftViewMode = UITextFieldViewModeAlways;
//        search_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
//        search_tf.leftView = leftView;
        
    }
    
    UITableView *tableView = [UITableView.alloc initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+2, self.view.width, self.view.height - CGRectGetMaxY(self.topView.frame)+2) style:UITableViewStylePlain];
    tableView.backgroundColor = THEMEBACKCOLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionFooterHeight = CGFLOAT_MIN;
    tableView.separatorInset = UIEdgeInsetsMake(0, 81, 0, 0);
    tableView.separatorColor = HEXCOLOR(0xE6E6E6);
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [tableView setAutoresizesSubviews:YES];
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    _tableView = tableView;
   
//    UIButton *footerView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,JX_SCREEN_WIDTH, 44)];
//    UIButton *footerBtn = [[UIButton alloc]initWithFrame:CGRectMake((JX_SCREEN_WIDTH-100)/2, 0,100, 44)];
//    [footerView setTitle:@"查看更多" forState:UIControlStateNormal];
//    [footerView setTitleColor:HEXCOLOR(0xFFAD69) forState:UIControlStateNormal];
//    [footerView addSubview:footerBtn];
//    footerView.userInteractionEnabled = YES;
//    footerBtn.showsTouchWhenHighlighted = YES;
//    //footerBtn.backgroundColor = HEXCOLOR(0xFFAD69);
//    _tableView.tableFooterView = footerView;
//    _footerView = footerView;
//    [footerView addTarget:self action:@selector(WH_scrollToPageDown) forControlEvents:UIControlEventTouchUpInside];
    
    
     [self addHeader];
     [self addFooter];
     [tableView registerClass:[TATeamLevelCell class] forCellReuseIdentifier:@"TATeamLevelCell"];
}

- (void) textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        [self getNetwok];
        
        return;
    }
    
    [_searchArray removeAllObjects];
    for (NSInteger i = 0; i < _cells.count; i ++) {
        NSDictionary *user = _cells[i];
        NSLog(@"textField:=%@",textField.text);
//        NSLog(@"user:=%@ ^%@",user.registercode,user.invitecode);
//        if(user.registercode > 0 &&[user.registercode containsString:textField.text]) {
//
//            [_searchArray addObject:user];
//        }
        
    }
    [self.tableView reloadData];
    //[self getTotalNewMsgCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_search_tf.text.length > 0) {
        return _searchArray.count;
    }
    return _cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TATeamLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATeamLevelCell" forIndexPath:indexPath];
   // NSMutableArray *array;
    NSDictionary *dict = nil;
    if (_search_tf.text.length > 0) {
        dict = _searchArray[indexPath.row]; ;
    }else {
       dict = _cells[indexPath.row]; ;
       
    } 
   
    cell.userData = dict;
    
    cell.iconImgBlock = ^(NSString *userInfo) {
        
       // [self.navigationController pushViewController:[TUserHomePageViewController.alloc initWithUser:user type:TUserInfoVCTypeVerfiy] animated:YES];
         
//        self->_user = [[WH_JXUserObject alloc]init];
//        self->_user.userId = [NSString stringWithFormat:@"%ld",(long)dict.userId];
//        self->_user.userNickname = dict.userNickname;
//        self->_user.userHead = dict.userHead;
        
        
       // TUserHomePageViewController *vc = [TUserHomePageViewController.alloc initWithUser:_user type:TUserInfoVCTypeFriend];
       // [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      
//    WH_JXUserObject *dict = _cells[indexPath.row];
//    TATeamMeNextVc *vc = [[TATeamMeNextVc alloc]init];
//    vc.invitecode =@"";// dict.invitecode;
//    vc.nextCode = @"";// [dict objectForKey:@""];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    [_wait stop];
    [_footer endRefreshing];
    [_header endRefreshing];
    if( [aDownload.action isEqualToString:act_UserSelectInviteUserList] ){
         NSArray *vipConfigArr =  [dict objectForKey:@"vipConfig"];
        
        NSArray *tempArr = [dict objectForKey:@"data"];
        if(_page>1){
            if(tempArr.count>0){
                [_cells addObjectsFromArray:tempArr];
            }
        }else{
            
            _cells = tempArr.mutableCopy;
        }
        self.wh_isShowHeaderPull = tempArr.count >= 20;
        if(_wh_isTotalNum){
            _wh_isTotalNum = NO;
            _detailLabel.text = [NSString stringWithFormat:@"----> 我已邀请%@人 <----",[dict objectForKey:@"count"]];
            
          //  _detailLabel.text = [NSString stringWithFormat:@"----> 我已邀请%zd人 <----",_cells.count];
        }
        [self->_tableView reloadData];
    }
    
    if( [aDownload.action isEqualToString:act_UserexchangeVip] ){
        
        NSLog(@"act_UserexchangeVip ====== %@",dict);
        
       
    }
    if( [aDownload.action isEqualToString:wh_act_UserGet] ){
        
        NSLog(@"act_UserexchangeVip ====== %@",dict);
        if([dict.allKeys containsObject:@"score"]){
            _numberLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]];
        }else{
            _numberLabel.text = @" 0";
        }
       
    }
    
}

- (void)getlistdata:(NSArray *)array{
    int b=1;
    
    
}

- (void) scrollToCurrentLine {
 
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
   [_wait start];
}


#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    [_footer endRefreshing];
    [_header endRefreshing];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    [_footer endRefreshing];
    [_header endRefreshing];
    return WH_show_error;
}

-(void)WH_scrollToPageDown{
    if(_isLoading)
        return;
    _page++;
    [self WH_getServerData];
}

-(void)setWh_isShowHeaderPull:(BOOL)b{
    
    _header.hidden = !b;
    _wh_isShowHeaderPull  = b;
}

-(void)setWh_isShowFooterPull:(BOOL)b{
    _footer.hidden = !b;
    _wh_isShowFooterPull = b;
}

-(void)WH_getServerData{
    
    [g_server WH_Apiuset_UserSelectInviteUserList:[NSString stringWithFormat:@"%d",_page] toView:self];
}
//顶部刷新获取数据
-(void)WH_scrollToPageUp{
    if(_isLoading)
        return;
    NSLog(@"WH_scrollToPageUp");
    _page = 0;
    [self WH_getServerData];
    [self performSelector:@selector(WH_stopLoading) withObject:nil afterDelay:1.0];
}
- (void)WH_stopLoading {
    _isLoading = NO;
    [_footer endRefreshing];
    [_header endRefreshing];
}
- (void)addFooter
{
    if(_footer){
//        [_footer free];
//        return;
    }
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    __weak TATeamMeViewController *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf WH_scrollToPageDown];
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    _footer.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
}

- (void)addHeader
{
    if(_header){
//        [_header free];
//        return;
    }
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    __weak TATeamMeViewController *weakSelf = self;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [weakSelf WH_scrollToPageUp];
    };
    _header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    _header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
}

@end
