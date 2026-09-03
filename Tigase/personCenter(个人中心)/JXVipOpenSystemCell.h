//
//  JXVipOpenSystemCell.h
//  shiku_im
//
//  Created by os on 2023/5/17.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXVipOpenSystemCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *music;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
