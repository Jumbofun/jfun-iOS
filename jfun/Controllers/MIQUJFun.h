//
//  MIQUJFun.h
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFunUserInfoDelegate <NSObject>
@optional
- (void)JfunDidFreshing:(BOOL)isError;
@end

@interface MIQUJFun: NSObject<RenrenDelegate>{
   
}

@property (weak,nonatomic) id <JFunUserInfoDelegate> delegate;

//根据userinput实例化
+ (MIQUJFun *)newInstanceWithUserInfo:(MIQUUserInput *)userInput;
- (MIQUJFun *)initWithUserInfo:(MIQUUserInput *)userInput;
//从服务器获取数据
- (void)startFreshFromServer;
- (void)startFreshFromServerByTime:(TimeType)time;
- (void)startFreshFromServerByTime:(TimeType)time categoty:(CategoryType)type;

- (NSArray *)getInfoListRows;
- (NSArray *)getTimes;
- (NSArray *)getAllStoresByTime:(TimeType)time;

- (void)clearData;

- (UIImage *)imageWithSelectedStores:(NSArray *)selectedStores;

- (JFOneRoute *)generateRouteWithStores:(NSArray *)stores;
- (JFOneRoute *)currentRoute;
- (NSArray *)historyRoutes;
@end


