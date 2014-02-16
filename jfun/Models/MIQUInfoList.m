//
//  MIQUInfoList.m
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import "MIQUInfoList.h"

@implementation MIQUInfoList
@synthesize supperStore,afternoonStore,breakfastStore,lunchStore,midnightStore,morningStore,nightStore,times;
- (NSMutableArray *)getArrByTime:(TimeType)time{
    switch (time) {
        case breakfast:
            return breakfastStore?breakfastStore:(breakfastStore=[NSMutableArray array]);
        case morning:
            return morningStore?morningStore:(morningStore=[NSMutableArray array]);
        case lunch:
            return lunchStore?lunchStore:(lunchStore=[NSMutableArray array]);
        case afternoon:
            return afternoonStore?afternoonStore:(afternoonStore=[NSMutableArray array]);
        case dinner:
            return supperStore?supperStore:(supperStore=[NSMutableArray array]);
        case night:
            return nightStore?nightStore:(nightStore=[NSMutableArray array]);
        case midnight:
            return midnightStore?midnightStore:(midnightStore=[NSMutableArray array]);
        default:
            return nil;
            break;
    }
}

- (void)addStoreWithTime:(TimeType)time store:(JFOneStore *)store{
    if (!times) times = [NSMutableArray arrayWithArray:@[@NO,@NO,@NO,@NO,@NO,@NO,@NO]];
    times[time] = @YES;
    [[self getArrByTime:time] addObject:store];
}


@end
