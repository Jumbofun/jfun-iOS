//
//  JFStore.m
//  jfun
//
//  Created by mmm on 14-2-6.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define CACHE_DEFAULT_NAME @"storeidcache.plist"

#define ROUTE_LIST_PATH @"infolist"

#import "JFStore.h"
@interface JFStore(){
    NSMutableDictionary *_cache;
}
@end

static JFStore *_sharedInstance =nil;
@implementation JFStore
+ (JFStore *)sharedInstance{
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

- (void)startFreshFromServerWithSids:(NSArray *)sids time:(TimeType)time completeBlock:(void (^)(NSDictionary *stores))block{
    NSMutableArray *q = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
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
    
    while ([q count]>0) {
        NSNumber *sid = [q lastObject];
        [q removeLastObject];
        [temp addObject:sid];
        if ([temp count]==3||[q count]==0) {
            //add http GET parameters
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            for (int i = 0; i < 3; i++) {
                if (i < [temp count]){
                    [params setValue:[NSString stringWithFormat:@"%@",temp[i]] forKey:[NSString stringWithFormat:@"id%d",i+1]];
                }
                else{
                    [params setValue:[NSString stringWithFormat:@""] forKey:[NSString stringWithFormat:@"id%d",i+1]];
                }
                
            }
            [params setValue:[[MIQUUserInput new] timeEngStringForTimeType:time] forKey:@"timeslot"];
            
            NSString *URL = @"http://*/infolist";
            NSData *httpData;
            NSError *er;
            NSURLResponse *response;
            NSURLRequest *req = [self prepareRequestWithURLString:URL GET:params];
            httpData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&er];
            BOOL isError = NO;
            if ([httpData length]) {
                @try {
                    NSArray *jsonArr = [self jsonToArr:httpData];
                    int i = 0;
                    for (NSDictionary *storeDic in jsonArr) {
                        sid = [temp objectAtIndex:i];
                        JFOneStore *newStore = [[JFOneStore alloc] initWithDictionary:storeDic Id:[sid unsignedIntegerValue]];
                        stores[sid]=newStore;
                        _cache[sid]=newStore;
                        i++;
                    }
                }
                @catch (NSException *exception) {
                    isError = YES;
                }
                
            }
            else{
                isError = YES;
            }
            [q removeAllObjects];
        }
    }
    
    [self saveCache];
    block(stores);
    
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


- (NSMutableURLRequest *)prepareRequestWithURLString:(NSString *)URL GET:(NSDictionary *)param {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *urlStr= [NSMutableString stringWithString:URL];
    [urlStr appendString:@"?"];
    //prepare params
    for (NSString *key in [param allKeys]) {
        if ([[param allKeys] indexOfObject:key] == [[param allKeys] count] - 1)
            [urlStr appendFormat:@"%@=%@",key,[[param valueForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        else
            [urlStr appendFormat:@"%@=%@&",key,[[param valueForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    //set request
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIME_OUT];//time limit
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"MIQU-JFun-APP iOS v1.0 10000" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"JFun:Prepare http request:%@",urlStr);
    return request;
}
//json to NSArray
- (NSArray *)jsonToArr:(NSData *)data{
    NSError *er = nil;
    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er];
    if (er) {
        NSLog(@"MIQUJFun-jsonToArr:Error occures while transform NSData to NSArray:%@",[er localizedDescription]);
    }
    
    if (![arr isKindOfClass:[NSArray class]]) {
        NSLog(@"MIQUJFun-jsonToArr:Error occures while transform NSData to NSArray");
        return nil;
    }
    return arr;
}
@end
