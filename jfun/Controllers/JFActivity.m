//
//  JFActivity.m
//  jfun
//
//  Created by mmm on 14-2-8.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#define FAVORATE_DEFAULT_NAME @"favorateactivity.plist"
#define CACHE_DEFAULT_NAME @"activitycache.plist"

#define ACTIVITY_LIST_PATH @"activitylist"

#import "JFActivity.h"
@interface JFActivity(){
    NSMutableArray *_activities;
    NSMutableDictionary *_cache;
}

@end
static JFActivity *_sharedInstance =nil;
@implementation JFActivity
+ (JFActivity *)sharedInstance{
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
    MKNetworkOperation *operation = [self operationWithPath:ACTIVITY_LIST_PATH];
    
    [operation addCompletionHandler:
     ^(MKNetworkOperation *op){
         NSArray *jsonArr=[op responseJSON];
         if ([jsonArr isKindOfClass:[NSArray class]]) {
             _activities=[NSMutableArray array];
             //get raw data
             
             [self readCache];
             //fresh cache
             for (int i =[jsonArr count]-1;i>=0;i--) {
                 JFOneActivity *activity = [[JFOneActivity alloc] initWithDictionary:jsonArr[i]];

                 if (_cache[activity.aid]) {

                 }
                 else{
                     [_cache setObject:activity forKey:activity.aid];
                 }
                 [_activities addObject:activity];
             }
             [self saveCache];
             if ([_activities count]) {
                 [self.delegate recievedActivities:[_activities objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(number, [_activities count]))]] error:nil];
             }
         }
         else{
             [self.delegate recievedActivities:nil error:[[NSError alloc] init]];
         }
         
     }
    errorHandler:^(MKNetworkOperation *op,NSError *er){
                    [self.delegate recievedActivities:nil error:er];
                       }];
    [self enqueueOperation:operation];
    
}

- (void)getActivitiesWithNumber:(NSUInteger)number{
    NSUInteger n;
    [self readCache];
    _activities = [NSMutableArray arrayWithArray:[self sortRoutes:[_cache allValues] option:ByTime]];
    n=MIN(number, [_activities count]);
    NSArray *result;
    if ([_activities count])
        result = [_activities objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, n)]];
    else
        result = [NSArray array];
    //reversed
    [self.delegate recievedActivities:[result sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        return [result indexOfObject:b] - [result indexOfObject:a];
    }]error:nil];
    return;
}
- (NSArray *)getFavorateActivities{
    NSArray *activities = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];
    //reversed
    return [activities sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        return [activities indexOfObject:b] - [activities indexOfObject:a];
    }];
}
- (BOOL)favorateWithActivity:(JFOneActivity *)activity{
    if (!activity) return NO;
    if (![activity isKindOfClass:[JFOneActivity class]]) return NO;
    
    NSMutableArray *activities;
    @try {
        activities = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME) error:&er];
        activities = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    if (![self isFavorateWithActivity:activity])
        [activities addObject:activity];
    
    [NSKeyedArchiver archiveRootObject:activities toFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];
    return YES;
}
- (BOOL)isFavorateWithActivity:(JFOneActivity *)activity{
    if (!activity) return NO;
    if (![activity isKindOfClass:[JFOneActivity class]]) return NO;
    
    NSArray *activities = [self getFavorateActivities];
    BOOL exist=NO;
    for (JFOneActivity *oneActivity in activities) {
        if ([oneActivity isKindOfClass:[JFOneActivity class]]) {
            if ([oneActivity.aid isEqualToNumber:oneActivity.aid])
                exist=YES;
        }
    }
    return exist;
}
- (void)deFavorateWithActivity:(JFOneActivity *)activity{
    if (!activity) return;
    if (![activity isKindOfClass:[JFOneActivity class]]) return;
    
    NSMutableArray *activities;
    @try {
        activities = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME) error:&er];
        activities = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)]];
    }
    
    for (JFOneActivity *oneActivity in activities) {
        if ([oneActivity isKindOfClass:[JFOneActivity class]]) {
            if ([oneActivity.aid isEqualToNumber:oneActivity.aid])
                [activities removeObject:oneActivity];
        }
    }
    
    [NSKeyedArchiver archiveRootObject:activities toFile:DOCUMENT_PATH(FAVORATE_DEFAULT_NAME)];

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