//
//  WH_JXImageView.m
//  textScr
//
//  Created by JK PENG on 11-8-17.
//  Copyright 2011年 Devdiv. All rights reserved.
//

#import "WH_JXImageView.h"
//遵循协议－－
@interface WH_JXImageView () <UIGestureRecognizerDelegate, CAAnimationDelegate>

@property (nonatomic, assign) BOOL wh_isAction;  //防止重复点击

@property (nonatomic, strong) UIImageView *mHeaderIV;
@end


@implementation WH_JXImageView
@synthesize wh_delegate;
@synthesize didTouch;
@synthesize wh_changeAlpha;
@synthesize wh_animationType;
@synthesize wh_selected;
@synthesize wh_enabled;

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setupUI];
        [self doSet];
    }
    return self;
}
#pragma mark 初始化视图
-(void)setupUI {
    
    [self addSubview:self.mHeaderIV];
    [self.mHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-15);
        make.width.height.mas_equalTo(30);
    }];
}
-(UIImageView *)mHeaderIV {
    if (!_mHeaderIV) {
        _mHeaderIV = [[UIImageView alloc] init];
        _mHeaderIV.contentMode = UIViewContentModeScaleAspectFill;
        _mHeaderIV.clipsToBounds = true;
        _mHeaderIV.layer.cornerRadius = 5;
        _mHeaderIV.layer.masksToBounds = true;
        _mHeaderIV.hidden = YES;
        _mHeaderIV.image = [UIImage imageNamed:@"playAudio"];
       // UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mHeaderIVGestureRecognizerAction:)];
        _mHeaderIV.userInteractionEnabled = YES;
       // [_mHeaderIV addGestureRecognizer:tap];
    }
    return _mHeaderIV;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doSet];
    }
    return self;
}

-(void)doSet{
    _canChange = NO;
    wh_selected    = NO;
    wh_enabled     = NO;
    _wh_isAction = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
    //[super touchesBegan: touches withEvent: event];
    if(_canChange && wh_changeAlpha)
        self.alpha = 0.5;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesMoved");
    [super touchesMoved: touches withEvent: event];
    
    if ([self.panDelegate respondsToSelector:@selector(getTouchWhenMove:withTouch:withEvent:withLongPressGes:)]) {
        [self.panDelegate getTouchWhenMove:self withTouch:touches withEvent:event withLongPressGes:self.longPress];
    }
    
}
- (void)setOurlEdit:(NSString *)ourlEdit{
    _ourlEdit = ourlEdit;
    _mHeaderIV.hidden = YES;
    if([ourlEdit hasSuffix:@".mp4"]) {//判断是否是视频链接
        [FileInfo getFirstImageFromVideo:ourlEdit imageView:self];
        _mHeaderIV.hidden = NO;;
    }else if (isFileExist(ourlEdit)){//判断是否是本地路径
        [FileInfo getFirstImageFromVideo:ourlEdit imageView:self];
        _mHeaderIV.hidden = NO;;
    }else {//fileName既不是有效的网路路径，也不是本地路径，只能从content中取值
       [self sd_setImageWithURL:[NSURL URLWithString:ourlEdit]];
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    [super touchesEnded: touches withEvent: event];
    if(_canChange)
        self.alpha = 1;
    if (_wh_isAction) {
        return;
    }
    self.wh_isAction = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.wh_isAction = NO;
    });
    
    BOOL inside = YES;
    for(int i=0;i<[touches count];i++){
        CGPoint p = [[[touches allObjects] objectAtIndex:i] locationInView:self];
        NSLog(@"%d=%f,%f",i,p.x,p.y);
        if(p.x<0 || p.y <0){
            inside = NO;
            break;
        }
        if(p.x>self.frame.size.width || p.y>self.frame.size.height){
            inside = NO;
            break;
        }
    }
    if(!inside){
        if(self.wh_delegate != nil && [self.wh_delegate respondsToSelector:self.wh_didDragout])
            [self.wh_delegate performSelectorOnMainThread:self.wh_didDragout withObject:self waitUntilDone:NO];
        return;
    }
    if(self.wh_delegate != nil && [self.wh_delegate respondsToSelector:self.didTouch]){
        [self.wh_delegate performSelectorOnMainThread:self.didTouch withObject:self waitUntilDone:NO];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesCancelled: touches withEvent: event];
//    NSLog(@"touchesCancelled");
    if(_canChange)
        self.alpha = 1;
    for(int i=0;i<[touches count];i++){
        [[[touches allObjects] objectAtIndex:i] locationInView:self];
//        NSLog(@"%d=%f,%f",i,p.x,p.y);
    }
}

- (void)dealloc
{
    wh_delegate = nil;
    didTouch = nil;
//    [super dealloc];
}

-(void)setImage:(UIImage *)image{
    switch (self.wh_animationType) {
        case WH_JXImageView_Animation_More:
            [self addAnimationPage:2];
            break;
        case WH_JXImageView_Animation_Line:
            [self addAnimation:WH_showImage_time];
            break;
        default:
            break;
    }
    
    
    [super setImage:image];
}

-(void)addAnimation:(int)nTime
{
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = nTime;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	transition.type = kCATransitionFade;
	transition.delegate = self;
	
	[self.layer addAnimation:transition forKey:nil];
}

-(void)addAnimationPage:(int)nTime{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = nTime;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
    NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight};
    int rnd = random() % 4;
    transition.type = types[rnd];
    if(rnd < 3) // if we didn't pick the fade transition, then we need to set a subtype too
    {
        transition.subtype = subtypes[random() % 2];
    }
	
	transition.delegate = self;
	[self.layer addAnimation:transition forKey:nil];
}

-(void)setDidTouch:(SEL)value{
    if(value){
        didTouch = value;
        _canChange = YES;
        self.userInteractionEnabled = YES;
        wh_changeAlpha = YES;
    }
}


- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSave:)];
    [tap requireGestureRecognizerToFail:self.longPress];
    [self addGestureRecognizer:tap];
}
- (void)addLongPressGesture{
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSave:)];
    self.longPress.cancelsTouchesInView = NO;
    [self addGestureRecognizer:self.longPress];
}
- (void)tapSave:(UITapGestureRecognizer *)tap{
    if ([self.panDelegate respondsToSelector:@selector(tapImageView:)]) {
        [self.panDelegate tapImageView:self];
    }
}
- (void)longPressSave:(UILongPressGestureRecognizer *)gesture{
    self.highlighted = YES;
    if ([self.panDelegate respondsToSelector:@selector(changeWhenPan: gesture:)]) {
        [self.panDelegate changeWhenPan:self gesture:gesture];
    }
}


@end
