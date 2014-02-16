//
//  JFOneStore.m
//  jfun
//
//  Created by mmm on 14-2-6.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JFOneStore.h"

@implementation JFOneStore
+ (NSArray *)categoryEngStrings{
    static NSArray *strings;
   strings= @[@"food",@"ktv",@"cinema",@"hotel",@"club",@"cafe",@"sports",@"park",@"shopping",@"game",@"recreation",@"default"];
    return strings;
}
+ (NSArray *)categoryCNStrings{
    static NSArray *strings;
    strings= @[@"餐厅",@"KTV",@"电影院",@"宾馆",@"俱乐部",@"咖啡",@"运动",@"公园",@"商场",@"游戏",@"休闲",@"default"];
    return strings;
}
+ (NSString *)engStringForCategory:(CategoryType)cate{
    return [self categoryEngStrings][cate];
}
+ (NSString *)stringForCategory:(CategoryType)cate{
    return [self categoryCNStrings][cate];
}
+ (CategoryType)categoryTypeForString:(NSString *)typStr{
    for (int i = 0; i < [[self categoryEngStrings] count]; i++) {
        if ([[[self categoryEngStrings] objectAtIndex:i] isEqualToString:typStr]) {
            return i;
        }
    }
    return [[self categoryEngStrings] count] - 1;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    return nil;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary Id:(NSUInteger)sid{
    //name conflict
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ([dic objectForKey:@"link"]) {
        [dic setObject:[dic objectForKey:@"link"] forKey:@"links"];
        [dic removeObjectForKey:@"link"];
    }
    if ([dic objectForKey:@"plink"]) {
        [dic setObject:[dic objectForKey:@"plink"] forKey:@"photos"];
        [dic removeObjectForKey:@"plink"];

    }
    [dic setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [super initWithDictionary:dic];
}

#pragma mark NSCoding delegate

- (NSDictionary *)dicitonaryValue{
    NSDictionary *dic = [self dictionaryWithValuesForKeys:@[@"sid",@"name",@"address",@"phone",@"description",@"price",@"photos",@"links",@"rating",@"category",@"lid1"]];
    return dic;
}

@end
