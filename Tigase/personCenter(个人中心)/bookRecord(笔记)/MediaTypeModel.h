//
//  MediaTypeModel.h
//  TFJunYouChat
//
//  Created by lifengye on 2021/12/20.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, MediaNetwrokType) {
    MediaNetwrokTypeLocal,
    MediaNetwrokTypeNetWork,
};

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypeImage,
    MediaTypeVideo,
};

NS_ASSUME_NONNULL_BEGIN
@interface MediaTypeModel : NSObject

@property (nonatomic,assign) MediaNetwrokType mediaNetwrokType;
@property (nonatomic,assign) MediaType mediaType;
@property (nonatomic,copy)   UIImage* image;
@property (nonatomic,copy) NSString* filePath;
@property (nonatomic,copy) NSString* urlPath;

@end

NS_ASSUME_NONNULL_END
