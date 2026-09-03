//
//  TATeamMeViewController.m
//  tio-chat-ios
//
//  Created by os on 2023/8/26.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TATeamMeNextVc.h"

@interface TATeamMeNextVc () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *cells;


@property (weak,    nonatomic) UITableView *tableView;
@property (weak,    nonatomic) UIView *topView;
@property (weak,    nonatomic) UIImageView *iconImgv ;
@property (weak,    nonatomic) UILabel *detailLabel;

@property (weak,    nonatomic) UITextField *search_tf;

@property (nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation TATeamMeNextVc

 

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"团队";
        self.wh_isGotoBack = YES;
        [self createHeadAndFoot];
    }
    return self;
}

 
- (void)viewDidLoad {
    [super viewDidLoad];
    _cells = [NSMutableArray array];
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);;
    // Do any adURL    http://198.44.160.137:6060/mytio/user/curr
    [self setupUI]; [self getNetwok];
    
}
 
- (void)getNetwok{
    
//    NSString *invitecode = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitecode"];
//    NSString *registercode = [[NSUserDefaults standardUserDefaults] objectForKey:@"registercode"];
    NSDictionary *dict= @{@"invitecode":_invitecode,@"registercode":_nextCode.length>0?_nextCode:@""};
   // NSDictionary *dict2= @{@"invitecode":@"d2chzg",@"registercode":@""};
    /* [APPHTTPManager t_GET:@"/sys/getUserByRegisterCode" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *frontUserdict = responseObject[@"data"][@"frontUser"];
         NSArray *afterUserArr = responseObject[@"data"][@"afterUser"];
        // [self->_cells addObjectsFromArray:afterUserArr];
          //avatar
         
         self->_cells =  [TIOLoginUser mj_objectArrayWithKeyValuesArray:afterUserArr];
         
         NSArray *allkeys = [frontUserdict allKeys];
         
         if([[frontUserdict objectForKey:@"nick"] length]>0){
             
          //   self->_detailLabel.text = [NSString stringWithFormat:@"%@ (我的上级) 邀请码:%@",[frontUserdict objectForKey:@"nick"],_registercode];
         }else{
             
             self->_detailLabel.text = @"暂无";
         }
         [self->_tableView reloadData];
         // 1:要更新 2:不要更新
        NSLog(@" getUserByRegisterCode =%@",responseObject);

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" getUserByRegisterCode =%@",error);
     } retryCount:1];
    */
}
- (void)setupUI
{
    
    UIView *topView  = [UIView.alloc initWithFrame:CGRectMake(1, Height_NavBar, JX_SCREEN_WIDTH, 60)];
    topView.backgroundColor = [UIColor whiteColor];//
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    self.topView = topView;
    
    
    if(1>2){
      
        UIImageView *iconImgv  = [UIImageView.alloc init];
        iconImgv.image = [UIImage imageNamed:@"cardGroup"];
        iconImgv.layer.cornerRadius= 5;
        iconImgv.layer.masksToBounds =YES;
        [topView addSubview:iconImgv];
        self.iconImgv = iconImgv;
        
        self.iconImgv.left = 10;
        iconImgv.top = 10;
       // self.iconImgv.centerY = self.topView.middleY;
        self.iconImgv.width = 50;
        self.iconImgv.height = 50;
        
        
        UILabel *detailLabel = [UILabel.alloc initWithFrame:CGRectMake(70, 10, JX_SCREEN_WIDTH-70, 50)];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.text = @"暂无";
        detailLabel.textColor =  HEXCOLOR(0x9C9C9C);
        [topView addSubview:detailLabel];
        _detailLabel = detailLabel;
        
     
        
    }
    UITextField *search_tf = [UITextField.alloc initWithFrame:CGRectMake(5, 10, JX_SCREEN_WIDTH-10, 40)];
    search_tf.layer.cornerRadius= 15;
    search_tf.layer.masksToBounds =YES;
    search_tf.layer.borderWidth = 2;
//    search_tf.layer.borderColor = HEXCOLOR(0xF8F8F8);
    search_tf.placeholder = @"搜索下级";
    search_tf.backgroundColor = [UIColor whiteColor];
    [topView addSubview:search_tf];
    [search_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _search_tf = search_tf;
     
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar"]];
    UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 7, 30, 30)];
    imageView.center = leftView.center;
    [leftView addSubview:imageView];
    search_tf.leftView = leftView;
    search_tf.leftViewMode = UITextFieldViewModeAlways;
    search_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    search_tf.leftView = leftView;
    UITableView *tableView = [UITableView.alloc initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+2, self.view.width, self.view.height - CGRectGetMaxY(self.topView.frame)+2) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionFooterHeight = CGFLOAT_MIN;
    tableView.separatorInset = UIEdgeInsetsMake(0, 81, 0, 0);
    tableView.separatorColor =HEXCOLOR(0xE6E6E6);
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView registerClass:[TATeamLevelCell class] forCellReuseIdentifier:@"TATeamLevelCell"];
}
- (void) textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        [self getNetwok];
        
        return;
    }
    
    [_searchArray removeAllObjects];
    for (NSInteger i = 0; i < _cells.count; i ++) {
        WH_JXUserObject *user = _cells[i];
        
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
    NSMutableArray *array;
    WH_JXUserObject *dict = nil;
    if (_search_tf.text.length > 0) {
        dict = _searchArray[indexPath.row]; ;
    }else {
        dict = _cells[indexPath.row]; ;
       
    }
   
    cell.user = dict;
    
    cell.iconImgBlock = ^(NSString *userInfo) {
        
       // [self.navigationController pushViewController:[TUserHomePageViewController.alloc initWithUser:user type:TUserInfoVCTypeVerfiy] animated:YES];
         
//        self->_user = [[WH_JXUserObject alloc]init];
//        self->_user.userId = [NSString stringWithFormat:@"%ld",(long)dict.friendId];
//        self->_user.nick = dict.nick;
//        self->_user.avatar = dict.avatar;
        
        
//        TUserHomePageViewController *vc = [TUserHomePageViewController.alloc initWithUser:_user type:TUserInfoVCTypeFriend];
//        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     TATeamMeNextVc *vc = [[TATeamMeNextVc alloc]init];
     vc.invitecode = [dict objectForKey:@"invitecode"];
     vc.nextCode = @"";// [dict objectForKey:@""];
     [self.navigationController pushViewController:vc animated:YES];
       
     */
    
    WH_JXUserObject *dict = _cells[indexPath.row];
    
//    NSString *invitecode = dict.invitecode;
//    NSString *resterCode =dict.registercode; //[dict objectForKey:@"registercode"];
//
    NSDictionary *dictMM= @{@"invitecode":_invitecode,@"registercode":@""};
   /* [APPHTTPManager t_GET:@"/sys/getUserByRegisterCode" parameters:dictMM success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSDictionary *frontUserdict = responseObject[@"data"][@"frontUser"];
        NSArray *afterUserArr = responseObject[@"data"][@"afterUser"];
        
        self->_cells =  [TIOLoginUser mj_objectArrayWithKeyValuesArray:afterUserArr];
        
        
        [self->_tableView reloadData];
        // 1:要更新 2:不要更新
        NSLog(@" getUserByRegisterCode =%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" getUserByRegisterCode =%@",error);
    } retryCount:1];
    */
    
}
 
@end
