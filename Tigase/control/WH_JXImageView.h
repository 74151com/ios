//
//  WH_JXImageView.h
//  textScr
//
//  Created by JK PENG on 11-8-17.
//  Copyright 2011年 Devdiv. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WH_JXImageView_Animation_None 0 //无动画
#define WH_JXImageView_Animation_Line 1 //渐变
#define WH_JXImageView_Animation_More 2 //多变

@class WH_JXImageView;
@protocol WH_JXImageViewPanDelegate <NSObject>

- (void)tapImageView:(WH_JXImageView *)imageView;

- (void)changeWhenPan:(WH_JXImageView *)sender gesture:(UILongPressGestureRecognizer *)gesture;

- (void)getTouchWhenMove:(WH_JXImageView *)imageView withTouch:(NSSet *)touch withEvent:(UIEvent *)event withLongPressGes:(UILongPressGestureRecognizer *)lpGes;

@end

@interface WH_JXImageView : UIImageView {
    int         _oldAlpha;
    BOOL        _canChange;
}
//为了先获取图片Size,后设置WH_JXImageView大小，专设的变量
@property (nonatomic) CGSize imageSize;

@property (nonatomic, weak) NSObject* wh_delegate;
@property (nonatomic, assign) SEL		didTouch;
@property (nonatomic, assign) SEL		wh_didDragout;
@property (nonatomic, assign) BOOL      wh_changeAlpha;
@property (nonatomic, assign) BOOL      wh_selected;
@property (nonatomic, assign) BOOL      wh_enabled;
@property (nonatomic, assign) int       wh_animationType;//动画类型，0:没有；1:渐变；2:多变
@property (nonatomic, strong) id wh_object;

@property (nonatomic, strong) NSIndexPath *idxPath;

@property (nonatomic,weak) id<WH_JXImageViewPanDelegate> panDelegate;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

//编辑时候显示的图片
@property (nonatomic, copy) NSString *ourlEdit;
- (void)addTapGesture;
- (void)addLongPressGesture;
@end
