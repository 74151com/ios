//
//  MiXin_PSRegisterBase_MiXinVC.h
//  wahu_im
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "WH_admob_WHViewController.h"
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface WH_PSRegisterBaseVC : WH_admob_WHViewController<PHPhotoLibraryChangeObserver>


@property (nonatomic, strong) PHFetchResult<PHAsset *> *allPhotos;
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *smartAlbums;
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *userCollections;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;


@property (nonatomic,strong) dispatch_source_t timer;


/**
 * 地理编码
 */
@property (strong, nonatomic)  CLGeocoder *geocder;

@property (strong, nonatomic)  CLLocationManager *locationManager;

/** NSString *Xlatitude  ;
   NSString *Ylongitude  */
@property(nonatomic,copy)NSString *Xlatitude;
@property(nonatomic,copy)NSString *Ylongitude;


@property (nonatomic,strong) NSString *resumeId;
@property (nonatomic,strong) WH_JXUserObject *user;
@property (nonatomic,assign) BOOL isSmsRegister;
@property (nonatomic, assign) BOOL isBindPhonePws;
@property (nonatomic ,strong) NSString *inviteCode; //!< 邀请码
@property (nonatomic, strong) NSNumber *iswWxinLogin; //1.微信。2.qq
@property (nonatomic, assign) NSInteger registType; //!< 0 手机号; 1用户名
@property (nonatomic, strong) NSString *smsCode; //!< 短信验证码
@end
