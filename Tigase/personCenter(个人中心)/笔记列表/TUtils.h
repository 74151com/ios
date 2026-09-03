//
//  TUtils.h
//  tio-chat-ios
//
//  Created by apple on 2023/3/12.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUtils : NSObject

/*
 获取app名称
 */
+(NSString *)getAppName;

/**
 获取当前版本号
 */
+(NSString *)getCurrentVersion;

/**
 判断字符串是否为空
 */
+ (BOOL) isEmptyString:(NSString *)string;


//字母
+ (BOOL)cdm_isOnlyLetters:(NSString *)pwd;

//数字
+ (BOOL)cdm_isOnlyNumbers:(NSString *)pwd;

//字母和数字
+ (BOOL)cdm_isOnlyAlphaNumeric:(NSString *)pwd;
@end

NS_ASSUME_NONNULL_END
