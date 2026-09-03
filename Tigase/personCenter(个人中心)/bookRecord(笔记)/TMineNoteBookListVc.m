//
//  TMineNoteBookListVc.m
//  tio-chat-ios
//
//  Created by os on 2023/12/19.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TMineNoteBookListVc.h"
#import "TMineNoteListCell.h"  
#import "TMineNoteBookVc.h"
#import "WH_ImageBrowser_WHViewController.h"
//#import "YBIBVideoData.h"
//#import "YBIBImageData.h"
//#import "YBImageBrowser.h"
//#import "TMineNoteBookVc.h"

@interface TMineNoteBookListVc ()<UITableViewDelegate, UITableViewDataSource>
 
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) NSInteger mPageNum;

@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, strong) NSMutableArray *mDataArray;
@end

@implementation TMineNoteBookListVc

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"笔记";
        self.wh_isGotoBack = YES;
        
        [self createHeadAndFoot];
        self.wh_tableBody.frame = CGRectZero;
        _mDataArray = [NSMutableArray array];
        self.mPageNum = 1;
        // 发布
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
        [btn addTarget:self action:@selector(onMore) forControlEvents:UIControlEventTouchUpInside];
        [self.wh_tableHeader addSubview:btn];
        UIButton *moreBtn = [UIFactory WH_create_WHButtonWithImage:@"person_add"
                                      highlight:nil   target:self   selector:@selector(onMore)];
        moreBtn.custom_acceptEventInterval = 1.0f;
        moreBtn.frame = CGRectMake(BTN_RANG_UP * 2, BTN_RANG_UP, NAV_BTN_SIZE, NAV_BTN_SIZE);;
        [btn addSubview:moreBtn];
        
        // 暂无数据
        UILabel *mNodateLbl = [[UILabel alloc] init];
        mNodateLbl.text = @"暂无笔记数据";
        mNodateLbl.font = [UIFont systemFontOfSize:15];
        mNodateLbl.textColor = THEMECOLOR;
        [self.view addSubview:mNodateLbl];
        [mNodateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        
        [self.view addSubview:self.mTableView];
        self.mTableView.backgroundColor = THE_LINE_COLOR;
        [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(Height_NavBar+1);
        }];
        
        
       // [self loadData];
    }
    return self;
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)onMore{
  //  BookRecordViewController *vc = [[BookRecordViewController alloc]init];
    TMineNoteBookVc *vc = [[TMineNoteBookVc alloc] init];
    [g_navigation pushViewController:vc animated:YES];
    
   // TMineNoteBookVc *vc = [[TMineNoteBookVc alloc] init];
}
- (void)loadData{
    _mPageNum = 1;
    [g_server WH_getact_NoteListConfigUserId:@"0" toView:self];
     
    
}
- (void)loadMoreData{
    
    _mPageNum ++;
    [g_server WH_getact_NoteListConfigUserId:[NSString stringWithFormat:@"%zd",_mPageNum] toView:self];
    
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
        [_mTableView registerClass:[TMineNoteListCell class] forCellReuseIdentifier:NSStringFromClass([TMineNoteListCell class])];
    }
    return _mTableView;
}
 
