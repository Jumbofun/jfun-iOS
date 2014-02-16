//
//  MIQUInfoList.h
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIQUInfoList : NSObject{
    
}
@property (nonatomic,strong) NSMutableArray *breakfastStore;
@property (nonatomic,strong) NSMutableArray *morningStore;
@property (nonatomic,strong) NSMutableArray *lunchStore;
@property (nonatomic,strong) NSMutableArray *afternoonStore;
@property (nonatomic,strong) NSMutableArray *supperStore;
@property (nonatomic,strong) NSMutableArray *nightStore;
@property (nonatomic,strong) NSMutableArray *midnightStore;
@property (nonatomic,strong) NSMutableArray *times;

- (void)addStoreWithTime:(TimeType)time store:(JFOneStore *)store;
- (NSMutableArray *)getArrByTime:(TimeType)time;

@end
