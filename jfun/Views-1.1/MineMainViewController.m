//
//  MineMainViewController.m
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "MineMainViewController.h"

@interface MineMainViewController (){
    UIImageView     *_imageView;
    UIScrollView   *_imageScroller;
    __weak UITableView     *_tableView;
    UIImage *_topImage;
}

@end
static CGFloat WindowHeight = 200.0;

@implementation MineMainViewController
@synthesize imageScroller=_imageScroller,tableView=_tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self prepareAppearance];
    [self layoutImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareAppearance{
    // Custom initialization
    _imageScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _imageScroller.backgroundColor                  = [UIColor clearColor];
    _imageScroller.showsHorizontalScrollIndicator   = NO;
    _imageScroller.showsVerticalScrollIndicator     = NO;
    [_imageScroller setUserInteractionEnabled:NO];
    _imageScroller.frame = CGRectMake(0, 0, self.view.bounds.size.width, WindowHeight);
    
    _topImage = [UIImage imageNamed:@"mine-top-background"];
    _imageView = [[UIImageView alloc] initWithImage:_topImage];
    [_imageScroller addSubview:_imageView];
    
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.dataSource                   = self;
    _tableView.delegate                     = self;
    _tableView.separatorStyle               = UITableViewCellSeparatorStyleSingleLine;
    _tableView.contentInset                 = UIEdgeInsetsMake(IOS_VERSION>=7.0?WindowHeight-10:WindowHeight, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_imageScroller];
    //[self.view addSubview:_tableView];
}

#pragma mark - Parallax effect

- (void)updateOffsets {
    CGFloat yOffset   = _tableView.contentOffset.y+_tableView.contentInset.top;
    CGFloat threshold = _topImage.size.height - WindowHeight;
    CGFloat y = IOS_VERSION>=7.0?64:0;
    if (yOffset > -threshold && yOffset < 0) {
        _imageScroller.frame = CGRectMake(0, y, self.view.bounds.size.width, WindowHeight-yOffset);
        _imageScroller.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));

    } else if (yOffset < 0) {
        _imageScroller.frame = CGRectMake(0, y, self.view.bounds.size.width, WindowHeight-yOffset + floorf(threshold / 2.0));
        _imageScroller.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
    } else {
        _imageScroller.contentOffset = CGPointMake(0.0, 0);
        _imageScroller.frame = CGRectMake(0, y, self.view.bounds.size.width, WindowHeight-yOffset);
    }
}

#pragma mark - View Layout
- (void)layoutImage {
    CGFloat imageWidth   = _imageScroller.frame.size.width;
    CGFloat imageYOffset = floorf((WindowHeight  - _topImage.size.height) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    _imageView.frame             = CGRectMake(imageXOffset, imageYOffset, imageWidth, _topImage.size.height);
    
    _imageScroller.contentSize   = CGSizeMake(imageWidth, self.view.bounds.size.height);
    _imageScroller.contentOffset = CGPointMake(0.0, 0);
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    }
    else if(indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"favorateCell"];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}


@end
