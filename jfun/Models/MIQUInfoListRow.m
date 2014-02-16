//
//  MIQUInfoListRow.m
//  jfun
//
//  Created by z y on 13-7-19.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import "MIQUInfoListRow.h"
@interface MIQUInfoListRow(){
    NSMutableString *_decriptionStr;
}
@end
@implementation MIQUInfoListRow
@synthesize time,stores,categoty,lastStore,cell,jFun;
+ (MIQUInfoListRow *)rowWithTime:(TimeType)time stores:(NSArray *)strs{
    MIQUInfoListRow *row = [[MIQUInfoListRow alloc] init];
    [row setTime:time];
    [row setStores:[NSMutableArray arrayWithArray:strs]];
    [row setLastStore:strs[0]];
    [row setCategoty:allCategory];
    [[NSNotificationCenter defaultCenter] addObserver:row selector:@selector(didFreshByTime:) name:@"didFreshByTime" object:nil];
    return row;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)getArr{
    return [self getArrByCategory:self.categoty];
}
- (NSMutableArray *)getArrByCategory:(CategoryType)type{
    if (type == allCategory) {
        return self.stores;
    }
    NSMutableArray *tempStores = [NSMutableArray arrayWithArray:stores];
    for (int i = [tempStores count] - 1;i >= 0; i--) {
        JFOneStore *store = tempStores[i];
        if (![store.category isEqualToString: [JFOneStore engStringForCategory:type] ]) {
            [tempStores removeObjectAtIndex:i];
        }
    }
    return tempStores;
}

/*- (CGFloat)getDescriptionHeight{
    [self getDecriptionStr];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [_decriptionStr sizeWithFont:font constrainedToSize:CGSizeMake(215, MAXFLOAT)];
    return CELL_HEIGHT + 10 + size.height;
}*/

- (void)didFreshByTime{
    
}
- (void)didFreshByTime:(NSNotification *)notification{
    TimeType _time = [[[notification userInfo] valueForKey:@"timeType"] integerValue];
    if (_time != self.time) return;

    [self setStores:[NSMutableArray arrayWithArray:[(MIQUJFun *)self.jFun getAllStoresByTime:time]]];
    [self.cell rowDidFresh:self];
}
@end
