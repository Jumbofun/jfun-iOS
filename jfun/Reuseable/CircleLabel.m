//
//  CircleLabel.m
//  jfun
//
//  Created by mmm on 14-2-13.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "CircleLabel.h"

@implementation CircleLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.textAlignment=NSTextAlignmentCenter;
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.labelColor setFill];
    //circle
    CGContextFillEllipseInRect(context, rect);
    [super drawRect:rect];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.labelColor=backgroundColor;
    [super setBackgroundColor:[UIColor clearColor]];
}

@end
