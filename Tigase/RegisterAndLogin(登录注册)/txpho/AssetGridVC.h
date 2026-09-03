//
//  AssetGridVC.h
//  SamplePhotosDemo
//
//  Created by iTruda on 2018/6/18.
//  Copyright © 2018年 iTruda. All rights reserved.
//
#define self_width self.view.frame.size.width   //self.view宽度
#define self_height self.view.frame.size.height //self.view高度
 

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]  //RGB颜色

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface AssetGridVC : UIViewController
<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHFetchResult<PHAsset *> *allPhotos;
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *smartAlbums;
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *userCollections;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;


@property (nonatomic,strong) dispatch_source_t timer;

@property (strong, nonatomic) UILabel *shouShopAddr;
@property (strong, nonatomic) UITextField *tf_shouShopAddr;

@property (strong, nonatomic) UILabel *companyShouShop;
@property (strong, nonatomic) UITextField *tf_Coder;


@property (strong, nonatomic) UILabel *inviteCode;
@property (strong, nonatomic) UITextField *tf_inviteCode;


@property (strong, nonatomic) UIButton *tf_companyId;



/**
 * 地理编码
 */
@property (strong, nonatomic)  CLGeocoder *geocder;

@property (strong, nonatomic)  CLLocationManager *locationManager;

/** NSString *Xlatitude  ;
   NSString *Ylongitude  */
@property(nonatomic,copy)NSString *Xlatitude;
@property(nonatomic,copy)NSString *Ylongitude;
@end
