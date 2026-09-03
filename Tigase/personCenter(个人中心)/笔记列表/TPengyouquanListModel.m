//
//  TPengyouquanListModel.m
//  tio-chat-ios
//
//  Created by apple on 2023/3/13.
//  Copyright © 2023 刘宇. All rights reserved.
//

#import "TPengyouquanListModel.h"
#import "MJExtension.h" 

@interface TPengyouquanListModel()

@property (strong, nonatomic) AFHTTPSessionManager  * _Nullable sessionManager;
@end

@implementation TPengyouquanListModel
 
/**
 朋友圈列表
 */
+ (void)requestPengyouquanListWithBlock:(void (^)(int, NSArray * _Nonnull, NSString * _Nonnull))block withParams:(NSDictionary *)params {
 /*   [TIOHTTPSManager tio_POST:getMomentsList parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
           // NSDictionary *data
            NSArray *jsonList = responseObject[@"data"];
           
           // NSArray *jsonList = data[@"list"];
            NSMutableArray *pengyouquanList = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *json in jsonList) {
                TPengyouquanListModel *listModel = [TPengyouquanListModel yy_modelWithJSON:json];
              
                NSArray *jsonPicList = [ json objectForKey:@"fileUrls"];
                NSMutableArray *picModelList = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *jsonPic in jsonPicList) {
                    TPengyouquanPicModel *picModel = [TPengyouquanPicModel yy_modelWithJSON:jsonPic];
                    [picModelList addObject:picModel];
                }
                listModel.fileUrls = picModelList;
                
                [pengyouquanList addObject:listModel];
            }
            block(http_code_success, pengyouquanList, @"");
        } else {
            block(http_code_failed, nil, @"暂无数据");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, nil, error.localizedDescription);
    }];
  */
}

/**
 上传图片
 */
+ (void)requestPengyouquanUploadPicWithBlock:(void (^)(int, NSString * _Nonnull, NSString * _Nonnull))block withParams:(NSDictionary *)params {
    
    
  /*  [TIOHTTPSManager tio_UPLOAD:pengyouquanUploadPic parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = params[@"image"];
        //上传的参数(上传图片，以文件流的格式)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
    
        NSData *data = [image data_compressToByte:500];
 
        [formData appendPartWithFileData:data
                                    name:@"uploadFile"
                                fileName:fileName
                                mimeType:@"image/jpg"];//multipart/form-data
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"xxxxxxxxxxxx%@", responseObject);
        NSDictionary *data = responseObject[@"data"];
        block(http_code_success, data[@"url"], @"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"", @"上传失败");
    }];
    
    
    
    UIImage *image = params[@"image"];
    NSData *data = [image data_compressToByte:500];
    [TIOUploadManager uploadFileWithData:data sessionId:@"" messageType:950 fileName:@"dslfjldfjdlfjdlsfldjfds." ext:@"jpg" progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completion:^(NSArray * _Nonnull urls) {
         
        NSLog(@"error:\n%@",urls);
        
    } failure:^(NSError * _Nonnull error) {
        
        
        NSLog(@"error:\n%@",error);
        
    }];
    
    
    [TIOHTTPSManager tio_UPLOAD:pengyouquanUploadPic parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpeg", dateString];
    
        NSData *data = [image data_compressToByte:500];
        
        [formData appendPartWithFileData:data
                                    name:@"uploadFile"
                                fileName:fileName
                                mimeType:@"image/jpeg"];//multipart/form-data
        
    } progress:^(NSProgress * _Nonnull uploadProgres) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"xxxxxxresponseObject%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xxxxxxerror %@", error);
        
    }];
   */
     // http://38.6.216.244:6060/mytio/upload/uploadImg.tio_x 
}

/**
 上传视频
 */
+ (void)requestPengyouquanUploadVideoWithBlock:(void (^)(int, NSString * _Nonnull, NSString * _Nonnull))block withParams:(NSDictionary *)params {
    
    
 /*   [TIOHTTPSManager tio_UPLOAD:pengyouquanUploadVideo parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *videoUrl = params[@"video"];
        //上传的参数(上传图片，以文件流的格式)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.mp4", dateString];
    
        NSData *data = [NSData dataWithContentsOfURL:videoUrl];
        
        [formData appendPartWithFileData:data
                                    name:@"uploadFile"
                                fileName:fileName
                                mimeType:@"video/mp4"];//multipart/form-data
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            NSDictionary *data = responseObject[@"data"];
            block(http_code_success, data[@"url"], @"");
        } else {
            block(http_code_failed, @"", @"上传失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"", @"上传失败");
    }];
  */
}
/**
 发布朋友圈
 */
+ (void)requestPengyouquanPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    
 /*   [TIOHTTPSManager tio_POST:pengyouquanPublish parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"朋友圈发布成功");
        } else {
            block(http_code_failed, @"朋友圈发布失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"朋友圈发布失败");
    }];
  */
}

/**朋友圈点赞或取消点赞**/
+ (void)requestPengyouquanAddOrCancelLikeWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params withUrlString:(nonnull NSString *)urlString{
  
    
  /*  [TIOHTTPSManager tio_POST:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, responseObject[@"data"]);
        } else {
            block(http_code_failed, @"操作失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"操作失败");
    }];
   */
}

