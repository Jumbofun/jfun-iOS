//
//  JFOneStore.h
//  jfun
//
//  Created by mmm on 14-2-6.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JSONObject.h"
typedef enum category : NSUInteger{
    food,ktv,cinema,hotel,club,cafe,sports,park,shopping,game,recreation,allCategory
}CategoryType;
/*
 address: "下城区体育场路147号(浙江日报社对面)",
 category: "food",
 description: "店面不大，却收拾得干净整洁，明亮的灯光打在各式西点上，看着超有食欲。北海道香浓土司奶香浓郁，红枣桂圆奶茶不甜不腻，两者搭配做下午茶刚刚好。店员态度很好，感觉蛮贴心。",
 lid1: "",
 link1: "http://www.dianping.com/shop/3125863",
 name: "可莎蜜兒(体育场路店)",
 phone: "0571-85185991",
 photo1: "http://nacute.com:8080/jfun/photo/1888/",
 plink1: "http://nacute.com:8080/jfun/photo/1888/1.jpg",
 plink2: "http://nacute.com:8080/jfun/photo/1888/2.jpg",
 plink3: "http://nacute.com:8080/jfun/photo/1888/3.jpg",
 price: 17,
 rating: 4.5
 */
@interface JFOneStore : JSONObject
+ (NSArray *)categoryEngStrings;
+ (NSArray *)categoryCNStrings;
+ (NSString *)engStringForCategory:(CategoryType)cate;
+ (NSString *)stringForCategory:(CategoryType)cate;
+ (CategoryType)categoryTypeForString:(NSString *)typStr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary DEPRECATED_ATTRIBUTE;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary Id:(NSUInteger)sid;
- (NSDictionary *)dicitonaryValue;

@property (nonatomic,strong) NSNumber *sid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *lid1;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *links;
@property (nonatomic,strong) NSNumber *rating;
@property (nonatomic,strong) NSString *category;

@end
