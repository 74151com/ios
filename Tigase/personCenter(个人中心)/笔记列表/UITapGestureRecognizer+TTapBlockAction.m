//
//  UITapGestureRecognizer+TTapBlockAction.m
//  tio-chat-ios
//
//  Created by wuxiaofang on 2023/3/24.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "UITapGestureRecognizer+TTapBlockAction.h"
#import <objc/runtime.h>

static NSString* actionKey = @"tap_actionKey";
@implementation UITapGestureRecognizer(TTapBlockAction)

+ (instancetype)initTapGestureWithActionBlock:(TTapGestureBlock)action {
    UITapGestureRecognizer *gesture = [[self alloc] initWithTarget:nil action:nil];
    [gesture addTarget:gesture action:@selector(block_invoke)];
    gesture.tap_block_action = action;
    return gesture;
}

- (void)block_invoke {
    if(self.tap_block_action){
        self.tap_block_action(self);
    }
}

- (TTapGestureBlock)tap_block_action {
    return objc_getAssociatedObject(self, &actionKey);
}

- (void)setTap_block_action:(TTapGestureBlock)action {
    objc_setAssociatedObject(self, &actionKey, action, OBJC_ASSOCIATION_COPY);
}

@end
