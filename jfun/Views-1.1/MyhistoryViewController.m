//
//  MyhistoryViewController.m
//  jfun
//
//  Created by mmm on 14-2-2.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "MyhistoryViewController.h"
#define COLOR_SEG_VIEW_INDICATOR UIColorFromRGB(0xf18e38)

@interface MyhistoryViewController (){
    HMSegmentedControl *_segView;
    UIScrollView *_scrollView;
    ActivityColumnView *_currentView;
    UITableView *_historyTableView;
    NSArray *_historyRoutes;
}

@end

@implementation MyhistoryViewController

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
    self.view.backgroundColor=MAIN_BACKGROUND_COLOR;
    [self prepareSeg];
    [self prepareViews];
    _historyRoutes = [[MIQUJFun new] historyRoutes];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareSeg{
    _segView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, IOS_VERSION>=7.0?64:0, SCREEN_WIDTH, 50)];
    [_segView setSectionTitles:@[@"当前方案",@"历史方案"]];
    [_segView setBackgroundColor:MAIN_BACKGROUND_COLOR];
    [_segView setTextColor:[UIColor whiteColor]];
    [_segView setSelectionIndicatorColor:COLOR_SEG_VIEW_INDICATOR];
    [_segView setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    
    [self.view addSubview:_segView];
    [_segView addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
}
- (void)prepareViews{
    //scroll view
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segView.frame.origin.y+_segView.frame.size.height+20, self.view.bounds.size.width, self.view.bounds.size.height-_segView.frame.size.height-140)];
    _scrollView.backgroundColor=CLEARCOLOR;
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*2, _scrollView.frame.size.height);
    _scrollView.scrollEnabled=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollView];
    
    //activity col
    JFOneRoute *route = [[MIQUJFun new] currentRoute];
    _currentView = [[ActivityColumnView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    _currentView.route=route;
    [_scrollView addSubview:_currentView];
    
    //history
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    _historyTableView.delegate=self;
    _historyTableView.dataSource=self;
    _historyTableView.backgroundColor=CLEARCOLOR;
    _historyTableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [_scrollView addSubview:_historyTableView];
}
- (void)segmentedControlChangedValue{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*_segView.selectedIndex, 0) animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_ROUTE_CELL;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_historyRoutes count];
}

- (RouteCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteCell *cell=[tableView dequeueReusableCellWithIdentifier:ID_ROUTE_CELL];
    if (!cell) {
        cell=[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_ROUTE_CELL];
    }
    cell.route=_historyRoutes[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segView.selectedIndex==1) {
        [self performSegueWithIdentifier:@"goToColumn" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destinationViewController = [segue destinationViewController];
    [destinationViewController setValue:_historyRoutes[_historyTableView.indexPathForSelectedRow.row] forKey:@"Route"];
}
@end
