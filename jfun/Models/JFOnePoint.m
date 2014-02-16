//
//  JFOnePoint.m
//  jfun
//
//  Created by mmm on 14-2-14.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JFOnePoint.h"

@implementation JFOnePoint
- (instancetype)initWithDictionary:(NSDictionary *)dictionary Id:(NSUInteger)sid{
    NSMutableDictionary *newDic=[NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ([dictionary objectForKey:@"id"]) {
        [newDic removeObjectForKey:@"id"];
    }
    return [super initWithDictionary:newDic Id:sid];
}
- (NSDictionary *)dicitonaryValue{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[super dicitonaryValue]];
    NSDictionary *addDic=[self dictionaryWithValuesForKeys:@[@"location",@"timestart",@"timeend"]];
    [dic addEntriesFromDictionary:addDic];
    return dic;
}
@end
