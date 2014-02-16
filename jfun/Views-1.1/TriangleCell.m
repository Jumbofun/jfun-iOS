//
//  TriangleCell.m
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "TriangleCell.h"
@interface TriangleCell(){
    UIImage *_picture;
    UIImage *_leftPicture;
    UIImage *_rightPicture;
    
    UIImageView *_mainImageView;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIView *_rightView;
    
    NSString *_pictureURLString;
}

@end
@implementation TriangleCell
@synthesize picture=_picture,leftPicture=_leftPicture,rightView=_rightView,rightPicture=_rightPicture,pictureURLString=_pictureURLString;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareLeftImageView];
        [self prepareMainImageView];
        [self prepareRightImageView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self prepareLeftImageView];
        [self prepareMainImageView];
        [self prepareRightImageView];
    }
    return self;
}
- (void)setMainPictureWidth:(CGFloat)mainPictureWidth{
    _mainPictureWidth=mainPictureWidth;
    CGRect rect = CGRectMake(0, 0, self.mainPictureWidth, self.mainPictureWidth*3.0/4.0);
    _mainImageView.frame = rect;
}
- (void)setPicture:(UIImage *)picture{
    _picture = picture;
    if (picture){
        CGRect rect = CGRectMake(0, 0, self.frame.size.width-self.mainPictureWidth, self.frame.size.height);
        _mainImageView.frame = rect;
    }
    _mainImageView.image = _picture;
}
- (void)setPictureURLString:(NSString *)pictureURLString{
    _pictureURLString=pictureURLString;
    if (pictureURLString) {
        CGRect rect = CGRectMake(0, 0, self.mainPictureWidth, self.mainPictureWidth*3.0/4.0);
        _mainImageView.frame = rect;
        [_mainImageView setImageWithURL:[NSURL URLWithString:pictureURLString] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    }
}
- (void)setLeftPicture:(UIImage *)leftPicture{
    _leftPicture = leftPicture;
    if (leftPicture) {
        CGRect rect = CGRectMake(0, 0, self.mainPictureWidth, self.mainPictureWidth*3.0/4.0);
        _leftImageView.frame = rect;
    }
    _leftImageView.image = leftPicture;
}
- (void)setRightPicture:(UIImage *)rightPicture{
    _rightPicture = rightPicture;
    if (_rightPicture) {
        CGRect rect = CGRectMake(self.frame.size.width-self.rightPicture.size.width, 0, self.rightPicture.size.width, self.rightPicture.size.height);
        _rightView.frame = rect;
        _rightImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
    _rightImageView.image = rightPicture;
}


- (void)prepareLeftImageView{
    CGRect rect = CGRectZero;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    _leftImageView=imageView;
    [self addSubview:imageView];
}
- (void)prepareMainImageView{
    CGRect rect = CGRectZero;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    _mainImageView=imageView;
    _mainImageView.image = self.picture;
    [self addSubview:imageView];
}
- (void)prepareRightImageView{
    CGRect rect = CGRectZero;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    _rightView=view;
    _rightImageView=imageView;
    [self addSubview:view];
    [view addSubview:imageView];
}
@end
