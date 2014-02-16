//
//  MIQUJFun.m
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//
#define HISTORY_ROUTES_NAME @"historyroutes.plist"
#define CURRENT_ROUTE_NAME @"currentroute.plist"

#import "MIQUJFun.h"
//#import "MobileProbe.h"
@interface MIQUBriefStore:NSObject
@property (strong,nonatomic) NSNumber *storeId;
@property (nonatomic) CategoryType category;
@end
@implementation MIQUBriefStore
@synthesize storeId,category;
@end

@interface MIQUJFun (){
    MIQUInfoList *_infoList;
    MIQUUserInput *_userInput;
    NSMutableArray *_allStoreBriefInfoArr;
}
@end

@implementation MIQUJFun
@synthesize delegate;
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
- (void)addStoreBriefInfoWithDic:(NSDictionary *)storeDic{
    if (!storeDic) return;
    MIQUBriefStore *briefStore = [[MIQUBriefStore alloc] init];
    CategoryType category = [JFOneStore categoryTypeForString:[storeDic valueForKey:@"category"]];
    NSNumber *storeId = [storeDic valueForKey:@"id"];
    TimeType time = [[MIQUUserInput new] timeTypeForTimeString:[storeDic valueForKey:@"timeslot"]];
    if (!storeId) return;
    
    briefStore.storeId = storeId;
    briefStore.category = category;
    [[_allStoreBriefInfoArr objectAtIndex:time] addObject:briefStore];
}
- (void)delecateJfunDidFreshing:(NSNumber *)isError{
    [delegate JfunDidFreshing:[isError boolValue]];
}
- (MIQUJFun *)initWithUserInfo:(MIQUUserInput *)userInput{
    if (self = [super init]) {
        _userInput = userInput;
        _infoList = [[MIQUInfoList alloc] init];
        _allStoreBriefInfoArr = [NSMutableArray array];

        for (int i = 0; i < 7; i++) {
            [_allStoreBriefInfoArr addObject:[NSMutableArray array]];
        }
    }
    return self;
}
+ (MIQUJFun *)newInstanceWithUserInfo:(MIQUUserInput *)userInput{
    return [[MIQUJFun alloc] initWithUserInfo:userInput];
}
- (void)startFreshFromServer{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%d",_userInput.style] forKey:@"style"];
    [params setValue:[NSString stringWithFormat:@"%d",_userInput.startTime] forKey:@"time_start"];
    [params setValue:[NSString stringWithFormat:@"%d",_userInput.endTime] forKey:@"time_end"];
    [params setValue:[NSString stringWithFormat:@"%@",_userInput.location] forKey:@"location"];
    [params setValue:[NSString stringWithFormat:@"%@",[JFOneStore stringForCategory:allCategory]] forKey:@"category"];
    NSURLRequest *request = [self prepareRequestWithURLString:@"http://*/jfun/infolistid" GET:params];
    [NSThread detachNewThreadSelector:@selector(freshFromServer:) toTarget:self withObject:request];
}
- (void)freshFromServer:(NSURLRequest *)req{
    NSData *httpdata;
    NSError *er;
    NSURLResponse *response;
    BOOL isError = NO;
    //get store ids
    httpdata = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&er];
    if (httpdata) {
        @try {
            NSArray *jsonArr = [self jsonToArr:httpdata];
            for (NSDictionary *storeDic in jsonArr) {
                [self addStoreBriefInfoWithDic:storeDic];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            isError = YES;
        }
        
    }
    else
        isError = YES;
    //get store infolist
    if (!isError) {
        for (int i = 0; i < 7; i++) {
            [self startFreshFromServerByTime:i];
        }
    }
    //[MobileProbe triggerEventWithName:@"产生路线" count:1];
    [self performSelectorOnMainThread:@selector(delecateJfunDidFreshing:) withObject:[NSNumber numberWithBool:isError] waitUntilDone:NO];
}
- (void)startFreshFromServerByTime:(TimeType)time{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *briefStoresArr = [_allStoreBriefInfoArr objectAtIndex:time];
    if (!briefStoresArr || ![briefStoresArr count]) return;
    //add store id from cache
    for (MIQUBriefStore *bstore in briefStoresArr) {
        [tempArr addObject:bstore.storeId];
    }
    [[JFStore sharedInstance] startFreshFromServerWithSids:tempArr time:time completeBlock:^(NSDictionary *result){
        if (!result||![result count]) return ;
        
        for (JFOneStore *store in [result allValues]) {
            [_infoList addStoreWithTime:time store:store];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFreshByTime" object:self userInfo: @{@"timeType":[NSNumber numberWithInteger:time]}];
    }];
   
}
- (void)startFreshFromServerByTime:(TimeType)time categoty:(CategoryType)type{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *briefStoresArr = [_allStoreBriefInfoArr objectAtIndex:time];
    NSMutableArray *tempBriefStoresArr = [NSMutableArray array];
    //limit certain category
    for (MIQUBriefStore *briefStore in briefStoresArr) {
        if (briefStore.category == type) {
            [tempBriefStoresArr addObject:briefStore];
        }
    }
    if (!tempBriefStoresArr || ![tempBriefStoresArr count]) return;
    //add store id from cache
    for (MIQUBriefStore *bstore in tempBriefStoresArr) {
        [tempArr addObject:bstore.storeId];
    }
    
    [[JFStore sharedInstance] startFreshFromServerWithSids:tempArr time:time completeBlock:^(NSDictionary *result){
        if (!result||![result count]) return ;
        
        for (JFOneStore *store in [result allValues]) {
            [_infoList addStoreWithTime:time store:store];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFreshByTime" object:self userInfo: @{@"timeType":[NSNumber numberWithInteger:time]}];
    }];

    
}
- (NSArray *)getInfoListRows{
    NSMutableArray *rows = [NSMutableArray array];
    for (NSNumber *timeNumber in [self getTimes]) {
        MIQUInfoListRow *row = [MIQUInfoListRow rowWithTime:[timeNumber integerValue] stores:[_infoList getArrByTime:[timeNumber integerValue]]];
        
        row.jFun = self;
        row.categoty = allCategory;
        [rows addObject:row];
    }
    return rows;
}
- (NSArray *)getTimes{
    NSMutableArray *tms = [NSMutableArray array];
    for (int i = 0; i < [_infoList.times count]; i++) {
        if ([_infoList.times[i] boolValue])
            [tms addObject:[NSNumber numberWithInteger:i]];
    }
    return tms;
}
- (NSArray *)getAllStoresByTime:(TimeType)time{
    return [NSArray arrayWithArray:[_infoList getArrByTime:time]];
}
- (void)clearData{
    _infoList = [[MIQUInfoList alloc] init];
    _allStoreBriefInfoArr = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        [_allStoreBriefInfoArr addObject:[NSMutableArray array]];
    }
    
}
- (UIImage *)imageWithSelectedStores:(NSArray *)selectedStores{
    int n = [selectedStores count];
    CGSize contextSize = CGSizeMake(320, n<=4?480:480+(n-4)*70);
    UIGraphicsBeginImageContext(contextSize);
    UIImage *topImg = [UIImage imageNamed:@"shareUpPart.png"];
    UIImage *middleImg = [UIImage imageNamed:@"shareMiddlePart.png"];
    UIImage *bottomImg = [UIImage imageNamed:@"shareDownPart.png"];
    //top img
    [topImg drawAtPoint:CGPointMake(0, 0)];
    //middle img
    [middleImg drawInRect:CGRectMake(0, topImg.size.height, contextSize.width, contextSize.height-topImg.size.height-bottomImg.size.height)];
    //bottom img
    [bottomImg drawAtPoint:CGPointMake(0, contextSize.height-bottomImg.size.height)];
    
    //store img
    UIImage *circleImg = [UIImage imageNamed:@"shareCircle.png"];
    UIImage *pointsLImg = [UIImage imageNamed:@"share6PointsL.png"];
    UIImage *pointsRImg = [UIImage imageNamed:@"share6PointsR.png"];
    
    for (NSInteger i = 0;i<=n;i++) {
        //store & circle img
        UIImage *img;
        if (i == 0) {
            img = [self cutImage:[UIImage imageNamed:@"icon.png"]];
        }
        else{
            MIQUInfoListRow *storeRow = selectedStores[i-1];
            img = [self getImage:storeRow.lastStore.photos[0]];
        }
        [img drawAtPoint:CGPointMake(i%2==0?45:205,55+i*70)];
        [circleImg drawAtPoint:CGPointMake(i%2==0?37:197,47+i*70)];
        //points
        if (i!=n) {
            if (i%2==0) {
                [pointsLImg drawAtPoint:CGPointMake(145, 88+70*i)];
            }
            else{
                [pointsRImg drawAtPoint:CGPointMake(125, 95+70*i)];
            }
        }
        [[UIColor whiteColor] set];
        NSString *timeStr;
        if (i!=0) {
            //time string
            MIQUInfoListRow *storeRow = selectedStores[i-1];
            timeStr = [[MIQUUserInput new] timeStringForTimeType:storeRow.time];
        }
        else{
            timeStr = @"粗发！";
        }
        [timeStr drawInRect:CGRectMake(i%2==0?45:205,92+i*70, 94, 40) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        
        //name string
        NSString *nameStr;
        if (i == 0) {
            nameStr = @"";
        }
        else{
            MIQUInfoListRow *storeRow = selectedStores[i-1];
            nameStr = storeRow.lastStore.name;
        }
        [nameStr drawInRect:CGRectMake(i%2==0?45:205,158+i*70, 94, 20) withFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


         
- (UIImage *)getImage:(NSString *)urlStr{
    if (!urlStr) return nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *img = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (!img) img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (!img) {
        NSURLResponse *response;
        NSError *er;
        NSMutableURLRequest *connection = [NSMutableURLRequest requestWithURL:url];
        connection.timeoutInterval = TIME_OUT;
        NSData *data = [NSURLConnection sendSynchronousRequest:connection returningResponse:&response error:&er];
        if (data)
            img = [UIImage imageWithData:data];
    }
    if (img) {
        return [self cutImage:img];
    }
    else
        return nil;
}
- (UIImage *)cutImage:(UIImage *)img{
    UIGraphicsBeginImageContext(CGSizeMake(94, 94));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //fill clear color
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 94, 94));
    //clip context
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 94, 94));
    CGContextClip(context);
    //draw img
    [img drawInRect:CGRectMake(0, 0, 94, 94)];
    /*draw inner circle
    CGContextSetLineWidth(context, 11);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor );
    CGContextStrokeEllipseInRect(context, CGRectMake(2, 2, 214, 214));
    //draw outter circle
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor );
    CGContextStrokeEllipseInRect(context, CGRectMake(2, 2, 214, 214));
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 94, 94));
    CGContextStrokePath(context);*/
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
- (JFOneRoute *)generateRouteWithStores:(NSArray *)stores{
    JFOneRoute *route = [[JFOneRoute alloc] init];
    if (![stores[0] isKindOfClass:[JFOneStore class]])
        return route;
    NSMutableArray *ids = [NSMutableArray array];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"您于yyyy年MM日dd创建的线路"];
    [formatter setLocale:[NSLocale systemLocale]];
    
    NSString *title = [formatter stringFromDate:date];
    NSMutableString *description= [NSMutableString stringWithFormat:@""];
    for (JFOneStore *store in stores) {
        [ids addObject:store.sid];
        if ([stores lastObject]!=store)
            [description appendFormat:@"%@、",store.name];
        else
            [description appendFormat:@"%@",store.name];
    }
    route.storeIDs = ids;
    route.title=title;
    route.description=description;
    route.time=date;
    route.rid = [NSNumber numberWithInteger:-1];
    
    //read file
    NSArray *historyArr;
    @try {
        historyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(HISTORY_ROUTES_NAME)];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(HISTORY_ROUTES_NAME) error:&er];
    }

    //add history
    NSMutableArray *historyMArr = [NSMutableArray arrayWithArray:historyArr];
    [historyMArr addObject:route];
    //write file
    [NSKeyedArchiver archiveRootObject:historyMArr toFile:DOCUMENT_PATH(HISTORY_ROUTES_NAME)];
    [NSKeyedArchiver archiveRootObject:route toFile:DOCUMENT_PATH(CURRENT_ROUTE_NAME)];
    return route;
}
- (JFOneRoute *)currentRoute{
    JFOneRoute *route;
    @try {
        route = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(CURRENT_ROUTE_NAME)];
    }
    @catch (NSException *exception) {
        route=nil;
    }
    return route;

}
- (NSArray *)historyRoutes{
    NSArray *historyArr;
    @try {
        historyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(HISTORY_ROUTES_NAME)];
    }
    @catch (NSException *exception) {
        NSError *er;
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_PATH(HISTORY_ROUTES_NAME) error:&er];
        historyArr = @[];
    }
    return [historyArr sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        return [historyArr indexOfObject:b] - [historyArr indexOfObject:a];
    }];
}
@end
