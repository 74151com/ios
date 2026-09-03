//
//  Request.m
//  theSecondObject
//
//  Created by mac on 16/3/23.
//  Copyright (c) 2016年 zhubingfeng. All rights reserved.
//

#import "XMGRequest.h"
#import "AFNetworking.h"
#import "KeychainUUID.h"
#import <Security/Security.h> 


extern NSString *CTSettingCopyMyPhoneNumber(void);


NSString * const KEY_UDID_INSTEAD = @"com.zuanshi.udid.test";
/** 相册名字 */
static NSString * const XMGCollectionName = @"超级客源";


@implementation XMGRequest

+(instancetype)sharedAccountModel{
    static XMGRequest *_sharedAccountModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountModel = [[XMGRequest alloc] init];
    });
    return _sharedAccountModel;
}

//原始尺寸
static CGRect oldframe;

-(NSString *)keyUDid{
    
    KeychainUUID *keychain = [[KeychainUUID alloc] init];
    id data = [keychain readUDID];
    

    return data;
}


+(NSString *)getDeviceIDInKeychain
{
    NSString *getUDIDInKeychain = (NSString *)[XMGRequest load:KEY_UDID_INSTEAD];
    NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        NSLog(@"\n \n \n _____重新存储 UUID _____\n \n \n  %@",result);
        [XMGRequest save:KEY_UDID_INSTEAD data:result];
        getUDIDInKeychain = (NSString *)[XMGRequest load:KEY_UDID_INSTEAD];
    }
    NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}

#pragma mark - private

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+ (void)PostBody2:(NSString *)url parameter:(NSMutableDictionary *)para success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
   
    NSURL *Url = [NSURL URLWithString:url];
    NSError *error;
    //参数拼接
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:Url  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                         timeoutInterval:15.0f];
    [request setHTTPMethod: @"POST"];
    //设置Content-Type
    //[request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
     
//    NSLog(@"请求参数Body：%@",jsonString);
    
    //异步请求网络
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSString *results = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
////        NSLog(@"结果：%@",results);
//        if (connectionError==nil) {
//            success(results);
//        } else{
//            failure(connectionError);
//        }
//        
//    }];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        if (error) {
            if (failure) {
                failure(error);
            }
            NSLog(@"失败%@", error.localizedDescription);
        }else{
            if (success) {
                success(result);
            }
            
            NSLog(@"结果：%@\n请求地址：%@", result, response.URL);
        }
    }];
    
    [task resume];
   
}


+(void)postBody:(NSString *)url parameter:(NSDictionary *)para success:(void (^)(id responseObject))success failure:(void (^)(NSError *err))failure{
    
    AFHTTPSessionManager  *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // 关键! 转化为NSaData作为HTTPBody
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = @"";
    if (jsonData && [jsonData length] > 0) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(responseObject);
                }
            }
            NSLog(@"Reply JSON: %@", responseObject);
        } else {
            if (failure) {
                failure(error);
            }
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }];
    
    
}
+ (void)Get:(NSString *)url parameter:(NSDictionary *)para success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest=30;
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:config]; 
 
    [manager GET:url parameters:para headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
    
    
}
#pragma mark ===== 上传文件
+ (void)uploadFilePost:(NSString *)url
             parameter:(NSMutableDictionary *)para
               success:(void(^)(id responseObject))success
               failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:url parameters:para headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}
+ (void)Post:(NSString *)url parameter:(NSMutableDictionary *)para success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    
    NSLog(@"请求参数 = <%@>  %@",para ,url);
    
    [manager POST:url parameters:para headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
        NSLog(@"返回参数 = <%@>",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }]; 
    
}


/**
 *
 @*
 @*     dict[@"data"]=image64;
 dict[@"typeid"]=[NSString stringWithFormat:@"%d",2];
 dict[@"fileType"]=@"png";
 @"http://tempuri.org/" withUrlStr:@"http://appleapp.xiangzhuankecheng.com:8099/Service.asmx" withMethod:@"UploadFile" imgData:image64 success:^(id responseObject) {
 
 @*
 */

