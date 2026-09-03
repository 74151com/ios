//
//  UILabel+Add.h
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Add)
/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *
 */
- (void)setSubStringCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;

/**
 *  更改行间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *
 */
- (void)setLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace;

/**
 * 改变某些文本的颜色和行间距
 * @param color         需要变成的颜色
 * @param totalStr      总的字符串
 * @param subArray      需要改变颜色的文字数组  也可以传总的字符串
 * @param lineSpace     行间距
 */
- (void)setLineSpaceAndSubStringColorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray LineSpace:(CGFloat)lineSpace;

/**
 * 改变某些文本的颜色和行间距,字体
 * @param color         需要变成的颜色
 * @param font          需要变成的字体
 * @param totalStr      总的字符串
 * @param subArray      需要改变颜色的文字数组  也可以传总的字符串
 * @param lineSpace     行间距
 */
- (void)setLineSpaceAndSubStringColorWithColor:(UIColor *)color font:(UIFont *)font TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray LineSpace:(CGFloat)lineSpace;
@end

NS_ASSUME_NONNULL_END
