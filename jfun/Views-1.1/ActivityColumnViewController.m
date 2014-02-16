//
//  ActivityColumnViewController.m
//  jfun
//
//  Created by mmm on 14-1-31.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "ActivityColumnViewController.h"

@interface ActivityColumnViewController ()

@end

@implementation ActivityColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.activityColumnView.route=self.route;
    [self freshButton];

}
- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonPressed:(id)sender {
}

- (IBAction)locatonButtonPressed:(id)sender {
}

- (void)freshButton{
    if (self.route.isGenerated) {
        self.favorateButton.hidden=YES;
    }
    [self.favorateButton setSelected:[[JFRoute sharedInstance] isFavorateWithRoute:self.route]];
}
- (IBAction)favorateButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.isSelected];
    if (button.isSelected){
        [[JFRoute sharedInstance] favorateWithRoute:self.route];
        [ProgressHUD showSuccess:MyLocal(@"favorate")];
    }
    else{
        [[JFRoute sharedInstance] deFavorateWithRoute:self.route];
        [ProgressHUD showSuccess:MyLocal(@"defavorate")];
    }
}


@end
