//
//  JFRoute.m
//  jfun
//
//  Created by mmm on 14-2-4.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define FAVORATE_DEFAULT_NAME @"favorateroutes.plist"
#define CACHE_DEFAULT_NAME @"routelistidcache.plist"

#define ROUTE_LIST_PATH @"routelistid"

#import "JFRoute.h"
@interface JFRoute(){
    NSArray *_briefRoutes;
    NSMutableArray *_routes;
    NSMutableDictionary *_cache;
}

@end
static JFRoute *_sharedInstance =nil;
@implementation JFRoute
+ (JFRoute *)sharedInstance{
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
- (void)startFreshFromServerWithReturnNumber:(NSUInteger)number{
    MKNetworkOperation *operation = [self operationWithPath:ROUTE_LIST_PATH];
    [operation addCompletionHandler:
     ^(MKNetworkOperation *op){
         NSArray *jsonArr=[op responseJSON];
         if ([jsonArr isKindOfClass:[NSArray class]]) {
             _routes=[NSMutableArray array];
             //get raw data
             NSMutableArray *arr= [[NSMutableArray alloc] init];
             for (NSDictionary *dic in jsonArr) {
                 JFOneRoute *route=[[JFOneRoute alloc]initWithDictionary:dic];
                 [arr addObject:route];
             }
             _briefRoutes=arr;
             
             [self readCache];
             [_cache removeAllObjects];
             //add point
             __block int n=0;
             for (int i =[_briefRoutes count]-1;i>=0;i--) {
                 JFOneRoute *route = _briefRoutes[i];
                 if ([route.title length]==0) {
                     n++;
                     if (n==[_briefRoutes count]) {
                         [self saveCache];
                         [self.delegate recievedRoutes:[_routes objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(number, [_routes count]))]] error:nil];
                     }
                     continue;
                 }
                 [_cache setObject:route forKey:route.rid];
                 [_routes addObject:route];
                 
                 NSNumber *storeId;
                 for (NSNumber *sid in route.storeIDs) {
                     if ([sid integerValue]!=0){
                         storeId=sid;
                         break;
                     }
                 }
                
                 [[JFPoint sharedInstance] startFreshFromServerWithSids:@[storeId] completeBlock:^(NSDictionary *dic){
                     n++;
                     if (dic) {
                         JFOnePoint *point = dic[storeId];
                         route.picURL=point.photos[0];
                     }
                     if (n==[_briefRoutes count]) {
                         [self saveCache];
                         [self.delegate recievedRoutes:[_routes objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(number, [_routes count]))]] error:nil];
                     }
                 }];
             }
             
             
             [_routes sortUsingComparator:^NSComparisonResult(id a,id b){
                 return [_routes indexOfObject:b] - [_routes indexOfObject:a];
             }];
         }
         else{
             [self.delegate recievedRoutes:nil error:[[NSError alloc] init]];
         }
         
     }
                    errorHandler:^(MKNetworkOperation *op,NSError *er){
                        [self.delegate recievedRoutes:nil error:er];
                    }];
    [self enqueueOperation:operation];
    
}

- (void)getRoutesWithNumber:(NSUInteger)number{
    NSUInteger n;
    [self readCache];
    _routes = [NSMutableArray arrayWithArray:[self sortRoutes:[_cache allValues] option:ByTime]];
    n=MIN(number, [_routes count]);
    NSArray *result = [_routes objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, n)]];
    //reversed
    [self.delegate recievedRoutes:[result sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        return [result indexOfObject:b] - [result indexOfObject:a];
    }]error:nil];
    return;
}
- (NSArray *)getFavorateRoutes{
    NSArray *routes = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];
    //reversed
    return [routes sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        return [routes indexOfObject:b] - [routes indexOfObject:a];
    }];
}
- (BOOL)favorateWithRoute:(JFOneRoute *)route{
    if (!route) return NO;
    if (![route isKindOfClass:[JFOneRoute class]]) return NO;
    
    NSMutableArray *routes;
    @try {
        routes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME) error:&er];
        routes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    if (![self isFavorateWithRoute:route])
        [routes addObject:route];
    
    [NSKeyedArchiver archiveRootObject:routes toFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];
    return YES;
}
- (BOOL)isFavorateWithRoute:(JFOneRoute *)route{
    if (!route) return NO;
    if (![route isKindOfClass:[JFOneRoute class]]) return NO;
    

    BOOL exist=NO;
    NSMutableArray *routes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    for (JFOneRoute *oneroute in routes) {
        if ([oneroute isKindOfClass:[JFOneRoute class]]) {
            if ([oneroute.rid isEqualToNumber:route.rid])
                exist=YES;
        }
    }
    return exist;
}
- (void)deFavorateWithRoute:(JFOneRoute *)route{
    if (!route) return;
    if (![route isKindOfClass:[JFOneRoute class]]) return;
    
    NSMutableArray *routes;
    @try {
        routes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME) error:&er];
        routes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    
    for (JFOneRoute *oneroute in routes) {
        if ([oneroute isKindOfClass:[JFOneRoute class]]) {
            if ([oneroute.rid isEqualToNumber:route.rid])
                [routes removeObject:oneroute];
        }
    }
    [NSKeyedArchiver archiveRootObject:routes toFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];
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

typedef enum SortOption{
    DefaultSort,
    ByTime
}SortOption;
- (NSArray *)sortRoutes:(NSArray *)routes option:(SortOption)option{
    NSArray *sorted;
    if (option==DefaultSort) {
        
    }
    return routes;
}
@end
