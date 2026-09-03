//
//  TMineNoteBookDetialListTVc.m
//  Tigase
//
//  Created by os on 2024/2/29.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "TMineNoteBookDetialListTVc.h"
#import "IQTextView.h"
#import "TMineNoteDetialCell.h"
#import "WH_ImageBrowser_WHViewController.h"
#import "TMineNoteDetialTextCell.h"

@interface TMineNoteBookDetialListTVc ()<UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource>
 
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) NSInteger mPageNum;

@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, strong) NSMutableArray *mDataArray;
@end

@implementation TMineNoteBookDetialListTVc

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"笔记详情";
        self.wh_isGotoBack = YES;
        [self createHeadAndFoot];
        self.wh_tableBody.frame = CGRectZero;
        _mDataArray = [NSMutableArray array];
        self.mPageNum = 1;
        // 发布
        
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
            make.top.equalTo(self.view).offset(Height_NavBar);
        }];
        
        
       // [self loadData];
    }
    return self;
}
-(void)setDictArr:(NSArray *)dictArr{
    _dictArr = dictArr;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
 
- (void)loadData{
    _mPageNum = 1;
    [g_server WH_getact_NoteDetailConfigUserId:_noteId toView:self];
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
        [_mTableView registerClass:[TMineNoteDetialTextCell class] forCellReuseIdentifier:NSStringFromClass([TMineNoteDetialTextCell class])];
        [_mTableView registerClass:[TMineNoteDetialCell class] forCellReuseIdentifier:NSStringFromClass([TMineNoteDetialCell class])];
        
        
    }
    return _mTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return [_mTableView estimatedRowHeight];
    }else{
        return 310;
    }
}
#pragma mark uitableview --- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 1;
    }else{
        return _dictArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(indexPath.section==0){
        TMineNoteDetialTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TMineNoteDetialTextCell class])];
       // cell.backgroundColor = HMRandomColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dictData = _dictArr[indexPath.row];
        [cell setData:_titleStr contentStr:_contentStr];
        return cell;
    }else{
        TMineNoteDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TMineNoteDetialCell class])];
       // cell.backgroundColor = HMRandomColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dictData = _dictArr[indexPath.row];
       [cell setData:dictData];
        
        cell.tapHeaderImageBlock = ^{
          
          NSString *oUrltype = [dictData objectForKey:@"oUrl"];
          if([oUrltype hasSuffix:@".mp4"]) {//判断是否是视频链接
              
              _player= [WH_JXVideoPlayer alloc];
              _player.type = JXVideoTypeChat;
              _player.isShowHide = YES; //播放中点击播放器便销毁播放器
              _player.isStartFullScreenPlay = YES; //全屏播放
              _player.WH_didVideoPlayEnd = @selector(WH_didVideoPlayEnd);
              _player.delegate = self;
              if (oUrltype) {
                  _player.videoFile = oUrltype;
              }else  if(isFileExist(oUrltype)) {
                  _player.videoFile = oUrltype;
              }
              
              _player = [_player initWithParent:self.view];
              
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [_player wh_switch];
              });
              
          }else{
              
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
              
          }
            
        };
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        return;
    }
  
}

#pragma mark  -------------------服务器返回数据--------------------
  
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
 
@end
