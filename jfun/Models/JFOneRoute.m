//
//  JFOneRoute.m
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JFOneStore.h"

@implementation JFOneRoute

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    //name conflict
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ([dic objectForKey:@"id"]) {
        [dic setObject:[dic objectForKey:@"id"] forKey:@"storeIDs"];
        [dic removeObjectForKey:@"id"];
    }
    self.hot  =[NSNumber numberWithInteger:[self.good integerValue]+[self.bad integerValue]];
    return [super initWithDictionary:dic];
}


- (NSDictionary *)dicitonaryValue{

    NSDictionary *dic = [self dictionaryWithValuesForKeys:@[@"rid",@"bad",@"good",@"night",@"title",@"style",@"description",@"storeIDs",@"hot",@"time",@"picURL"]];
    return dic;
}

- (BOOL)isGenerated{
    return [self.rid integerValue]==-1?YES:NO;
}
@end
