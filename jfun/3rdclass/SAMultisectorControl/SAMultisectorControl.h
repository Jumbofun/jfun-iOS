//
//  SAMultisectorControl.h
//  CustomControl
//
//  Created by Snipter on 12/31/13.
//  Copyright (c) 2013 SmartAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMath.h"

@class SAMultisectorSector;


@interface SAMultisectorControl : UIControl

@property (strong, nonatomic, readonly) NSArray *sectors;

@property (nonatomic, readwrite) double sectorsRadius;
@property (nonatomic, readwrite) double startAngle;
@property (nonatomic, readwrite) double minCircleMarkerRadius;
@property (nonatomic, readwrite) double maxCircleMarkerRadius;
@property (nonatomic, strong) UIColor *emptyCircleColor;

- (void)addSector:(SAMultisectorSector *)sector;
- (void)removeSector:(SAMultisectorSector *)sector;
- (void)removeAllSectors;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (void)setStartValueWithSector:(SAMultisectorSector *)sector value:(double)value;
- (void)setEndValueWithSector:(SAMultisectorSector *)sector value:(double)value;

@end



@interface SAMultisectorSector : NSObject

@property (strong, nonatomic) UIColor *color;

@property (nonatomic, readwrite) double minValue;
@property (nonatomic, readwrite) double maxValue;
@property (nonatomic, readwrite) BOOL isSingle;
@property (nonatomic, readwrite) double startValue;
@property (nonatomic, readwrite) double endValue;

@property (nonatomic, readwrite) NSInteger tag;

- (instancetype) init;

+ (instancetype) sector;
+ (instancetype) sectorWithColor:(UIColor *)color;
+ (instancetype) sectorWithColor:(UIColor *)color maxValue:(double)maxValue;
+ (instancetype) sectorWithColor:(UIColor *)color minValue:(double)minValue maxValue:(double)maxValue;
@end
