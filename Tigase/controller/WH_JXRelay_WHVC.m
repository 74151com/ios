//
//  WH_JXRelay_WHVC.m
//  Tigase_imChatT
//
//  Created by p on 2017/6/27.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "WH_JXRelay_WHVC.h"
#import "WH_JXChat_WHViewController.h"
#import "WH_JXRoomPool.h"
#import "WH_JXRoomObject.h"
#import "WH_JX_WHCell.h"
#import "addMsgVC.h"
#import "QCheckBox.h"

typedef enum : NSUInteger {
    RelayType_msg = 1,
    RelayType_myFriend,
    RelayType_myGroup,
} RelayType;

@interface WH_JXRelay_WHVC ()<QCheckBoxDelegate>

@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, strong) NSMutableArray *myFriendArray;
@property (nonatomic, strong) NSMutableArray *myGroupArray;
@property (nonatomic, assign) RelayType type;
@property (nonatomic, strong) WH_JXRoomObject *chatRoom;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray *checkBoxs;
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation WH_JXRelay_WHVC

// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack = YES;
    //self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT-JX_SCREEN_BOTTOM);
    [self WH_createHeadAndFoot];
    
    _msgArray = [NSMutableArray array];
    _myFriendArray = [NSMutableArray array];
    _myGroupArray = [NSMutableArray array];
    
    _checkBoxs = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
     
    self.type = RelayType_msg;
    
    [self getLocData];
    if (self.isMoreSel) {
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(55, JX_SCREEN_TOP - 34, 34, 24)];
        [self.cancelBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn.hidden = YES;
        [self.wh_tableHeader addSubview:self.cancelBtn];
        
        self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - 60-10, JX_SCREEN_TOP - 34, 60, 24)];
        [self.doneBtn setTitle:Localized(@"JX_Multiselect") forState:UIControlStateNormal];
        [self.doneBtn setTitle:Localized(@"JX_Finish") forState:UIControlStateSelected];
        [self.doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.wh_tableHeader addSubview:self.doneBtn];
        
        [self setDoneBtnFrame];
    }
}


- (void)setDoneBtnFrame {
    CGSize size = [self.doneBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.doneBtn.titleLabel.font}];
    
    self.doneBtn.frame = CGRectMake(JX_SCREEN_WIDTH-size.width-15, self.doneBtn.frame.origin.y, size.width, self.doneBtn.frame.size.height);
}

- (void)doneBtnAction:(UIButton *)btn {
    
    
    if (self.cancelBtn.hidden) {
        self.wh_isGotoBack = YES;
        self.cancelBtn.hidden = NO;
        [self.tableView reloadData];
    }else {
        
        BOOL flag = NO;
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            
            WH_JXMsgAndUserObject *p = _selectArr[i];
            p.user.msgsNew = [NSNumber numberWithInt:0];
            [p.user update];
            [p.message WH_updateNewMsgsTo0];
            
            if ([p.user.talkTime intValue] > 0) {
                
                memberData *member = [[memberData alloc] init];
                member = [member getCardNameById:MY_USER_ID];
                
                if ([member.role intValue] !=2 && [member.role intValue] !=1) {
                    if (_selectArr.count == 1) {
                        [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
                        return;
                    }
                    [JXMyTools showTipView:[NSString stringWithFormat:@"%@被禁言",p.user.userNickname]];
                    continue;
                }
            }
            
            for (NSInteger j = 0; j < _relayMsgArray.count; j ++) {
                WH_JXMessageObject *msg = _relayMsgArray[j];
                [self relay:msg withUserObj:p];
            }
            
            if ([p.user.userId isEqualToString:self.chatPerson.userId]) {
                flag = YES;
            }
        }
        
//        [g_notify postNotificationName:kRefreshChatLogNotif object:nil];
        [g_server showMsg:Localized(@"JX_SendComplete")];
        [self actionQuit];
    }
    
    self.doneBtn.selected = !self.doneBtn.selected;
    
    [self setDoneBtnFrame];
}

- (void)cancelBtnAction:(UIButton *)btn {
    
    self.wh_isGotoBack = NO;
    self.cancelBtn.hidden = YES;
    self.doneBtn.selected = NO;
    [_selectArr removeAllObjects];
    [self.tableView reloadData];
    
    [self setDoneBtnFrame];
}

