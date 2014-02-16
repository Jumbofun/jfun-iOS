//
//  JFOneActivity.m
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JFOneActivity.h"

@implementation JFOneActivity
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ([dic objectForKey:@"enddate"]&&[dic objectForKey:@"endtime"]) {
        [dic setObject:[self dateWithDateString:[dic objectForKey:@"enddate"] time:[dic objectForKey:@"endtime"]] forKey:@"enddatetime"];
        [dic removeObjectsForKeys:@[@"enddate",@"endtime"]];
    }
    if ([dic objectForKey:@"startdate"]&&[dic objectForKey:@"starttime"]) {
        [dic setObject:[self dateWithDateString:[dic objectForKey:@"startdate"] time:[dic objectForKey:@"starttime"]] forKey:@"startdatetime"];
        [dic removeObjectsForKeys:@[@"startdate",@"starttime"]];
    }
    if ([dic objectForKey:@"id"]) {
        [dic setObject:[dic objectForKey:@"id"] forKey:@"aid"];
        [dic removeObjectForKey:@"id"];
    }
    return [super initWithDictionary:dic];
}
- (NSDate *)dateWithDateString:(NSString *)dateS time:(NSString *)timeS{
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",dateS,timeS];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    formatter.dateFormat=@"yyyy-MM-dd HHmm";
    
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}
- (NSDictionary *)dicitonaryValue{
    
    NSDictionary *dic = [self dictionaryWithValuesForKeys:@[@"address",@"category",@"description",@"enddatetime",@"hightestprice",@"aid",@"link",@"location",@"lowestprice",@"name",@"plink",@"startdatetime",@"weight"]];
    return dic;
}
@end
