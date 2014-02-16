//
//  JFRoute.h
//  jfun
//
//  Created by mmm on 14-2-4.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JFRouteDelegate<NSObject>
@required
- (void)recievedRoutes:(NSArray *)routes error:(NSError *)er;
@end

@interface JFRoute : MKNetworkEngine

+ (instancetype)sharedInstance;

- (void)startFreshFromServerWithReturnNumber:(NSUInteger)number;

//- (NSArray *)getRoutes;
- (void)getRoutesWithNumber:(NSUInteger)number;
- (NSArray *)getFavorateRoutes;
- (BOOL)favorateWithRoute:(JFOneRoute *)route;
- (BOOL)isFavorateWithRoute:(JFOneRoute *)route;
- (void)deFavorateWithRoute:(JFOneRoute *)route;

@property (weak,nonatomic) id<JFRouteDelegate> delegate;
@end