- (void) relay:(WH_JXMessageObject *)msg withUserObj:(WH_JXMsgAndUserObject *)userObj{
    
    if (msg.content.length > 0) {
        WH_JXMessageObject *msg1 = [[WH_JXMessageObject alloc]init];
        msg1 = [msg copy];
        msg1.messageId = nil;
        msg1.timeSend     = [NSDate date];
        msg1.fromId = nil;
        msg1.fromUserId   = MY_USER_ID;
        msg1.fromUserName = g_myself.userNickname;
        if([userObj.user.roomFlag boolValue]){
            msg1.isGroup = YES;
        }
        else{
            msg1.isGroup = NO;
        }
        msg1.toUserId = userObj.user.userId;
        //        msg.content      = relayMsg.content;
        //        msg.type         = relayMsg.type;
        msg1.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg1.isRead       = [NSNumber numberWithBool:NO];
        msg1.isReadDel    = [NSNumber numberWithInt:NO];
        
        
        NSString *roomJid = nil;
        if ([userObj.user.roomFlag boolValue]) {
            roomJid = userObj.user.userId;
        }
        //发往哪里
        [msg1 insert:roomJid];
        [g_xmpp sendMessage:msg1 roomName:roomJid];//发送消息
        
        if ([userObj.user.userId isEqualToString:self.chatPerson.userId]) {
            [self.chatVC WH_show_WHOneMsg:msg1];
        }
    }

}

- (void) getLocData {
    NSMutableArray* p = [[WH_JXMessageObject sharedInstance] fetchRecentChat];
    //    if (p.count>0 || _page == 0) {
    if (p.count>0) {
        for(NSInteger i = 0; i < p.count; i ++) {
            WH_JXMsgAndUserObject *obj = p[i];
            if ([obj.user.userId isEqualToString:FRIEND_CENTER_USERID]) {
                continue;
            }
            
            [_msgArray addObject:obj];
        }
        //让数组按时间排序
        [self sortArrayWithTime];
        [_table reloadData];
        self.wh_isShowFooterPull = p.count>=PAGE_SHOW_COUNT;
    }
    [p removeAllObjects];
    
    NSMutableArray *array = [[WH_JXUserObject sharedUserInstance] WH_fetchAllFriendsFromLocal];
    for(NSInteger i = 0; i < array.count; i ++) {
        WH_JXUserObject *user = array[i];
        if ([user.userId isEqualToString:FRIEND_CENTER_USERID]) {
            continue;
        }
        WH_JXMsgAndUserObject *obj = [[WH_JXMsgAndUserObject alloc] init];
        obj.user = user;
        
        [_myFriendArray addObject:obj];
    }
    
    [g_server WH_listHisRoomWithPage:0 pageSize:1000 toView:self];
    
    [self.tableView reloadData];
}


