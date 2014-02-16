//
//  JFOneActivity.h
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
/*
 
 address: "杭州 西湖区 中海金溪园",
 category: "聚会",
 description: "11月12日 ~ 2014年02月09日 每天09:30-21:30 活动详情 【谷陶社】　一个属于陶器的乌托邦国度，这里可以喝喝茶听听音乐玩玩泥巴聊聊天…..动手做自己喜欢的东西，欢迎所有喜欢玩泥巴的孩子们前来。 【活动项目——手捏陶艺体验，亲子陶艺，拉坯体验】： 1、 陶艺手工捏雕制作。提供泥巴及四块彩色泥条，工具任选，作品上釉，包烧出一件成品。（时间不限，88元/人） 2、陶艺手工拉坯。提供两袋泥巴，教授如何拉基础的杯子碗，作品完成，可以选择上色上釉，包烧一件作品。（时间不限，98元/人） 3、陶艺DIY（釉上彩）绘画。提供泥坯杯子/碗任选一件，釉下彩颜料，包上釉烧制出一件成品。（时间不限，88元/人） 以上内容都有老师授课指导，制作完成，约两三周后可以将自制陶艺作品带回家。 【陶艺专业课程】：兴趣班 专业学徒班 【陶艺活动项目】：公司聚会 外场互动活动 　 【详细地址】：金家渡路古墩路口，中海金溪园内。可以乘坐B2、B支1、389路、204路夜班。开车过来，院内免费两小时停车。找不到位置可以打电话。 【联系方式】：15868162432小谷 新浪微博：http://weibo.com/junty1985 【营业时间】：　周一至周五　 下午13:30--21:00 　　　　　　　　周六至周日　　上午09:30--12:00　　　　下午1:30--21:00",
 enddate: "2014-02-09",
 endtime: 2130,
 hightestprice: 0,
 id: 200003,
 link: [
 "http://www.douban.com/event/20246447/"
 ],
 location: "12",
 lowestprice: 88,
 name: "谷陶社——陶艺DIY制作",
 plink: [
 "http://nacute.com:8080/jfun/photo/2200003/2200003.jpg"
 ],
 startdate: "2013-11-12",
 starttime: 930,
 weight: 0
 
 */

#import "JSONObject.h"

@interface JFOneActivity : JSONObject

@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSDate *enddatetime;
@property (strong,nonatomic) NSNumber *hightestprice;
@property (strong,nonatomic) NSNumber *aid;
@property (strong,nonatomic) NSArray *link;
@property (strong,nonatomic) NSString *location;
@property (strong,nonatomic) NSNumber *lowestprice;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSArray *plink;
@property (strong,nonatomic) NSDate *startdatetime;
@property (strong,nonatomic) NSNumber *weight;


@end