+ (void)postXMLWebServiceParams:(NSString *)urlStr typeid:(NSInteger )typeidc fileType:(NSString *)method imgData:(NSString *)base64 success:(void(^)(id responseObject))success  failure:(void(^)(NSError *error))failure{
    
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         
                         "<soap:Body>\n"
                         
                         "<UploadFile xmlns=\"http://tempuri.org/\">\n"
                         
                         "<typeid>%ld</typeid>\n"
                         "<fileType>%@</fileType>\n"
                         "<data>%@</data>\n"
                         
                         "</UploadFile>\n"
                         
                         "</soap:Body>\n"
                         
                         "</soap:Envelope>\n",(long)typeidc,method,base64];
    NSLog(@"%@", soapMsg);
    // 创建URL
    NSURL *url = [NSURL URLWithString: urlStr];
    //计算出soap所有的长度，配置头使用
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    //创建request请求，把请求需要的参数配置
    NSMutableURLRequest  *request=[[NSMutableURLRequest alloc]init];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //请求的参数配置，不用修改
    [request setTimeoutInterval: 10 ];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setURL: url ] ;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //soapAction的配置
    //    [request setValue:[NSString stringWithFormat:@"%@%@",nameSpace,method] forHTTPHeaderField:@"SOAPAction"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 将SOAP消息加到请求中
    [request setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 创建连接
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                failure(error);
            }
            
            NSLog(@"失败%@", error.localizedDescription);
            
        }else{
            
            if (success) {
                success(data);
            }
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"结果：%@\n请求地址：%@", result, response.URL);
            //系统自带的
            //NSXMLParser *par = [[NSXMLParser alloc] initWithData:data];
            // [par setDelegate:self];//设置NSXMLParser对象的解析方法代理
            // [par parse];//调用代理解析NSXMLParser对象，看解析是否成功
        }
    }];
    
    [task resume];
}




+ (void)postXMLWebServiceConnectionNameSpace:(NSString *)nameSpace withUrlStr:(NSString *)urlStr withMethod:(NSString *)method imgData:(NSString *)base64 success:(void(^)(id responseObject))success  failure:(void(^)(NSError *error))failure{
    
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         
                         "<soap:Body>\n"
                         
                         "<UploadFile xmlns=\"http://tempuri.org/\">\n"
                         
                         "<typeid>%d</typeid>\n"
                         "<fileType>%@</fileType>\n"
                         "<data>%@</data>\n"
                         
                         "</UploadFile>\n"
                         
                         "</soap:Body>\n"
                         
                         "</soap:Envelope>\n",method,nameSpace,2,@"png",base64,method];
    NSLog(@"%@", soapMsg);
    // 创建URL
    NSURL *url = [NSURL URLWithString: urlStr];
    //计算出soap所有的长度，配置头使用
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    //创建request请求，把请求需要的参数配置
    NSMutableURLRequest  *request=[[NSMutableURLRequest alloc]init];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //请求的参数配置，不用修改
    [request setTimeoutInterval: 10 ];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setURL: url ] ;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //soapAction的配置
    [request setValue:[NSString stringWithFormat:@"%@%@",nameSpace,method] forHTTPHeaderField:@"SOAPAction"];
    
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 将SOAP消息加到请求中
    [request setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 创建连接
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                failure(error);
            }
            
            NSLog(@"失败%@", error.localizedDescription);
            
        }else{
            
            if (success) {
                success(data);
            }
            
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            NSLog(@"结果：%@\n请求地址：%@", result, response.URL);
            //系统自带的
            //NSXMLParser *par = [[NSXMLParser alloc] initWithData:data];
            // [par setDelegate:self];//设置NSXMLParser对象的解析方法代理
            // [par parse];//调用代理解析NSXMLParser对象，看解析是否成功
        }
    }];
    
    [task resume];
}


//获取节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    
    NSLog(@"foundCharacters=%@", string);
}



+(NSString *)getActiveStatus{
    
    NSString *getActive=[[NSUserDefaults standardUserDefaults]objectForKey:@"statusActive"];
    
    return getActive;
}


+(NSString *)getUDID{
    
    NSString *getUDIDDevice=[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceUUID"];
    
    return getUDIDDevice;
}

#pragma mark - 保存图片到自定义相册
/**
 * 获得自定义的相册对象
 */
- (PHAssetCollection *)collection
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:XMGCollectionName]) {
            return collection;
        }
    }
    
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:XMGCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        NSLog(@"获取相册【%@】失败", XMGCollectionName);
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

/**
 * 保存图片到相册
 */
- (void)saveImage {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"logo"]].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection];
            if (collection == nil) return;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
            } else {
                NSLog(@"保存成功");
            }
        });
    }];
}

#pragma mark === 时间搓的 转化
+(NSString *)getTimestampFromTime:(NSString *)check_time{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];;
    
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    
    
    return timeString;
    
}

#pragma mark == 图片压缩系数比例
+(NSData *)ImageZipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.2);//0.7
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.3);//0.8
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.4);//0.9
        }
    }
    return data;
}

+(NSString *)getTimeStamp_Cover_Time:(NSString *)timeStr{
    
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStr doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //yyyy-MM-dd HH:mm:ss
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
    
}


/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    // [backgroundView setBackgroundColor: [UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.9]];
    
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


//原生请求


+ (void)getWithUrlString:(NSString *)path parameters:(id)parameters success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure
{
      //如果网址中出现了 中文 需要进行URL编码
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     
        NSURL *url = [NSURL URLWithString:path];
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //创建网络会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //创建数据任务  系统会自动开启一个子线程
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //data为服务器返回的数据
    //        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@",string);
     
            //把服务器返回的json数据 直接转成字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            success(dic);
        }];
        //开始任务
    [dataTask resume];
   
}
@end
