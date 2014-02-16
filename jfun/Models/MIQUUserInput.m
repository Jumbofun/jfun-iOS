//
//  MIQUUserInput.m
//  jfun
//
//  Created by z y on 13-7-12.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import "MIQUUserInput.h"
@interface MIQUUserInput(){
    NSArray *_categoryEngStrings;
    NSArray *_categoryCNStrings;
}
@end
@implementation MIQUUserInput
@synthesize style,location;
- (MIQUUserInput *)init{
    if (self = [super init]) {
    }
    return self;
}
- (MIQUUserInput *)initWithStyle:(Style)sty location:(NSString *)loc fromTime:(NSInteger)startt toTime:(NSInteger)endt{
    if (self = [super init]) {
        [self setStyle:sty];
        [self setLocation:loc];
        [self setStartTime:startt];
        [self setEndTime:endt];
        
    }
    return self;
}

- (NSArray *)stringsForAllLocation{
    return @[@"武林", @"湖滨", @"吴山", @"黄龙", @"庆春", @"城西", @"城北", @"钱江新城", @"滨江", @"下沙", @"九堡",@"钱江世纪城"];
}
- (void)updateLocationStrings:(NSArray *)locations{
    if (!locations && ![locations count]) {
        return;
    }
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:locations];
    
    for (id obj in tmp) {
        if (![obj isKindOfClass:[NSString class]]) {
            [tmp removeObject:obj];
        }
    }
}
- (TimeType)timeTypeForTimeString:(NSString *)timeStr{
    NSArray *timeStringArr=@[@"breakfast",@"morning",@"lunch",@"afternoon",@"dinner",@"night",@"midnight"];
    for (int i=0; i<[timeStringArr count]; i++) {
        if ([timeStringArr[i] isEqualToString:timeStr]) {
            return (TimeType)i;
        }
    }
    return 0;
}
- (NSString *)timeStringForTimeType:(TimeType)timetype{
    NSArray *timeStringArr=@[@"早餐",@"上午",@"午餐",@"下午",@"晚餐",@"晚上",@"通宵"];
    return timeStringArr[timetype];
}
- (NSString *)timeEngStringForTimeType:(TimeType)timetype{
    NSArray *timeStringArr=@[@"breakfast",@"morning",@"lunch",@"afternoon",@"dinner",@"night",@"midnight"];
    return timeStringArr[timetype];
}
@end
