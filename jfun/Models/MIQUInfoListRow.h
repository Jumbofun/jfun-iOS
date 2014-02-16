//
//  MIQUInfoListRow.h
//  jfun
//
//  Created by z y on 13-7-19.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFunUserInfoRowDelegate <NSObject>
- (void)rowDidFresh:(id)sender;
@end

@interface MIQUInfoListRow : NSObject

@property (weak,nonatomic) id jFun;
@property (weak,nonatomic) id<JFunUserInfoRowDelegate> cell;
@property (strong,nonatomic) NSMutableArray *stores;
@property (nonatomic) TimeType time;

@property (nonatomic) CategoryType categoty;
@property (weak,nonatomic) JFOneStore *lastStore;

+ (MIQUInfoListRow *)rowWithTime:(TimeType)time stores:(NSArray *)strs;
- (NSMutableArray *)getArr;
- (NSMutableArray *)getArrByCategory:(CategoryType)type;

@end
