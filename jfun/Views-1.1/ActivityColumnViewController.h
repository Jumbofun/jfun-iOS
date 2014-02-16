//
//  ActivityColumnViewController.h
//  jfun
//
//  Created by mmm on 14-1-31.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityColumnView.h"

@interface ActivityColumnViewController : UIViewController

@property (strong,nonatomic) JFOneRoute *route;
@property (weak, nonatomic) IBOutlet UIButton *favorateButton;
@property (weak, nonatomic) IBOutlet ActivityColumnView *activityColumnView;


- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)locatonButtonPressed:(id)sender;
- (IBAction)favorateButtonPressed:(id)sender;
@end
