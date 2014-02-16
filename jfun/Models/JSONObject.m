//
//  JSONObject.m
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JSONObject.h"

@implementation JSONObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"Undefined key %@ with value:%@",key,value);
}
#pragma mark NSCoding delegate
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self dicitonaryValue]];
        for (NSString *key in [dic allKeys]) {
            dic[key]=[aDecoder decodeObjectForKey:key];
        }
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *dic = [self dicitonaryValue];
    for (NSString *key in [dic allKeys]) {
        [aCoder encodeObject:dic[key] forKey:key];
    }
}
- (NSDictionary *)dicitonaryValue{
    return nil;
}
@end
