//
//  IndexViewMoreCell.m
//  jfun
//
//  Created by mmm on 14-1-25.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "IndexViewMoreCell.h"
@interface IndexViewMoreCell(){
    CGFloat _angle;
    BOOL _isAnimate;
}
@end
@implementation IndexViewMoreCell
@synthesize textLabel,arrowImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (void)layoutSubviews{
    arrowImage.alpha=0;
    textLabel.alpha=0;
    _angle=-1;
    _isAnimate=NO;
}
- (CGFloat)getHeight{
    return 40;
}
- (void)scrollViewDidScroll:(CGFloat)angle isDown:(BOOL)isDown{
    if (arrowImage.alpha<0.1){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        arrowImage.alpha=1;
        textLabel.alpha=1;
        [UIView commitAnimations];
    }
    
    if (ABS(angle-_angle)>1 && !_isAnimate) {
        [UIView animateWithDuration:0.2f
                         animations:^(){
                             if (isDown) {
                                 if (angle<90)
                                     textLabel.text=@"继续上拉加载更多";
                                 else
                                     textLabel.text=@"释放加载更多";
                             }
                             else{
                                 if (angle<90)
                                     textLabel.text=@"释放返回";
                                 else
                                     textLabel.text=@"继续下拉返回";
                             }
                             
                             _isAnimate=YES;
                             CGAffineTransform trans = CGAffineTransformMakeRotation(angle/180.0*3.1415926);
                             arrowImage.transform = trans;
                         }
                         completion:^(BOOL finished){
                             _isAnimate=NO;
                         }];
    }
    _angle=angle;
}
- (void)endScroll{
    if (arrowImage.alpha<0.1) return;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    arrowImage.alpha=0;
    textLabel.alpha=0;
    [UIView commitAnimations];
}
@end
