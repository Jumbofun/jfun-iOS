//
//  SAMultisectorControl.m
//  CustomControl
//
//  Created by Snipter on 12/31/13.
//  Copyright (c) 2013 SmartAppStudio. All rights reserved.
//

#import "SAMultisectorControl.h"

#define saCircleLineWidth 12.0
#define saCircleUnselectedLineWidth 8.0
#define saMarkersLineWidth 5.0

#define A_FUNC(x,maxX,maxY) (maxY*x*(maxX*2.0-x)/maxX/maxX)
typedef struct{
    CGPoint circleCenter;
    CGFloat radius;
    
    double fullLine;
    double circleOffset;
    double circleLine;
    double circleEmpty;
    
    double circleOffsetAngle;
    double circleLineAngle;
    double circleEmptyAngle;
    
    CGPoint startMarkerCenter;
    CGPoint endMarkerCenter;
    
    CGFloat startMarkerRadius;
    CGFloat endMarkerRadius;
    
    CGFloat startMarkerFontSize;
    CGFloat endMarkerFontize;
    
    CGFloat startMarkerAlpha;
    CGFloat endMarkerAlpha;
    
    BOOL isSingle;
    
} SASectorDrawingInformation;


@implementation SAMultisectorControl{
    NSMutableArray *sectorsArray;
    
    SAMultisectorSector *trackingSector;
    SASectorDrawingInformation trackingSectorDrawInf;
    BOOL trackingSectorStartMarker;
}

#pragma mark - Initializators

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (void) setupDefaultConfigurations{
    [self becomeFirstResponder];
    
    sectorsArray = [NSMutableArray new];
    self.sectorsRadius = 70.0;
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = toRadians(270);
    self.minCircleMarkerRadius = 10.0;
    self.maxCircleMarkerRadius = 10.0;
    self.emptyCircleColor = [UIColor blackColor];
}

#pragma mark - Setters

- (void)setSectorsRadius:(double)sectorsRadius{
    _sectorsRadius = sectorsRadius;
    [self setNeedsDisplay];
}

#pragma mark - Sectors manipulations

- (void)addSector:(SAMultisectorSector *)sector{
    [sectorsArray addObject:sector];
    [self setNeedsDisplay];
}

- (void)removeSector:(SAMultisectorSector *)sector{
    [sectorsArray removeObject:sector];
    [self setNeedsDisplay];
}

- (void)removeAllSectors{
    [sectorsArray removeAllObjects];
    [self setNeedsDisplay];
}

- (NSArray *)sectors{
    return sectorsArray;
}

