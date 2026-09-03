//
//  JXCertificationVC.h
//  shiku_im
//
//  Created by IMAC on 2020/3/23.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "WH_admob_WHViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCertificationVC : WH_admob_WHViewController
@property(nonatomic, copy) void (^certificeSuccess)();
@end

NS_ASSUME_NONNULL_END
