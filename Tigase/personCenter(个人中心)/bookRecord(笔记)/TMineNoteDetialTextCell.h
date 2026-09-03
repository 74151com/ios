//
//  TMineNoteDetialTextCell.h
//  Tigase
//
//  Created by os on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMineNoteDetialTextCell : UITableViewCell

@property(nonatomic,copy) NSString* titleStr;
@property(nonatomic,copy) NSString* contentStr;

- (void)setData:(NSString *)titleStr contentStr:(NSString *)contentStr;
@end

NS_ASSUME_NONNULL_END
