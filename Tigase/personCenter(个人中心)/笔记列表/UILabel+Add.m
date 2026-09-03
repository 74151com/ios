//
//  UILabel+Add.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "UILabel+Add.h"
#import "TUtils.h"

@implementation UILabel (Add)
/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 */
- (void)setSubStringCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    NSString *totalString = [TUtils isEmptyString:totalStr]?@"":totalStr;
    totalString = [totalString stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    self.attributedText = attributedStr;
}

/**
 *  更改行间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *
 */
- (void)setLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    NSString *totalStr = [TUtils isEmptyString:totalString]?@"":totalString;
    totalStr = [totalStr stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
    self.attributedText = attributedStr;
}

/**
 * 改变某些文本的颜色和行间距
 * @param color         需要变成的颜色
 * @param totalStr      总的字符串
 * @param subArray      需要改变颜色的文字数组  也可以传总的字符串
 * @param lineSpace     行间距
 */
- (void)setLineSpaceAndSubStringColorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray LineSpace:(CGFloat)lineSpace {
    NSString *totalStrString = [TUtils isEmptyString:totalStr]?@"":totalStr;
    totalStrString = [totalStrString stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStrString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStrString length])];
    
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalStrString rangeOfString:rangeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    self.attributedText = attributedStr;
}

/**
 * 改变某些文本的颜色和行间距,字体
 * @param color         需要变成的颜色
 * @param font          需要变成的字体
 * @param totalStr      总的字符串
 * @param subArray      需要改变颜色的文字数组  也可以传总的字符串
 * @param lineSpace     行间距
 */
- (void)setLineSpaceAndSubStringColorWithColor:(UIColor *)color font:(UIFont *)font TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray LineSpace:(CGFloat)lineSpace {
    NSString *totalStrString = [TUtils isEmptyString:totalStr]?@"":totalStr;
    totalStrString = [totalStrString stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStrString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStrString length])];
    
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalStrString rangeOfString:rangeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    self.attributedText = attributedStr;
}
@end
