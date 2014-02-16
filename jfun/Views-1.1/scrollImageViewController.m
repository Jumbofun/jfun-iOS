//
//  scrollImageViewController.m
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "scrollImageViewController.h"

@interface scrollImageViewController ()

@end

@implementation scrollImageViewController

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
    self.navigationController.title = self.title;
    //background
    if (self.backgroundColor) {
        self.view.backgroundColor = self.backgroundColor;
    }
    if (self.backgroundImage){
        UIImageView *backgroundImageView;
        backgroundImageView = [[UIImageView alloc]initWithImage:self.backgroundImage];
        [self.view addSubview:backgroundImageView];
    }
    //content
    if (!self.contentImage) return;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.contentImage];
    
    [self.scrolView addSubview:imageView];
    self.scrolView.contentSize = (self.contentImage.size.height<self.view.bounds.size.height)?CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+1):self.contentImage.size;
    
    [self.view bringSubviewToFront:self.scrolView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
