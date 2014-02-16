//
//  JFActivity.h
//  jfun
//
//  Created by mmm on 14-2-8.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "MKNetworkEngine.h"


@protocol JFActivityDelegate<NSObject>
@required
- (void)recievedActivities:(NSArray *)activities error:(NSError *)er;
@end

@interface JFActivity : MKNetworkEngine

+ (instancetype)sharedInstance;

- (void)startFreshFromServerWithReturnNumber:(NSUInteger)number;

//- (NSArray *)getRoutes;
- (void)getActivitiesWithNumber:(NSUInteger)number;
- (NSArray *)getFavorateActivities;
- (BOOL)favorateWithActivity:(JFOneActivity *)activity;
- (BOOL)isFavorateWithActivity:(JFOneActivity *)activity;
- (void)deFavorateWithActivity:(JFOneActivity *)activity;

@property (weak,nonatomic) id<JFActivityDelegate> delegate;
@end
