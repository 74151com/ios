//
//  JXPhotoAddressBook.h
//  Tigase_imChatT
//
//  Created by p on 2017/4/14.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXAddressBook : NSObject

@property (nonatomic, strong) NSMutableArray *phoneNameArr;

@property (nonatomic, strong) NSArray *locPhoneNums;
@property (nonatomic, strong) NSDictionary *addressBookDic;

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, strong) NSNumber *registerEd;
@property (nonatomic, strong) NSDate *registerTime;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *toTelephone;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, copy) NSString *addressBookName;

@property (nonatomic, strong) NSNumber *isRead;

@property (nonatomic, copy) NSString *tableName;

+(JXAddressBook*)sharedInstance;

//数据库增删改查
-(BOOL)insert;
-(BOOL)delete;
-(BOOL)update;

// 查询未读消息
-(NSMutableArray *)doFetchUnread;
// 将未读消息设置为已读
- (BOOL)updateUnread;

// 获取通讯录
- (NSDictionary *) getMyAddressBook;
// 上传手机通讯录联系人
- (void) uploadAddressBookContacts;
// 获取所有手机联系人用户
- (NSMutableArray *)fetchAllAddressBook;




/**
 * Strong
 */
@property (nonatomic, strong) NSString *keyUDid;

/**
 本方法是得到 UUID 后存入系统中的 keychain 的方法
 不用添加 plist 文件
 程序删除后重装,仍可以得到相同的唯一标示
 但是当系统升级或者刷机后,系统中的钥匙串会被清空,此时本方法失效
 */
+(NSString *)getDeviceIDInKeychain;
@end
