//
//  TPengyouquanListModel.h
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <Foundation/Foundation.h> 

NS_ASSUME_NONNULL_BEGIN

// 图片数组
@interface TPengyouquanPicModel : NSObject
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@end
@interface TPengyouquanPraisesModel : NSObject
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *uid;
@end

// 是否点赞和点赞数
@interface TPengyouquanLikeModel : NSObject
@property (nonatomic, assign) BOOL isliked;
@property (nonatomic, assign) int likenum;
@end

// 二级评论
@interface TPengyouquanCommentChildModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) long uid;
@property (nonatomic, assign) long touid;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *fromnick;
@property (nonatomic, copy) NSString *tonick;
@property (nonatomic, copy) NSString *info;
@end

// 一级评论
@interface TPengyouquanCommentListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) long uid;
@property (nonatomic, assign) long touid;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *fromnick;
@property (nonatomic, copy) NSString *tonick;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *toNickname;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, strong) NSArray<TPengyouquanCommentChildModel *> *childList;

/*
 
 "body": "今天下午吃个",
            "commentId": "655f5be0d88ea00cf1d3c8c6",
            "msgId": "655f4700d88ea00cf1d3c6fa",
            "nickname": "客服公众号",
            "time": 1700748256,
            "toNickname": "8888",
            "toUserId": 10000187,
            "userId": 10000
 */

@end

// 朋友圈列表
@interface TPengyouquanListModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) long uid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) int praiseNum;
@property (nonatomic, assign)int isPraise;
 

@property (nonatomic, strong) NSArray<TPengyouquanPraisesModel *> *praises;
// 0 文本 1 图片 2 视频
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, strong) TPengyouquanLikeModel *likeMap;
// 图片数组
@property (nonatomic, strong) NSArray<TPengyouquanPicModel *> *fileUrls;
@property (nonatomic, strong) NSArray  *videoUrls;
// 视频地址
@property (nonatomic, copy) NSString *videourl; 


// 评论

@property (nonatomic, strong) NSArray<TPengyouquanCommentListModel *> *comments;


/**
 朋友圈列表主页
 */
+(void)requestPengyouquanListWithBlock:(void(^)(int code, NSArray *findList , NSString *errorMsg))block withParams:(NSDictionary *)params;

/**
 朋友圈上传图片
 */
+(void)requestPengyouquanUploadPicWithBlock:(void(^)(int code, NSString *urlString , NSString *errorMsg))block withParams:(NSDictionary *)params;

/**
 朋友圈上传视频
 */
+ (void)requestPengyouquanUploadVideoWithBlock:(void (^)(int code, NSString *urlString , NSString *errorMsg))block withParams:(NSDictionary *)params;

/**朋友圈发布**/
+ (void)requestPengyouquanPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**朋友圈点赞或取消点赞**/
+ (void)requestPengyouquanAddOrCancelLikeWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params withUrlString:(NSString *)urlString;;

/**朋友圈删除**/
+ (void)requestPengyouquanDeleteWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**朋友圈举报**/
+ (void)requestPengyouquanReportWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**朋友圈详情**/
+ (void)requestPengyouquanDetailByIdWithBlock:(void (^)(int code, TPengyouquanListModel *model, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**朋友圈评论**/
+ (void)requestPengyouquanAddCommentWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

+ (void)requestBookChatPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;


/**
 更新笔记
 */
+ (void)requestBookUpdatePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;
/**
 删除笔记
 */
+ (void)requestBookDeletePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**
 笔记详情
 */
+ (void)requestBookDetailPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

/**
 笔记列表
 */
+ (void)requestBookNoteListPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;


/**
 搜藏笔记
 */
+ (void)requestBookFavoritePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
