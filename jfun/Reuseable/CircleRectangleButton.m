//
//  CircleRectangleButton.m
//  jfun
//
//  Created by mmm on 14-1-30.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "CircleRectangleButton.h"

@implementation CircleRectangleButton

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
        [self configAppearance];
    }
    return self;
}
- (void)configAppearance{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setBackgroundColor:[UIColor colorWithRed:231/255.0 green:135/255.0 blue:33/255.0 alpha:0]];
    
    self.clipsToBounds = NO;
	self.layer.cornerRadius = 3;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1.0f;
    
    self.adjustsImageWhenHighlighted=YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