#pragma mark - Events manipulator

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    for(NSUInteger i = 0; i < sectorsArray.count; i++){
        SAMultisectorSector *sector = sectorsArray[i];
        NSUInteger position = i + 1;
        SASectorDrawingInformation drawInf =[self sectorToDrawInf:sector position:position];
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.endMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = NO;
            return YES;
        }
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.startMarkerCenter]&&!sector.isSingle){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = YES;
            return YES;
        }
        
    }
    return NO;
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint ceter = [self multiselectCenter];
    SAPolarCoordinate polar = decartToPolar(ceter, touchPoint);
    
    double correctedAngle;
    if(polar.angle < self.startAngle) correctedAngle = polar.angle + (2 * M_PI - self.startAngle);
    else correctedAngle = polar.angle - self.startAngle;
    
    double procent = correctedAngle / (M_PI * 2);
    
    double newValue = procent * (trackingSector.maxValue - trackingSector.minValue) + trackingSector.minValue;
    
    int start=ABS((int)(newValue+.5)-(int)(trackingSector.startValue+.5));
    
    int end=ABS((int)(newValue+.5)-(int)(trackingSector.endValue+.5));

    if(trackingSectorStartMarker){
        if(newValue > trackingSector.startValue){
            double diff = newValue - trackingSector.startValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.startValue = trackingSector.minValue;
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue >= trackingSector.endValue){
            trackingSector.startValue = trackingSector.endValue;
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.startValue = newValue;
        if (start)
            [self valueChangedNotification];
    }
    else if(!trackingSectorStartMarker){
        if(newValue < trackingSector.endValue){
            double diff = trackingSector.endValue - newValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.endValue = trackingSector.maxValue;
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue <= trackingSector.startValue){
            trackingSector.endValue = trackingSector.startValue;
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.endValue = newValue;
        if (end)
            [self valueChangedNotification];
    }

    
    
    [self setNeedsDisplay];
    
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    trackingSector = nil;
    trackingSectorStartMarker = NO;
}

- (CGPoint) multiselectCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (BOOL) touchInCircleWithPoint:(CGPoint)touchPoint circleCenter:(CGPoint)circleCenter{
    SAPolarCoordinate polar = decartToPolar(circleCenter, touchPoint);
    if(polar.radius >= (self.sectorsRadius / 2)) return NO;
    else return YES;
}

- (void) valueChangedNotification{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect{
    for(int i = 0; i < sectorsArray.count; i++){
        SAMultisectorSector *sector = sectorsArray[i];
        [self drawSector:sector atPosition:i+1];
    }
}

- (void)drawSector:(SAMultisectorSector *)sector atPosition:(NSUInteger)position{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *startCircleColor = self.emptyCircleColor;//[sector.color colorWithAlphaComponent:0.3];
    UIColor *circleColor = sector.color;
    UIColor *endCircleColor = self.emptyCircleColor;
    
    SASectorDrawingInformation drawInf = [self sectorToDrawInf:sector position:position];
    
    CGFloat x = drawInf.circleCenter.x;
    CGFloat y = drawInf.circleCenter.y;
    CGFloat r = drawInf.radius;
    
    
    //start circle line
    CGContextSetLineWidth(context, saCircleUnselectedLineWidth+(position-1)*7);
    
    [startCircleColor setStroke];
    CGContextAddArc(context, x, y, r, self.startAngle, drawInf.circleOffsetAngle, 0);
    CGContextStrokePath(context);
    
    //end circle line
    [endCircleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleLineAngle, drawInf.circleEmptyAngle, 0);
    CGContextStrokePath(context);
    
    //circle line
    CGContextSetLineWidth(context, saCircleLineWidth+(position-1)*7);
    
    [circleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleOffsetAngle, drawInf.circleLineAngle, 0);
    CGContextStrokePath(context);
    
    /*clearing place for start marker
    if (!drawInf.isSingle) {
        CGContextSaveGState(context);
        CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
        CGContextClip(context);
        CGContextClearRect(context, self.bounds);
        CGContextRestoreGState(context);
    }
    
    //clearing place for end marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);*/
    
    
    //markers
    //CGContextSetLineWidth(context, saMarkersLineWidth);

    //drawing start marker
    if (!drawInf.isSingle) {
        [[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
        [[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setFill];
        CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius, 0.0, 6.28, 0);
        //CGContextStrokePath(context);
        CGContextFillPath(context);
    }
    
    //drawing end marker
    [[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha] setStroke];
    [[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha] setFill];
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius, 0.0, 6.28, 0);
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    
    /*//text on markers
    NSString *startMarkerStr = [NSString stringWithFormat:@"%.0f", sector.startValue];
    NSString *endMarkerStr = [NSString stringWithFormat:@"%.0f", sector.endValue];
    
    //drawing start marker's text
    if (!drawInf.isSingle) {
        [self drawString:startMarkerStr
                withFont:[UIFont boldSystemFontOfSize:drawInf.startMarkerFontSize]
                   color:[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha]
              withCenter:drawInf.startMarkerCenter];
    }
    //drawing end marker's text
    [self drawString:endMarkerStr
            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
               color:[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha]
          withCenter:drawInf.endMarkerCenter];*/
    
    //White Circle
    CGContextSetLineWidth(context, 1);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    [[UIColor whiteColor] setStroke];
    CGContextAddArc(context,x , y, r-12, 0.0, 6.28, 0);
    CGContextStrokePath(context);
}


- (SASectorDrawingInformation) sectorToDrawInf:(SAMultisectorSector *)sector position:(NSInteger)position{
    SASectorDrawingInformation drawInf;
    
    drawInf.circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    drawInf.radius = /*self.sectorsRadius +*/ 100 * position;
    
    drawInf.fullLine = sector.maxValue - sector.minValue;
    drawInf.circleOffset = sector.startValue - sector.minValue;
    drawInf.circleLine = sector.endValue - sector.startValue;
    drawInf.circleEmpty = sector.maxValue - sector.endValue;
    
    drawInf.circleOffsetAngle = (drawInf.circleOffset/drawInf.fullLine) * M_PI * 2 + self.startAngle;
    drawInf.circleLineAngle = (drawInf.circleLine/drawInf.fullLine) * M_PI * 2 + drawInf.circleOffsetAngle;
    drawInf.circleEmptyAngle = M_PI * 2 + self.startAngle;
    
    
    drawInf.startMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleOffsetAngle);
    drawInf.endMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleLineAngle);
    
    CGFloat minMarkerRadius = 10;//self.sectorsRadius / 4.0;
    //CGFloat maxMarkerRadius = self.sectorsRadius / 2.0;
    
    drawInf.startMarkerRadius = /*((drawInf.circleOffsetAngle/(self.startAngle + 2*M_PI)) * (maxMarkerRadius - minMarkerRadius)) + */minMarkerRadius;
    drawInf.endMarkerRadius = /*((drawInf.circleLineAngle/(self.startAngle + 2*M_PI)) * (maxMarkerRadius - minMarkerRadius)) +*/ minMarkerRadius;
    
    CGFloat minFontSize = 12.0;
    //CGFloat maxFontSize = 18.0;
    
    drawInf.startMarkerFontSize = /*((drawInf.circleOffset/drawInf.fullLine) * (maxFontSize - minFontSize)) + */minFontSize;
    drawInf.endMarkerFontize = /*((drawInf.circleLine/drawInf.fullLine) * (maxFontSize - minFontSize)) + */minFontSize;
    
    CGFloat markersCentresSegmentLength = segmentLength(drawInf.startMarkerCenter, drawInf.endMarkerCenter);
    CGFloat markersRadiusSumm = drawInf.startMarkerRadius + drawInf.endMarkerRadius;
    
    if(markersCentresSegmentLength < markersRadiusSumm){
        
        drawInf.startMarkerAlpha = markersCentresSegmentLength / markersRadiusSumm;
    }else{
        drawInf.startMarkerAlpha = 1.0;
    }
    drawInf.endMarkerAlpha = 1.0;
    drawInf.isSingle = sector.isSingle;
    return drawInf;
}

/*- (void) drawString:(NSString *)s withFont:(UIFont *)font color:(UIColor *)color withCenter:(CGPoint)center{
    CGSize size = [s sizeWithFont:font];
    CGFloat x = center.x - (size.width / 2);
    CGFloat y = center.y - (size.height / 2);
    CGRect textRect = CGRectMake(x, y, size.width, size.height);
    
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[UITextAttributeFont] = font;
    attr[UITextAttributeTextColor] = color;
    [s drawInRect:textRect withAttributes:attr];
}*/
- (void)setStartValueWithSector:(SAMultisectorSector *)sector value:(double)value{
    double dur=0.6f;
    double delta = (value-sector.startValue);
    for (int i=1; i<=200; i++) {
        [self performSelector:@selector(setSectorValue:) withObject:@{@"object":sector,@"isStart":@YES,@"value":[NSNumber numberWithDouble:sector.startValue+A_FUNC(i, 200, delta)]} afterDelay:dur/200*i];
    }
}
- (void)setEndValueWithSector:(SAMultisectorSector *)sector value:(double)value{
    double dur=0.6f;
    double delta = (value-sector.endValue);
    for (int i=1; i<=200; i++) {
        [self performSelector:@selector(setSectorValue:) withObject:@{@"object":sector,@"isStart":@NO,@"value":[NSNumber numberWithDouble:sector.endValue+A_FUNC(i, 200, delta)]} afterDelay:dur/200*i];
    }
}
- (void)setSectorValue:(NSDictionary *)info{
    SAMultisectorSector *sector = info[@"object"];
    BOOL isStart  =[info[@"isStart"] boolValue];
    double value = [info[@"value"] doubleValue];
    if (isStart)
        [sector setStartValue:value];
    else
        [sector setEndValue:value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}
@end

@implementation SAMultisectorSector

- (instancetype)init{
    if(self = [super init]){
        self.minValue = 0.0;
        self.maxValue = 100.0;
        self.startValue = 0.0;
        self.endValue = 50.0;
        self.isSingle = NO;
        self.tag = 0;
        self.color = [UIColor greenColor];
    }
    return self;
}

+ (instancetype) sector{
    return [[SAMultisectorSector alloc] init];
}

+ (instancetype) sectorWithColor:(UIColor *)color{
    SAMultisectorSector *sector = [self sector];
    sector.color = color;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color maxValue:(double)maxValue{
    SAMultisectorSector *sector = [self sectorWithColor:color];
    sector.maxValue = maxValue;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color minValue:(double)minValue maxValue:(double)maxValue{
    SAMultisectorSector *sector = [self sectorWithColor:color maxValue:maxValue];
    sector.minValue = minValue;
    return sector;
}

@end