//数据（CELL）按时间顺序重新排列
- (void)sortArrayWithTime{
    
    for (int i = 0; i<[_msgArray count]; i++)
    {
        
        for (int j=i+1; j<[_msgArray count]; j++)
        {
            WH_JXMsgAndUserObject * dicta = (WH_JXMsgAndUserObject*) [_msgArray objectAtIndex:i];
            NSDate * a = dicta.message.timeSend ;
            //            NSLog(@"a = %d",[dicta.user.msgsNew intValue]);
            WH_JXMsgAndUserObject * dictb = (WH_JXMsgAndUserObject*) [_msgArray objectAtIndex:j];
            NSDate * b = dictb.message.timeSend ;
            //                NSLog(@"b = %d",b);
            
            if ([[a laterDate:b] isEqualToDate:b])
            {
                //                - (NSDate *)earlierDate:(NSDate *)anotherDate;
                //                与anotherDate比较，返回较早的那个日期
                //
                //                - (NSDate *)laterDate:(NSDate *)anotherDate;
                //                与anotherDate比较，返回较晚的那个日期
                //                WH_JXMsgAndUserObject * dictc = dicta;
                
                [_msgArray replaceObjectAtIndex:i withObject:dictb];
                [_msgArray replaceObjectAtIndex:j withObject:dicta];
            }
            
        }
        
    }
    
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    NSMutableArray *array = [NSMutableArray array];
    switch (self.type) {
        case RelayType_msg:
            array = _msgArray;
            break;
        case RelayType_myFriend:
            array = _myFriendArray;
            break;
        case RelayType_myGroup:
            array = _myGroupArray;
            
            break;
        default:
            break;
    }
    WH_JXMsgAndUserObject *p;
    p =[array objectAtIndex:checkbox.tag % 100000-1];
    if(checked){
        BOOL flag = NO;
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            WH_JXMsgAndUserObject *selUser = _selectArr[i];
            if ([selUser.user.userId isEqualToString:p.user.userId]) {
                flag = YES;
                return;
            }
        }
        
        [_selectArr addObject:p];
    }
    else{
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            WH_JXMsgAndUserObject *selUser = _selectArr[i];
            if ([selUser.user.userId isEqualToString:p.user.userId]) {
                
                [_selectArr removeObject:selUser];
                break;
            }
        }
    }
    NSString *str =[NSString stringWithFormat:@"%@(%ld)",@"确定",_selectArr.count];
    [self.doneBtn setTitle:str forState:UIControlStateSelected];

    [self setDoneBtnFrame];
}
#pragma mark   ---------tableView协议----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != RelayType_myGroup) {
        if (indexPath.section == 0) {
            UITableViewCell *cell=nil;
            //    NSString* cellName = [NSString stringWithFormat:@"msg_%d_%ld",_refreshCount,(long)indexPath.row];
            NSString* cellName = [NSString stringWithFormat:@"tableViewCell"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.5, JX_SCREEN_WIDTH, .5)];
            line.backgroundColor = HEXCOLOR(0xf0f0f0);
            [cell.contentView addSubview:line];
            
            cell.textLabel.font = sysFontWithSize(15.0);
            if (self.type == RelayType_msg) {
                cell.textLabel.text = Localized(@"JXRelay_CreateNewChat");
            }else if (self.type == RelayType_myFriend) {
                cell.textLabel.text = Localized(@"JXRelay_chooseGroup");
            }
            
            
            return cell;
        }
    }
    
    if (self.type == RelayType_msg && self.isShare && indexPath.row == 0 && [self shouldShareToLifeCircle]) {
        UITableViewCell *cell=nil;
        NSString* cellName = [NSString stringWithFormat:@"tableViewCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.5, JX_SCREEN_WIDTH, .5)];
        line.backgroundColor = HEXCOLOR(0xf0f0f0);
        [cell.contentView addSubview:line];
        
        cell.textLabel.font = sysFontWithSize(15.0);
        cell.textLabel.text = Localized(@"JX_ShareLifeCircle");

        return cell;
    }
    
    NSString* cellName = [NSString stringWithFormat:@"relayCell"];
    WH_JX_WHCell *relayCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!relayCell) {
        relayCell = [[WH_JX_WHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    WH_JXMsgAndUserObject * obj = nil;
    switch (self.type) {
        case RelayType_msg:
            if (self.isShare && [self shouldShareToLifeCircle]) {
                obj = (WH_JXMsgAndUserObject*) [_msgArray objectAtIndex:indexPath.row - 1];
            }else {
                obj = (WH_JXMsgAndUserObject*) [_msgArray objectAtIndex:indexPath.row];
            }
            break;
        case RelayType_myFriend:
            obj = (WH_JXMsgAndUserObject*) [_myFriendArray objectAtIndex:indexPath.row];
            break;
        case RelayType_myGroup:
            obj = (WH_JXMsgAndUserObject*) [_myGroupArray objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    relayCell.title = obj.user.userNickname;
//    relayCell.subtitle = [NSString stringWithFormat:@"%@",obj.user.userId];
    relayCell.userId = [NSString stringWithFormat:@"%@",obj.user.userId];
    NSString * roomIdStr = obj.user.roomId;
    relayCell.roomId = roomIdStr;
    [relayCell WH_headImageViewImageWithUserId:relayCell.userId roomId:roomIdStr];
    relayCell.isSmall = YES;

    if (self.doneBtn && self.doneBtn.selected) {
        QCheckBox* btn = [[QCheckBox alloc] initWithDelegate:self];
        btn.frame = CGRectMake(13, 18.5, 22, 22);
        btn.tag = (indexPath.section+1) * 100000 + (indexPath.row+1);
        [relayCell addSubview:btn];
        
        
        relayCell.headImageView.frame = CGRectMake(48, relayCell.headImageView.frame.origin.y, relayCell.headImageView.frame.size.width, relayCell.headImageView.frame.size.height);
        relayCell.lbTitle.frame = CGRectMake(CGRectGetMaxX(relayCell.headImageView.frame)+14, relayCell.lbTitle.frame.origin.y, relayCell.lbTitle.frame.size.width, relayCell.lbTitle.frame.size.height);
        
        [_checkBoxs addObject:btn];
    }else {
        for (NSInteger i = 0; i < _checkBoxs.count; i ++) {
            QCheckBox *btn = _checkBoxs[i];
            [btn removeFromSuperview];
        }
        relayCell.headImageView.frame = CGRectMake(14, relayCell.headImageView.frame.origin.y, relayCell.headImageView.frame.size.width, relayCell.headImageView.frame.size.height);
        relayCell.lbTitle.frame = CGRectMake(CGRectGetMaxX(relayCell.headImageView.frame)+14, relayCell.lbTitle.frame.origin.y, relayCell.lbTitle.frame.size.width, relayCell.lbTitle.frame.size.height);
    }
    
    return relayCell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == RelayType_myGroup) {
        
        return 1;
    }else {
        return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == RelayType_myGroup) {
        return _myGroupArray.count;
    }
    
    if (section == 0) {
        
        return 1;
    }else {
        
        switch (self.type) {
            case RelayType_msg:
                if (self.isShare && [self shouldShareToLifeCircle]) {
                    return _msgArray.count + 1;
                }else {
                    return _msgArray.count;
                }
                break;
            case RelayType_myFriend:
                return _myFriendArray.count;
                break;
            case RelayType_myGroup:
                return _myGroupArray.count;
                break;
            default:
                return 0;
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.doneBtn.selected) {
        
//        QCheckBox *checkBox = nil;
//        for (NSInteger i = 0; i < _checkBoxs.count; i ++) {
//            QCheckBox *btn = _checkBoxs[i];
//            if (btn.tag / 10000 == indexPath.section && btn.tag % 10000 == indexPath.row) {
//                checkBox = btn;
//                break;
//            }
//        }
        
        WH_JX_WHCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        QCheckBox *checkBox = [cell viewWithTag:(indexPath.section + 1) * 100000 + (indexPath.row + 1)];
        if (checkBox) {
            checkBox.selected = !checkBox.selected;
            [self didSelectedCheckBox:checkBox checked:checkBox.selected];
            
            return;

        }
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        switch (self.type) {
            case RelayType_msg:{
                    self.type = RelayType_myFriend;
                }
                break;
            case RelayType_myFriend:{
                    self.type = RelayType_myGroup;
                }
                break;
            case RelayType_myGroup:{
                WH_JXMsgAndUserObject *obj = _myGroupArray[indexPath.row];
                
                self.selectIndex = indexPath.row;
                [g_server getRoom:obj.user.roomId toView:self];
            }
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }else {
        
        if (self.type == RelayType_msg && self.isShare && indexPath.row == 0 &&  [self shouldShareToLifeCircle]) {//分享到朋友圈
            
            WH_JXMessageObject *msg = self.relayMsgArray.lastObject;
            NSDictionary * msgDict = [msg.objectId mj_JSONObject];
            
            addMsgVC* vc = [[addMsgVC alloc] init];
            //在发布信息后调用，并使其刷新
            vc.block = ^{
//                [self WH_scrollToPageUp];
            };
            if (self.isSDKShare) {
                [self handleBLNShareUrl:vc];
            }else {
                vc.wh_shareUr = [msgDict objectForKey:@"url"];
                vc.wh_shareTitle = [msgDict objectForKey:@"title"];
                vc.wh_shareIcon = [msgDict objectForKey:@"imageUrl"];
                vc.dataType = weibo_dataType_share;
                vc.delegate = self;
            }
            [g_navigation pushViewController:vc animated:YES];
            vc.view.hidden = NO;
            
            [self actionQuit];
            
            return;
        }
        
        
        NSMutableArray *array = [NSMutableArray array];
        switch (self.type) {
            case RelayType_msg:
                array = _msgArray;
                break;
            case RelayType_myFriend:
                array = _myFriendArray;
                break;
            case RelayType_myGroup:
                array = _myGroupArray;
                
                break;
            default:
                break;
        }
        WH_JXMsgAndUserObject *p;
        if (self.type == RelayType_msg && self.isShare && [self shouldShareToLifeCircle]) {
            p = [array objectAtIndex:indexPath.row - 1];
        }else {
            p =[array objectAtIndex:indexPath.row];
        }
        p.user.msgsNew = [NSNumber numberWithInt:0];
        [p.user update];
        [p.message WH_updateNewMsgsTo0];
        
        
        if ([p.user.roomFlag boolValue]) {
            
            self.selectIndex = indexPath.row;
            [g_server getRoom:p.user.roomId toView:self];
            return;
        }
        
        
        if (self.isCourse) {
            if([p.user.roomFlag boolValue]) {
                self.selectIndex = indexPath.row;
                [g_server getRoom:p.user.roomId toView:self];
            }else {
                if ([self.relayDelegate respondsToSelector:@selector(relay:MsgAndUserObject:)]) {
                    [self.relayDelegate relay:self MsgAndUserObject:p];
                    
                    [self actionQuit];
                }
            }
            
            return;
        }
        
        [self sendRelayMsg:p];
    }
    
}
#pragma mark ----- 数据处理
- (BOOL)shouldShareToLifeCircle {
    NSDictionary *infoDic = [self getBlnShareUrlDic];
    if (self.isSDKShare && [infoDic[@"type"] integerValue] == 7) {
        return NO;
    }
    return YES;
}
- (NSDictionary *)getBlnShareUrlDic {
    NSString *urlString = self.shareUrl.absoluteString.stringByRemovingPercentEncoding;
    NSRange range = [urlString rangeOfString:@"BLN/"];
    if (range.location != NSNotFound) {
        NSString *contentString = [urlString substringFromIndex:(range.location + range.length)];
        NSDictionary *infoDic = [contentString.stringByRemovingPercentEncoding mj_JSONObject];
        return infoDic;
    }
    return nil;
}

- (void)handleBLNShareUrl:(addMsgVC *)msgVC {
    NSDictionary *infoDic = [self getBlnShareUrlDic];
    if (infoDic == nil) {
        return;
    }
    NSInteger type = [infoDic[@"type"] integerValue];
    //        vc.shareTitle = [msgDict objectForKey:@"title"];
    //        vc.shareIcon = [msgDict objectForKey:@"imageUrl"];
    if (type == 2) {//分享文字时需要将类型设置为图文分享
        msgVC.wh_urlShare = infoDic[@"content"];
        msgVC.dataType = weibo_dataType_image;
    }else if (type == 3) {//image
        msgVC.wh_shareUr = infoDic[@"content"];
        msgVC.dataType = weibo_dataType_image;
    }else if (type == 4) {//Link
        NSDictionary *linkDic = [infoDic[@"content"] mj_JSONObject];
        msgVC.wh_urlShare = linkDic[@"url"];
        msgVC.wh_shareIcon = linkDic[@"img"];
        msgVC.wh_shareTitle = linkDic[@"title"];
        msgVC.dataType = weibo_dataType_share;
    }else  if (type == 5) {//audio
        msgVC.wh_audioFile = infoDic[@"content"];
        msgVC.dataType = weibo_dataType_audio;
    }else  if (type == 6) {//video
        msgVC.wh_shareUr = infoDic[@"content"];
        msgVC.dataType = weibo_dataType_video;
    }else  if (type == 7) {//file
        msgVC.wh_shareUr = infoDic[@"content"];
        msgVC.dataType = weibo_dataType_file;
    }
    msgVC.delegate = self;
}
- (void)sendRelayMsg:(WH_JXMsgAndUserObject *)p {
    
    [g_notify postNotificationName:kActionRelayQuitVC_WHNotification object:nil];
    
    WH_JXChat_WHViewController *sendView=[WH_JXChat_WHViewController alloc];
    sendView.title = p.user.userNickname;
    if([p.user.roomFlag intValue] > 0  || p.user.roomId.length > 0){
        if(g_xmpp.isLogined != 1){
            // 掉线后点击title重连
            [g_xmpp showXmppOfflineAlert];
            return;
        }
        
        
        if ([p.user.groupStatus intValue] == 1) {
            [g_server showMsg:Localized(@"JX_OutOfTheGroup1")];
            return;
        }
        
        if ([p.user.groupStatus intValue] == 2) {
            [g_server showMsg:Localized(@"JX_DissolutionGroup1")];
            return;
        }
        sendView.roomJid = p.user.userId;
        sendView.roomId   = p.user.roomId;
        sendView.chatRoom  = [[JXXMPP sharedInstance].roomPool joinRoom:p.user.userId title:p.user.userNickname isNew:NO];
        
        if (p.user.roomFlag) {
            NSDictionary * groupDict = [p.user toDictionary];
            WH_RoomData * roomdata = [[WH_RoomData alloc] init];
            [roomdata WH_getDataFromDict:groupDict];
            sendView.room = roomdata;
        }
    }
    sendView.isShare = self.isShare;
    sendView.shareSchemes = self.shareSchemes;
    sendView.shareUrl = self.shareUrl;
    sendView.chatPerson = p.user;
    sendView = [sendView init];
    //        [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.relayMsgArray = self.relayMsgArray;
    sendView.view.hidden = NO;
    
    [self actionQuit];
}

-(void)showChatView:(NSInteger)index{
    [_wait stop];
    WH_JXMsgAndUserObject *obj = _myGroupArray[index];
    
    if (self.isCourse) {
        self.selectIndex = index;
        [g_server getRoom:obj.user.roomId toView:self];
        return;
    }
    
    WH_JXChat_WHViewController *sendView=[WH_JXChat_WHViewController alloc];
    sendView.title = obj.user.userNickname;
    sendView.roomJid = obj.user.userId;
    sendView.roomId = obj.user.roomId;
    sendView.chatRoom = _chatRoom;
    sendView.chatPerson = obj.user;
    
    sendView = [sendView init];
//    [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.relayMsgArray = self.relayMsgArray;
    
    [self actionQuit];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    
    [self WH_stopLoading];
    if([aDownload.action isEqualToString:wh_act_roomListHis] ){
        [_myGroupArray removeAllObjects];
        for (int i = 0; i < [array1 count]; i++) {
            NSDictionary *dict=array1[i];
            
            WH_JXUserObject* user = [[WH_JXUserObject alloc]init];
            user.userNickname = [dict objectForKey:@"name"];
            user.userId = [dict objectForKey:@"jid"];
            user.userDescription = [dict objectForKey:@"desc"];
            user.roomId = [dict objectForKey:@"id"];
            
            WH_JXMsgAndUserObject *obj = [[WH_JXMsgAndUserObject alloc] init];
            obj.user = user;
            [_myGroupArray addObject:obj];
            
        }
        
    }
    if( [aDownload.action isEqualToString:wh_act_roomGet] ){
        
        WH_JXUserObject* user = [[WH_JXUserObject alloc]init];
        [user WH_getDataFromDict:dict];
        
        NSDictionary * groupDict = [user toDictionary];
        WH_RoomData * roomdata = [[WH_RoomData alloc] init];
        [roomdata WH_getDataFromDict:groupDict];
        
        [roomdata WH_getDataFromDict:dict];
        
        memberData *data = [roomdata getMember:g_myself.userId];
        if ([user.talkTime longLongValue] > 0 && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
            return;
        }
        
        if (!roomdata.allowSpeakCourse && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"JX_SendLecture")];
            return;
        }
        
        if (!roomdata.allowSendCard && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"JX_DisabledShowCard")];
            return;
        }
        NSMutableArray *array = [NSMutableArray array];
        switch (self.type) {
            case RelayType_msg:
                array = _msgArray;
                break;
            case RelayType_myFriend:
                array = _myFriendArray;
                break;
            case RelayType_myGroup:
                array = _myGroupArray;
                
                break;
            default:
                break;
        }
        WH_JXMsgAndUserObject *p=[array objectAtIndex:self.selectIndex];
        
        if (self.isCourse) {
            if ([data.role integerValue] == 1 || [data.role integerValue] == 2 || roomdata.allowSpeakCourse) {
                if ([user.talkTime longLongValue] > 0) {
                    
                    [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
                    return;
                }
                if ([self.relayDelegate respondsToSelector:@selector(relay:MsgAndUserObject:)]) {
                    
                    
                    
                    [self.relayDelegate relay:self MsgAndUserObject:p];
                    
                    [self actionQuit];
                }
                return;
            }
            [g_App showAlert:Localized(@"JX_SendLecture")];
        }else {
            [self sendRelayMsg:p];
        }
        
        
    }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}

- (void)actionQuit {
    if (self.isShare) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.isUrl) {
        [self.view removeFromSuperview];
    }
    else {
        [super actionQuit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)sp_getLoginState:(NSString *)mediaInfo {
    NSLog(@"Get Info Failed");
}
@end
