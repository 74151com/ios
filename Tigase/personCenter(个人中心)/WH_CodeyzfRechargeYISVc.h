//
//  WH_CodeyzfRechargeYISVc.h
//  Tigase
//
//  Created by os on 2023/10/16.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_CodeyzfRechargeYISVc : WH_admob_WHViewController

@property (nonatomic, copy) NSString *code_url;
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *h5_qrurl;
@property (nonatomic, assign) int payType;
@property (nonatomic, copy) NSString *money;
@end

NS_ASSUME_NONNULL_END
