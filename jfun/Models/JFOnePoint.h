//
//  JFOnePoint.h
//  jfun
//
//  Created by mmm on 14-2-14.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JSONObject.h"
/*
 {
 address: "西湖区曙光路白沙泉48号(近浙江图书馆)",
 category: "game",
 description: "美食美器,陶艺时光",
 id: 91,
 link: [
 "http://site.douban.com/190616/"
 ],
 location: "黄龙",
 name: "禾下陶社",
 phone: "0571-87298662",
 plink: [
 "http://nacute.com:8080/jfun/photo/1000606/1.jpg",
 "http://nacute.com:8080/jfun/photo/1000606/2.jpg",
 "http://nacute.com:8080/jfun/photo/1000606/3.jpg"
 ],
 price: 84,
 rating: "4.5",
 style: 1,
 timeend: 2130,
 timestart: 1330
 }
 */

@interface JFOnePoint : JFOneStore
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSNumber *timestart;
@property (nonatomic,strong) NSNumber *timeend;

@end
