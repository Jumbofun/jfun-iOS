//
//  TriangleCell.h
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriangleCell : UIView

@property (strong,nonatomic) UIImage *picture;
@property (strong,nonatomic) NSString *pictureURLString;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIImage *rightPicture;
@property (strong, nonatomic) UIImage *leftPicture;

@property (nonatomic) CGFloat mainPictureWidth;

@end
