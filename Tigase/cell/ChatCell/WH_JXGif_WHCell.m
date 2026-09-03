//
//  WH_JXGif_WHCell.m
//  Tigase_imChatT
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Reese. All rights reserved.
//

#import "WH_JXGif_WHCell.h"
#import "FLAnimatedImage.h"

@implementation WH_JXGif_WHCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)creatUI{
    
}

-(void)setCellData{
    [super setCellData];
    
    NSString* path = [gifImageFilePath stringByAppendingPathComponent:[self.msg.content lastPathComponent]];
    //
    if (_gif) {
        [_gif removeFromSuperview];
        _gif = nil;
//        [_gif release];
    }
    //第三方库，必须有数据才能创建
    NSString *path2 =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",self.msg.content] ofType:@".gif"];

//
//    _gif = [[WH_SCGIFImageView alloc] initWithGIFFile:[NSString stringWithFormat:@"%@.gif",path]];
//
//    _gif.userInteractionEnabled = NO;
//    [self.contentView addSubview:_gif];
//    [_gif release];
     
    NSURL* url;
    if(self.msg.isMySend && isFileExist(self.msg.fileName)){
        NSString *imageUrl = [self.msg.fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//编码
        url = [NSURL fileURLWithPath:imageUrl];
    } else {
        NSString *imageUrl = [self.msg.content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//编码
        
        
        url = [NSURL URLWithString:imageUrl];
    }
      if ([url.absoluteString containsString:@"emoj_dice"]||[url.absoluteString containsString:@"emoj_cquan_"]) {
          NSString *path = url.absoluteString;;
          if([url.absoluteString containsString:@".gif"]){
             path =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",url.absoluteString] ofType:@""];
         
          }else{
             path =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",url.absoluteString] ofType:@".gif"];
         
          }
        NSURL *gifUrl = [NSURL fileURLWithPath:path];// [[NSBundle mainBundle] URLForResource:x withExtension:@"gif"];
        path = gifUrl.path;
         NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:path];
          
          [_gif removeFromSuperview];
          _gif = nil;
          if (_touziImgView) {
              [_touziImgView removeFromSuperview];
              _touziImgView = nil;
          }
   
          
      //  CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)animatedImageData, NULL);
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifUrl, NULL);
        size_t imageCount = CGImageSourceGetCount(gifSource);
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        UIImage * tempImg ;
        for (size_t i = 0; i < imageCount; i++) {
            //获取源图片
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            if (i == 0) {
                tempImg = image;
            }
            [mutableArray addObject:image];
            // 设置停止播放时显示的图片

            
            CGImageRelease(imageRef);
        }

          NSString * key = self.msg.messageId;
         NSString * a = [[NSUserDefaults standardUserDefaults] objectForKey:key];
          _touziImgView = [[UIImageView alloc] init];
          _touziImgView.backgroundColor = [UIColor clearColor];
          if (a.length>0) {
              _touziImgView.image = tempImg;
          } else {
              _touziImgView.animationImages = mutableArray;
              _touziImgView.contentMode = UIViewContentModeScaleAspectFit;
              _touziImgView.animationDuration = 1;
              [_touziImgView startAnimating];
              [[NSUserDefaults standardUserDefaults] setObject:key forKey:key];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [_touziImgView stopAnimating];
                  _touziImgView.image = tempImg;
              });
          }
          [self.contentView addSubview:_touziImgView];
          
      }else{
          [_touziImgView removeFromSuperview];
          _touziImgView = nil;
              if (_gif) {
                  [_gif removeFromSuperview];
                  _gif = nil;
          //        [_gif release];
              }
              //第三方库，必须有数据才能创建
              _gif = [[WH_SCGIFImageView alloc] initWithGIFFile:path];
              _gif.userInteractionEnabled = NO;
              [self.contentView addSubview:_gif];
          //    [_gif release];
      }
    
    
    CGFloat gifX = .0f;
    CGFloat gifY = .0f;
    CGFloat gifW = imageItemHeight;
    CGFloat gifH = imageItemHeight;
    
    if(self.msg.isMySend){
        NSLog(@"%f %f %f %d",JX_SCREEN_WIDTH, HEAD_SIZE,imageItemHeight, INSETS);
        _gif.frame = CGRectMake(JX_SCREEN_WIDTH-HEAD_SIZE-imageItemHeight-INSETS*2 + 40+CHAT_WIDTH_ICON, 20, imageItemHeight, imageItemHeight);//185
        gifX = JX_SCREEN_WIDTH - INSETS - HEAD_SIZE - CHAT_WIDTH_ICON - gifW;
        
        _touziImgView.frame = CGRectMake(JX_SCREEN_WIDTH-HEAD_SIZE-imageItemHeight-INSETS*2 + +CHAT_WIDTH_ICON+20, 5+5, imageItemHeight-40, imageItemHeight-40);//185
    }
    else{
        _gif.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + INSETS-CHAT_WIDTH_ICON, 20, imageItemHeight, imageItemHeight);
        _touziImgView.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + INSETS-CHAT_WIDTH_ICON+20, 10, imageItemHeight-40, imageItemHeight-40);
    }
    
    if ([self.msg.content containsString:@"emoj_dice_"]||[self.msg.content containsString:@"emoj_Qquan_"]) {
        if (self.msg.isShowTime) {
            CGRect frame = _touziImgView.frame;
            frame.origin.y = _touziImgView.frame.origin.y + 10;
            _touziImgView.frame = frame;
        }
        
        
        self.bubbleBg.frame=_touziImgView.frame;
    }else{
        if (self.msg.isShowTime) {
            CGRect frame = _gif.frame;
            frame.origin.y = _gif.frame.origin.y + 40;
            _gif.frame = frame;
        }
        
        
        self.bubbleBg.frame=_gif.frame;
    }
    
//    if(self.msg.isMySend){
////        NSLog(@"%f %f %f %d",JX_SCREEN_WIDTH, HEAD_SIZE,imageItemHeight, INSETS);
//        gifX = JX_SCREEN_WIDTH - INSETS - HEAD_SIZE - CHAT_WIDTH_ICON - gifW;
//        gifY = 20;
//    } else {
//        gifX = CGRectGetMaxX(self.headImage.frame) + CHAT_WIDTH_ICON;
//        gifY = 20;
//    }
//    _gif.frame = CGRectMake(gifX, gifY, gifW, gifH);//185
//
//    if (self.msg.isShowTime) {
//        CGRect frame = _gif.frame;
//        frame.origin.y = _gif.frame.origin.y + 40;
//        _gif.frame = frame;
//    }
//
//
//    self.bubbleBg.frame = _gif.frame;
}

+ (float)getChatCellHeight:(WH_JXMessageObject *)msg {
    
    if ([msg.chatMsgHeight floatValue] > 1) {
        return [msg.chatMsgHeight floatValue];
    }
    
    float n = 0;
    if (msg.isGroup && !msg.isMySend) {
        if (msg.isShowTime) {
            n = imageItemHeight+20*2 + 40;
        }else {
            n = imageItemHeight+20*2;
        }
    }else {
        if (msg.isShowTime) {
            n = imageItemHeight+10*2 + 40;
        }else {
            n = imageItemHeight+10*2;
        }
    }
    
    msg.chatMsgHeight = [NSString stringWithFormat:@"%f",n];
    if (!msg.isNotUpdateHeight) {
        [msg updateChatMsgHeight];
    }
    return n;
}

-(void)didTouch:(UIButton*)button{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)sp_getUserName {
    NSLog(@"Get Info Failed");
}
@end
