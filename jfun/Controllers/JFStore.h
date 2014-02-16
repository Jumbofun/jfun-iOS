//
//  JFStore.h
//  jfun
//
//  Created by mmm on 14-2-6.
//  Copyright (c) 2014年 miqu. All rights reserved.
//


#import "MKNetworkEngine.h"

@interface JFStore : MKNetworkEngine

+ (instancetype)sharedInstance;

- (void)startFreshFromServerWithSids:(NSArray *)sids time:(TimeType)time completeBlock:(void (^)(NSDictionary *stores))block;
- (void)cacheWithSids:(NSArray *)sids completeBlock:(void (^)(NSDictionary *stores))block;
@end
