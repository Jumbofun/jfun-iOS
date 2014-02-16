//
//  MIQUSNS.m
//  jfun
//
//  Created by 冒主人～ on 13-12-9.
//  Copyright (c) 2013年 miqu. All rights reserved.
//

#import "MIQUSNS.h"
@interface MIQUSNS(){

}
@end
static MIQUSNS *_sharedSNS = nil;
@implementation MIQUSNS
@synthesize type,text,image;
+ (MIQUSNS *)sharedInstance{
    @synchronized(self)
    {
        if (_sharedSNS == nil)
        {
            _sharedSNS = [[self alloc] init];
        }
    }
    return _sharedSNS;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedSNS == nil)
        {
            _sharedSNS = [super allocWithZone:zone];
            return _sharedSNS;
        }
    }
    return nil; 
}
+ (MIQUSNS *)SNSShareWithType:(SNSType)type image:(UIImage *)image text:(NSString *)text{
    MIQUSNS *sns = [MIQUSNS sharedInstance];
    sns.image = image;
    sns.text = text;
    sns.type = type;
    [sns startShare];
    return sns;
}
+ (BOOL)handleOpenURL:(NSURL *)url{
    NSString *urlStr = [url absoluteString];

    if ([urlStr hasPrefix:[NSString stringWithFormat:@"wb%@",WB_APP_ID]]) {
        return [ WeiboSDK handleOpenURL:url delegate:[MIQUSNS sharedInstance]];
        
    }else if ([urlStr hasPrefix:WX_APP_ID]){
        return [WXApi handleOpenURL:url delegate:[MIQUSNS sharedInstance]];
        
    }else{
        return NO;
    }
}
- (void)startShare{
    if (!image || !text){
        [self displayTextAutoDismiss:@"未知错误:)"];
        NSLog(@"MIQUSNS: no image or text");
        return;
    }

    if (type==renren) {
        Renren *renren = [Renren sharedRenren];

        if (![renren isSessionValid]) {
            [renren authorizationInNavigationWithPermisson:@[@"publish_checkin",@"publish_feed",@"send_invitation",@"photo_upload",@"status_update",@"create_album",@"read_user_album"] andDelegate:self];
            return;
        }
        /*ROCreateAlbumRequestParam *AlbParam = [[ROCreateAlbumRequestParam alloc] init];
        AlbParam.name = ALB_NAME;
        AlbParam.description = ALB_DESCP;

        [renren get]
        [renren createAlbum:<#(ROCreateAlbumRequestParam *)#> andDelegate:self];*/
        ROPublishPhotoRequestParam *PhoParam = [[ROPublishPhotoRequestParam alloc] init];
        PhoParam.imageFile = image;
        PhoParam.caption = text;                                   
        [renren publishPhoto:PhoParam andDelegate:self];
    }
    else if (type == weixinCircle || type == weixinfriend){
        if (![self checkWeixinInstalled]) return;
        
        WXMediaMessage *msg = [WXMediaMessage message];
        [msg setThumbData:UIImageJPEGRepresentation(image, 0.1)];
        [msg setDescription:ALB_DESCP];
        [msg setTitle:ALB_NAME];
        
        WXImageObject *imgObj = [WXImageObject object];
        imgObj.imageData = UIImagePNGRepresentation(image);
        
        msg.mediaObject = imgObj;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];

        req.bText = NO;
        req.message = msg;
        req.scene = (type == weixinfriend) ?WXSceneSession:WXSceneTimeline;
        
        [WXApi sendReq:req];
    }
    else if (type == sinaweibo){
        //[WBHttpRequest requestWithURL:@"" httpMethod:@"POST" params:@{} delegate:self withTag:@"pic"];
        WBAuthorizeRequest *req = [WBAuthorizeRequest request];
        req.redirectURI = kRedirectURI;
        req.scope = @"all";
        [WeiboSDK sendRequest:req];
    }
    [self displayText:@"发送中..."];
}

- (BOOL)checkWeixinInstalled{
    if ([WXApi isWXAppInstalled]) return YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了:)" message:@"您还未安装微信，是否跳转到微信下载地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
    [alert show];

    return NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableString *urlStr = [NSMutableString stringWithString:[[WXApi getWXAppInstallUrl] stringByReplacingOccurrencesOfString:@"http" withString:@"itms"]];

        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }
}

//alert
- (void)displayText:(NSString *)txt{
    [WTStatusBar setStatusText:txt timeout:30.0f animated:YES];
}
- (void)displayTextAutoDismiss:(NSString *)txt{
    [WTStatusBar setStatusText:txt timeout:1.0f animated:YES];
}


#pragma mark Renren delegate
-(void)renren:(Renren *)renren loginFailWithError:(ROError *)error{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"登录失败:)" waitUntilDone:NO];
}

-(void)renrenDidLogin:(Renren *)rr{
    [_sharedSNS startShare];
}
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送成功!" waitUntilDone:NO];
}
-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送失败:)" waitUntilDone:NO];
}


#pragma mark WX delegate
-(void)onReq:(BaseReq *)req{
    
}
-(void)onResp:(BaseResp *)resp{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送成功!" waitUntilDone:NO];
}


#pragma mark SinaWeibo delegate
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送成功!" waitUntilDone:NO];
}
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送失败:)" waitUntilDone:NO];
}
-(void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送成功!" waitUntilDone:NO];
}
-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    [self performSelectorOnMainThread:@selector(displayTextAutoDismiss:) withObject:@"发送成功!" waitUntilDone:NO];
}
@end
