//
//  JFOneRoute.h
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JSONObject.h"
/*
 {
 bad: 0,
 description: "",
 good: 0,
 id: [
 0,
 70,
 71,
 72,
 19,
 73,
 21,
 22,
 0,
 0
 ],
 night: 0,
 rid: 19,
 style: "",
 title: ""
 },
 */
@interface JFOneRoute : JSONObject

@property (strong,nonatomic) NSNumber *rid;
@property (strong,nonatomic) NSNumber *bad;
@property (strong,nonatomic) NSNumber *good;
@property (strong,nonatomic) NSNumber *night;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *style;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSArray *storeIDs;
@property (strong,nonatomic) NSNumber *hot;
@property (strong,nonatomic) NSDate *time;
@property (strong,nonatomic) NSString *picURL;

- (BOOL)isGenerated;
@end
