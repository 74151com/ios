//
//  TPengyouquanListViewController.m
//  tio-chat-ios
//  朋友圈列表
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TPengyouquanListViewController.h"
  
#import "TPengyouquanListTableViewCell.h"
#import "TPengyouquanListModel.h"
#import "MBProgressHUD+NJ.h"
//#import "TPengyouquanPublishViewController.h"
//#import "TReportViewController.h"
//#import "TPengyouquanDetailViewController.h"
//#import "TUserHomePageViewController.h"
//#import "TPengyouquanDetailSKVc.h"

@interface TPengyouquanListViewController () <UITableViewDelegate, UITableViewDataSource>
 
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *mDataArray;

@property (nonatomic, assign) NSInteger mPageNum;
@property (nonatomic, assign) NSInteger mPageSize;

@property (nonatomic, assign) int navHeight;
@end

@implementation TPengyouquanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEMEBACKCOLOR;
    
    self.mPageNum = 1;
    self.mPageSize = 10;
    _navHeight = 1;
    if(_mineTo){
        _navHeight = Height_NavBar;
        [self setupNavUI];
    }
    [self setupUI];
    [self loadData];
}

#pragma mark 加载数据
-(void)loadData {
    self.mPageNum = 1;
    CBWeakSelf
  /*  [TPengyouquanListModel requestPengyouquanListWithBlock:^(int code, NSArray * _Nonnull findList, NSString * _Nonnull errorMsg) {
        CBStrongSelfElseReturn
        [self.mTableView.mj_header endRefreshing];
        if (code == http_code_success) {
            self.mDataArray = [NSMutableArray arrayWithArray:findList];
            self.mPageNum += 1;
        } else {
            [MBProgressHUD showError:@"网络加载失败"];
        }
        [self.mTableView reloadData];
        if (self.mDataArray.count == 0) {
            self.mTableView.hidden = true;
        }
    } withParams:@{@"pageNum": @(self.mPageNum), @"pageSize":@(self.mPageSize)}];
    
    */
}

#pragma mark 加载更多
-(void)loadMoreData {
    CBWeakSelf
    
  /*  [TPengyouquanListModel requestPengyouquanListWithBlock:^(int code, NSArray * _Nonnull findList, NSString * _Nonnull errorMsg) {
        CBStrongSelfElseReturn
        [self.mTableView.mj_footer endRefreshing];
        if (code == http_code_success) {
            [self.mDataArray addObjectsFromArray:findList];
            self.mPageNum += 1;
        } else {
            [MBProgressHUD showInfo:@"没有更多了"];
        }
        if (findList.count > 0) {
            [self.mTableView reloadData];
        }
        if (self.mDataArray.count == 0) {
            self.mTableView.hidden = true;
        }
    } withParams:@{@"pageNum": @(self.mPageNum), @"pageSize":@(self.mPageSize)}];
   */
}

#pragma mark 发布
-(void)publicButtonItemClicked {
//    TPengyouquanPublishViewController *publishVC = [[TPengyouquanPublishViewController alloc] init];
//    publishVC.publishSuccessBlock = ^{
//        [self loadData];
//    };
//    [self.navigationController pushViewController:publishVC animated:true];
}

#pragma mark 点赞/取消点赞
-(void)likeBtnAction:(UIButton *)sender {
    TPengyouquanListModel *model = self.mDataArray[sender.tag];
 /*   NSString *dianzanDele = pengyouquanAddOrCancelLike;
    if(model.isPraise==1){
        dianzanDele = pengyouquanAddOrdeletelLike;
    }
    
    [TPengyouquanListModel requestPengyouquanAddOrCancelLikeWithBlock:^(int code, NSString * _Nonnull errorMsg) {
        if (code == http_code_success) {
            model.isPraise = !model.isPraise;
            if (model.isPraise) {
                model.praiseNum+=1;
            } else {
                model.praiseNum-=1;
            }
            [self.mTableView reloadData];
            [MBProgressHUD showSuccess:errorMsg];
        } else {
            [MBProgressHUD showError:errorMsg];
        }
    } withParams:@{@"msgId":model.id} withUrlString:dianzanDele];
    */
   /*
    [TPengyouquanListModel requestPengyouquanAddOrCancelLikeWithBlock:^(int code, NSString * _Nonnull errorMsg) {
        if (code == http_code_success) {
            model.likeMap.isliked = !model.likeMap.isliked;
            if (model.likeMap.isliked) {
                model.likeMap.likenum+=1;
            } else {
                model.likeMap.likenum-=1;
            }
            [self.mTableView reloadData];
            [MBProgressHUD showSuccess:errorMsg];
        } else {
            [MBProgressHUD showError:errorMsg];
        }
    } withParams:@{@"msgId":model.id} withUrlString:dianzanDele];
    
    */
}