#pragma mark uitableview --- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMineNoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TMineNoteListCell class])];
   // cell.backgroundColor = HMRandomColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictData = self.mDataArray[indexPath.row];
    [cell setData:dictData];
     
    cell.editBlock = ^(NSInteger index) {
         
        TMineNoteBookVc *vc = [TMineNoteBookVc alloc];
        vc.isEdit = YES;
        vc.noteId = [dictData objectForKey:@"noteId"];
        vc.dictData = dictData;
        vc= [vc init];
        [g_navigation pushViewController:vc animated:YES];
    } ;
    cell.tapVideoImageBlock = ^(NSString *oUrltype) {
     
        
        NSMutableArray *imagePathArr = [[NSMutableArray alloc]init];
        [imagePathArr addObject:oUrltype];
        NSMutableArray *tempArr = [NSMutableArray array];
        WH_JXMessageObject* msgImg = [[WH_JXMessageObject alloc]init];
        msgImg.content =oUrltype;
        msgImg.type = [NSNumber numberWithInt:2];
        [tempArr addObject:msgImg];
        
        [WH_ImageBrowser_WHViewController show:self delegate:self type:PhotoBroswerVCTypeModal contentArray:tempArr index:0 imagesBlock:^NSArray *{
            return imagePathArr;
        }];
        
       NSMutableArray *datas = [NSMutableArray array];
       
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.mDataArray[indexPath.row];
   
    if ([self.delegate respondsToSelector:@selector(noteBookVc:didSelectWithData:)]) {
        
        _wh_currentData = data;
        [g_App showAlert:@"发送笔记?" delegate:self tag:2457 onlyConfirm:NO];
    }else{
        
        [g_server WH_getact_NoteDetailConfigUserId:[data objectForKey:@"noteId"] toView:self];
        
        TMineNoteBookVc *vc = [TMineNoteBookVc alloc];
        vc.isEdit = YES;
        vc.dictData = data;
        vc= [vc init];
        [g_navigation pushViewController:vc animated:YES];
             
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 2457) {
            
            [self.delegate noteBookVc:self didSelectWithData:_wh_currentData];
            [self actionQuit];
        }
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictData = _mDataArray[indexPath.row];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    
    UIAlertAction* sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _indexPathRow = indexPath.row;
        [g_server WH_getact_NoteDeleteConfigUserId:[dictData objectForKey:@"noteId"] toView:self];
        
    }];
    [alert addAction:defaultAction];
    [alert addAction:sureAction];
   
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark  -------------------服务器返回数据--------------------
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
   [_wait stop];
    
    if([aDownload.action isEqualToString:act_NoteDetailConfig]){
        
        
    }
    
    if([aDownload.action isEqualToString:act_NoteDeleteConfig]){
       
            [g_server showMsg:@"删除成功"];
            
         [self->_mDataArray removeObjectAtIndex:_indexPathRow];
         [self->_mTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_indexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];//:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
      
            [g_server showMsg:@"删除失败"];
           
    }
    if( [aDownload.action isEqualToString:act_NoteListConfig] ){
       
       if(_mPageNum>1){
           if(array1.count>0){
               [_mDataArray addObjectsFromArray:array1];
           }
       }else{
           
           _mDataArray = array1.mutableCopy;
       }
   //    self.wh_isShowHeaderPull = tempArr.count >= 20;
      
       [self->_mTableView reloadData];
    }
    
    
}


#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
  //  [self WH_doUploadError:aDownload];
    [_wait stop];
    if([aDownload.action isEqualToString:act_NoteAddConfig]){
        
    }
    if([aDownload.action isEqualToString:act_NoteDeleteConfig]){
    }
    return WH_hide_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    
    [_wait stop];
    if([aDownload.action isEqualToString:act_NoteAddConfig]){
        
    }
    if([aDownload.action isEqualToString:act_NoteDeleteConfig]){
    }
    return WH_hide_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    // 撤回加等待符（撤回接口调用很慢）
   [_wait start];
   
}
 
/**
 if(index==2){
     NSArray *videoUrlsArr = [dictData objectForKey:@"videoUrls"];
     NSString *videoUrl = [videoUrlsArr.firstObject objectForKey:@"url"];
     
//                YBIBVideoData *data = [YBIBVideoData new];
//                data.videoURL = [NSURL URLWithString:videoUrl];
//                data.projectiveView = 0;
//                [datas addObject:data];
//                YBImageBrowser *browser = [YBImageBrowser new];
//                browser.dataSourceArray = datas;
//                browser.currentPage = 0;
//                // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//                browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//                [browser show];
 }else if(index==1){
     
  NSArray *fileUrlsArr = [dictData objectForKey:@"fileUrls"];
     NSString *imageUrl = [fileUrlsArr.firstObject objectForKey:@"url"];
     // 网络图片
//            YBIBImageData *data = [YBIBImageData new];
//            data.imageURL = [NSURL URLWithString:imageUrl];
//            data.projectiveView = 0;
//            [datas addObject:data];
//            YBImageBrowser *browser = [YBImageBrowser new];
//            browser.dataSourceArray = datas;
//            browser.currentPage = 0;
//            // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//            browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//            [browser show];
 } 
 */
@end

