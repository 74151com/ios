//
//  TUtils.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/12.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TUtils.h"

@implementation TUtils

+ (NSString *)getAppName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    CFShow((__bridge CFTypeRef)(infoDictionary));

    // app名称

    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    return app_Name;
}

/**
 获取当前版本号
 */
+(NSString *)getCurrentVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    CFShow((__bridge CFTypeRef)(infoDictionary));

    // app名称

    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    return app_Version;
}

/**
 判断字符串是否为空
*/
+ (BOOL) isEmptyString:(NSString *)string {

    if (string == nil || string == NULL) {

        return YES;

    }

    if ([string isKindOfClass:[NSNull class]]) {

        return YES;

    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

        return YES;

    }

    return NO;

}

//字母
+ (BOOL)cdm_isOnlyLetters:(NSString *)pwd {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([pwd rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

//数字
+ (BOOL)cdm_isOnlyNumbers:(NSString *)pwd {
    NSCharacterSet *numSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([pwd rangeOfCharacterFromSet:numSet].location == NSNotFound);
}

//字母和数字
+ (BOOL)cdm_isOnlyAlphaNumeric:(NSString *)pwd {
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([pwd rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}
@end
