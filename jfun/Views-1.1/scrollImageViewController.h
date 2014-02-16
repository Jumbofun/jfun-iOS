//
//  scrollImageViewController.h
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scrollImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (strong,nonatomic) UIImage *contentImage;
@property (strong,nonatomic) UIImage *backgroundImage;
@property (strong,nonatomic) UIColor *backgroundColor;
@property (strong,nonatomic) NSString *titleString;
- (IBAction)backButtonPressed:(id)sender;

@end
