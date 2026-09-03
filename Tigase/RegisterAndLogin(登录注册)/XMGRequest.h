//
//  Request.h
//  theSecondObject
//
//  Created by mac on 16/3/23.
//  Copyright (c) 2016年 zhubingfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMGRequest.h"
#import <Photos/Photos.h>

@interface XMGRequest : NSObject


+(instancetype)sharedAccountModel;
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
+ (void)PostBody2:(NSString *)url parameter:(NSMutableDictionary *)para success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+(void)postBody:(NSString *)url parameter:(NSDictionary *)para success:(void (^)(id responseObject))success failure:(void (^)(NSError *err))failure;

+ (void)Get:(NSString *)url
  parameter:(NSDictionary *)para
    success:(void(^)(id responseObject))success
    failure:(void(^)(NSError *error))failure;
+ (void)Post:(NSString *)url
   parameter:(NSMutableDictionary *)para
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError *error))failure;

/** 上传文件*/
+ (void)uploadFilePost:(NSString *)url
             parameter:(NSMutableDictionary *)para
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

/**
 @* 
 @*   XML 解析网络请请求
 @*
 @* http://appleapp.xiangzhuankecheng.com:8099/Service.asmx
 @* <param name="typeid">类型：1-提交推广图片；2-微信二维码</param>
 @* <param name="data">文件内容：base64</param>
 @* <param name="fileType">文件后缀名：png,jpg</param>
 */

+ (void)postXMLWebServiceConnectionNameSpace:(NSString *)nameSpace withUrlStr:(NSString *)urlStr withMethod:(NSString *)method imgData:(NSString *)base64 success:(void(^)(id responseObject))success  failure:(void(^)(NSError *error))failure;

/**
 @*
 @*   XML 解析网络请请求
 @*
 */
+ (void)postXMLWebServiceParams:(NSString *)urlStr typeid:(NSInteger )typeidc fileType:(NSString *)method imgData:(NSString *)base64 success:(void(^)(id responseObject))success  failure:(void(^)(NSError *error))failure;



/** 获取激活的状态码*/
+(NSString *)getActiveStatus;
/** 获取手机的UDID*/
+(NSString *)getUDID;


- (PHAssetCollection *)collection;

-(void)saveImage;

/** 时间转化成时间粗*/
+(NSString *)getTimestampFromTime:(NSString *)check_time;

/** 图片压缩系数比例*/
+(NSData *)ImageZipNSDataWithImage:(UIImage *)sourceImage;

/** 时间搓 转换为时间 */
+(NSString *)getTimeStamp_Cover_Time:(NSString *)timeStr;


/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;

+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(void (^)(NSDictionary  *responseObject))success failure:(void (^)(NSError *error))failure;
@end
