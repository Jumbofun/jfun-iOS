//
//  JFStore.m
//  jfun
//
//  Created by mmm on 14-2-6.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define CACHE_DEFAULT_NAME @"pointidcache.plist"

#define POINT_PATH @"point"

#import "JFPoint.h"
@interface JFPoint(){
    NSMutableDictionary *_cache;
}
@end

static JFPoint *_sharedInstance =nil;
@implementation JFPoint
+ (JFPoint *)sharedInstance{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[self alloc] initWithHostName:HOSTURL portNumber:HOSTPORT apiPath:APIPATH customHeaderFields:nil];
        }
    }
    return _sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (void)startFreshFromServerWithSids:(NSArray *)sids completeBlock:(void (^)(NSDictionary *stores))block{
    NSMutableDictionary *points = [NSMutableDictionary dictionary];
    [self readCache];
    
    __block int zeroN=0;
    for (NSNumber *sid in sids) {
        if ([sid integerValue]==0) {
            zeroN++;
            continue;
        }
        if ([_cache objectForKey:sid]) {
            points[sid]=_cache[sid];
            continue;
        }
        MKNetworkOperation *op = [self operationWithPath:POINT_PATH params:@{@"id":sid}];
        
        [op addCompletionHandler:^(MKNetworkOperation *response){
            NSArray *result = [response responseJSON];
            NSDictionary *pointDic = result[0];
            JFOnePoint *point = [[JFOnePoint alloc] initWithDictionary:pointDic Id:[sid integerValue]];
            [_cache setObject:point forKey:sid];
            [points setObject:point forKey:sid];
            
            //return
            if ([sids count]==[points count]+zeroN){
                [self saveCache];
                block(points);
            }
        }
        errorHandler:^(MKNetworkOperation *re,NSError *er){
            [self cancelAllOperations];
            block(nil);
                    }];
        [self enqueueOperation:op];
        
    }
    if ([sids count]==[points count]+zeroN){
        [self saveCache];
        block(points);
    }

}
- (void)cacheWithSids:(NSArray *)sids completeBlock:(void (^)(NSDictionary *stores))block{
    NSMutableArray *q = [NSMutableArray array];
    NSMutableDictionary *stores = [NSMutableDictionary dictionary];
    [self readCache];
    
    for (int i=0; i<[sids count]; i++) {
        if (_cache[sids[i]]) {
            stores[sids[i]]=_cache[sids[i]];
        }
        else{
            [q addObject:sids[i]];
        }
    }
    block(stores);
}
- (void)saveCache{
    if (!_cache) return;
    if (![_cache count]) return;
    
    [NSKeyedArchiver archiveRootObject:_cache toFile:DOCUMENT_PATH(CACHE_DEFAULT_NAME)];
}
- (void)readCache{
    if (_cache)
        if ([_cache count])
            return;
    @try {
        _cache = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(CACHE_DEFAULT_NAME)]];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(CACHE_DEFAULT_NAME) error:&er];
        _cache = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(CACHE_DEFAULT_NAME)]];
    }
}
@end
