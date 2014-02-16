//
//  JFPoint.h
//  jfun
//
//  Created by mmm on 14-2-14.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface JFPoint : MKNetworkEngine
+ (instancetype)sharedInstance;

- (void)startFreshFromServerWithSids:(NSArray *)sids completeBlock:(void (^)(NSDictionary *stores))block;
- (void)cacheWithSids:(NSArray *)sids completeBlock:(void (^)(NSDictionary *stores))block;
@end
