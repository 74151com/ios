//
//  IWTitleButton.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWTitleButton.h"
//#import "UIImage+Tint.h"

#define IWTitleButtonImageW 20

@implementation IWTitleButton

+ (instancetype)titleButton
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 背景
       // [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW =  contentRect.size.width-IWTitleButtonImageW*2-14;
    CGFloat imageX = (contentRect.size.width - imageW)/2.0;
    CGFloat imageH = contentRect.size.width - IWTitleButtonImageW;// contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height-IWTitleButtonImageW-9;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width ;
    CGFloat titleH = IWTitleButtonImageW;//contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    // 根据title计算自己的宽度
    CGFloat titleW = [title sizeWithFont:self.titleLabel.font].width;
    
    CGRect frame = self.frame;
    frame.size.width = titleW + IWTitleButtonImageW + 5;
    self.frame = frame;
    
    [super setTitle:title forState:state];
}

@end