#pragma mark 评论
-(void)commentNumBtnAction:(UIButton *)sender {
    TPengyouquanListModel *model = self.mDataArray[sender.tag];
/*    TPengyouquanDetailViewController *detailVC = [[TPengyouquanDetailViewController alloc] init];
    detailVC.mId = model.id;
    [self.navigationController pushViewController:detailVC animated:true];
 */
}

#pragma mark 更多
-(void)moreBtnAction:(UIButton *)sender {
    TPengyouquanListModel *model = self.mDataArray[sender.tag];
 /*   TIOLoginUser *loginUser = TIOChat.shareSDK.loginManager.userInfo;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([loginUser.userId isEqualToString:[NSString stringWithFormat:@"%ld", model.uid]]) {
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TPengyouquanListModel requestPengyouquanDeleteWithBlock:^(int code, NSString * _Nonnull errorMsg) {
                if (code == http_code_success) {
                    [MBProgressHUD showSuccess:errorMsg];
                    [self.mDataArray removeObject:model];
                    [self.mTableView reloadData];
                } else {
                    [MBProgressHUD showError:errorMsg];
                }
            } withParams:@{@"msgId":model.id}];
        }];
        [alertController addAction:deleteAction];
    } else {
        UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TReportViewController *reportVC = [[TReportViewController alloc] init];
            reportVC.pengyouquanListModel = model;
            [self.navigationController pushViewController:reportVC animated:true];
        }];
        [alertController addAction:reportAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:nil];
  */
}

/// 导航条
-(void)setupNavUI {
    
    
}


#pragma mark 初始化视图
-(void)setupUI {
    
    
    // 暂无数据
    UILabel *mNodateLbl = [[UILabel alloc] init];
    mNodateLbl.text = @"暂无朋友圈数据";
    mNodateLbl.font = [UIFont systemFontOfSize:15];
    mNodateLbl.textColor = THEMEBACKCOLOR;
    [self.view addSubview:mNodateLbl];
    [mNodateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.mTableView];
//    CBWeakSelf
//    self.mTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        CBStrongSelfElseReturn
//        [self loadData];
//    }];
//    self.mTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//        CBStrongSelfElseReturn
//        [self loadMoreData];
//    }];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(_navHeight);//Height_NavBar);
    }];
}

#pragma mark uitableview --- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPengyouquanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TPengyouquanListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.mDataArray[indexPath.row]];
    cell.mLikeBtn.tag = indexPath.row;
    [cell.mLikeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.mMoreBtn.tag = indexPath.row;
    [cell.mMoreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.mCommentNumBtn.tag = indexPath.row;
    [cell.mCommentNumBtn addTarget:self action:@selector(commentNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    CBWeakSelf
    cell.tapHeaderImageBlock = ^{
        CBStrongSelf
        if(self.mDataArray.count > indexPath.row){
            TPengyouquanListModel *model = self.mDataArray[indexPath.row];
            [self jumpToUserDetail:model];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPengyouquanListModel *model = self.mDataArray[indexPath.row];
//    TPengyouquanDetailSKVc *detailVC = [[TPengyouquanDetailSKVc alloc] init];
//
//   // TPengyouquanDetailViewController *detailVC = [[TPengyouquanDetailViewController alloc] init];
//    detailVC.mId = model.id;
//    detailVC.modelList = model;
//    [self.navigationController pushViewController:detailVC animated:true];
}

#pragma mark 懒加载
-(UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.estimatedRowHeight = 90;
        _mTableView.rowHeight = UITableViewAutomaticDimension;
        _mTableView.backgroundColor = THEMEBACKCOLOR;
        [_mTableView registerClass:[TPengyouquanListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TPengyouquanListTableViewCell class])];
    }
    return _mTableView;
}

 

- (void)jumpToUserDetail:(TPengyouquanListModel*)pengyouquanListModel{
  /*  [TIOChat.shareSDK.friendManager fetchUserInfo:[NSString stringWithFormat:@"%ld",pengyouquanListModel.uid] completion:^(TIOUser * _Nullable user, NSError * _Nullable error) {
        if(!error){
            user.userId = [NSString stringWithFormat:@"%ld",user.friendId];
            BOOL isSelf = [user.userId isEqualToString:[TIOChat.shareSDK.loginManager userInfo].userId];
            [TIOChat.shareSDK.friendManager isMyFriend:user.userId completion:^(BOOL isFriend, NSError * _Nullable error) {
                TUserHomePageType type;
                if(isSelf){
                    type = TUserInfoVCTypeSelf;
                }else if(isFriend){
                    type = TUserInfoVCTypeFriend;
                }else{
                    type = TUserInfoVCTypeAdd;
                }
                TUserHomePageViewController *vc = [TUserHomePageViewController.alloc initWithUser:user type:type];
                        [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }
    }];
   */
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
