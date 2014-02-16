//
//  MIQUSNS.h
//  jfun
//
//  Created by 冒主人～ on 13-12-9.
//  Copyright (c) 2013年 miqu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MIQUSNS : NSObject<RenrenDelegate,WXApiDelegate,WeiboSDKDelegate,WBHttpRequestDelegate,UIAlertViewDelegate>

//SNS
typedef enum SNSType{
    renren,
    sinaweibo,
    weixinfriend,
    weixinCircle
}SNSType;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *text;
@property (nonatomic) SNSType type;

+ (MIQUSNS *)sharedInstance;
+ (MIQUSNS *)SNSShareWithType:(SNSType)type image:(UIImage *)image text:(NSString *)text;

+ (BOOL)handleOpenURL:(NSURL *)url;

@end
