//
//  MIQUUserInput.h
//  jfun
//
//  Created by z y on 13-7-12.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum Style : NSUInteger{
    none,
    lovers,
    friends,
    business,
    famliy
}StyleType;



typedef enum time : NSUInteger{
    breakfast,morning,lunch,afternoon,dinner,night,midnight
}TimeType;

@interface MIQUUserInput : NSObject{
}
@property (nonatomic) StyleType style;
@property (nonatomic,strong) NSString *location;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;

- (MIQUUserInput *)initWithStyle:(Style)sty location:(NSString *)loc fromTime:(NSInteger)startt toTime:(NSInteger)endt;



- (NSArray *)stringsForAllLocation;
- (void)updateLocationStrings:(NSArray *)locations;

- (TimeType)timeTypeForTimeString:(NSString *)timeStr;
- (NSString *)timeStringForTimeType:(TimeType)timetype;
- (NSString *)timeEngStringForTimeType:(TimeType)timetype;
@end