/**朋友圈删除**/
+ (void)requestPengyouquanDeleteWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
  /*  [TIOHTTPSManager tio_GET:pengyouquanDelete parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"删除成功");
        } else {
            block(http_code_failed, @"删除失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"删除失败");
    }];
   */
}

/**朋友圈举报**/
+ (void)requestPengyouquanReportWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
 /*   [TIOHTTPSManager tio_POST:pengyouquanReport parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"举报成功");
        } else {
            block(http_code_failed, @"举报失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"举报失败");
    }];
  */
}

/**朋友圈详情**/
+ (void)requestPengyouquanDetailByIdWithBlock:(void (^)(int code, TPengyouquanListModel *model, NSString *errorMsg))block withParams:(NSDictionary *)params {
 /*   [TIOHTTPSManager tio_GET:pengyouquanDetailById parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"ok"] boolValue]) {
            NSDictionary *data = responseObject[@"data"];
            TPengyouquanListModel *model = [TPengyouquanListModel yy_modelWithJSON:data];
            
             
            
            NSArray *jsonPicList = data[@"fileUrls"];
            NSMutableArray *picModelList = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *jsonPic in jsonPicList) {
                TPengyouquanPicModel *picModel = [TPengyouquanPicModel yy_modelWithJSON:jsonPic];
                [picModelList addObject:picModel];
            }
            model.fileUrls = picModelList;
            
            NSArray *jsonCommentList = data[@"comments"];
            NSMutableArray *commentModelList = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *jsonPic in jsonCommentList) {
                TPengyouquanCommentListModel *picModel = [TPengyouquanCommentListModel yy_modelWithJSON:jsonPic];
                
                NSArray *jsonChildList = jsonPic[@"childList"];
                if (jsonChildList != nil) {
                    NSMutableArray *childModelList = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *jsonChild in jsonChildList) {
                        TPengyouquanCommentChildModel *childModel = [TPengyouquanCommentChildModel yy_modelWithJSON:jsonChild];
                        [childModelList addObject:childModel];
                    }
                    picModel.childList = childModelList;
                }
                [commentModelList addObject:picModel];
                
            }
            model.comments = commentModelList;
            
            block(http_code_success, model, @"");
        } else {
            block(http_code_failed, nil, @"网络请求错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, nil, @"网络请求错误");
    }];
  
  */
}

/**朋友圈评论**/
+ (void)requestPengyouquanAddCommentWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
 /*    [TIOHTTPSManager tio_POST:pengyouquanAddComment parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"评论成功");
        } else {
            block(http_code_failed, @"评论失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"评论失败");
    }];
  
  */
}


/**
 发布笔记
 */
+ (void)requestBookChatPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    
  /*  [TIOHTTPSManager tio_POST:pengyouquanNoteBookAdd parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记添加成功");
        } else {
            block(http_code_failed, @"笔记添加失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记添加失败");
    }];
   */
}


/**
 更新笔记
 */
+ (void)requestBookUpdatePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    
      
    
  /*  [TIOHTTPSManager tio_POST:pengyouquanNoteBookUpdate parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记更新成功");
        } else {
            block(http_code_failed, @"笔记更新失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记更新失败");
    }];
   */
}

/**
 删除笔记
 */
+ (void)requestBookDeletePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    //删除笔记
  //  #define  @"/note/delete" //参数  Integer noteId
   
 /*   [TIOHTTPSManager tio_POST:pengyouquanNoteBookDelete parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记删除成功");
        } else {
            block(http_code_failed, @"笔记删除失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记删除失败");
    }];
  */
}


/**
 笔记详情
 */
+ (void)requestBookDetailPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    //笔记详情
    //#define pengyouquanNoteBookDetail @"/note/detail" //参数  Integer noteId
    //笔记列表
   
 /*   [TIOHTTPSManager tio_POST:pengyouquanNoteBookDetail parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记详情成功");
        } else {
            block(http_code_failed, @"笔记详情失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记详情失败");
    }];
  */
}


/**
 笔记列表
 */
+ (void)requestBookNoteListPublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {

 /*   [TIOHTTPSManager tio_POST:pengyouquanNoteBookGetNoteList parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记添加成功");
        } else {
            block(http_code_failed, @"笔记添加失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记添加失败");
    }];
  */
}


/**
 搜藏笔记
 */
+ (void)requestBookFavoritePublishWithBlock:(void (^)(int code, NSString *errorMsg))block withParams:(NSDictionary *)params {
    
 /*   [TIOHTTPSManager tio_POST:pengyouquanGetNoteChatFavorite parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ok"] boolValue]) {
            block(http_code_success, @"笔记收藏成功");
        } else {
            block(http_code_failed, @"笔记搜藏失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(http_code_failed, @"笔记搜藏失败");
    }];
  */
}



@end

@implementation TPengyouquanCommentChildModel

@end

@implementation TPengyouquanCommentListModel
 
@end

@implementation TPengyouquanLikeModel

@end


@implementation TPengyouquanPicModel

@end


@implementation TPengyouquanPraisesModel

@end
