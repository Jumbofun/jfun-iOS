//
//  MyFavorateViewController.m
//  jfun
//
//  Created by mmm on 14-2-4.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "MyFavorateViewController.h"
#define COLOR_SEG_VIEW_INDICATOR UIColorFromRGB(0xf18e38)

@interface MyFavorateViewController (){
    HMSegmentedControl *_segView;
    UITableView *_tableView;
    NSArray *_dataSource;
}
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation MyFavorateViewController
@synthesize tableView=_tableView;
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
    self.view.backgroundColor=MAIN_BACKGROUND_COLOR;
    [self prepareSeg];
    [self prepareTableView];
}
- (void)viewDidAppear:(BOOL)animated{
    [self freshDatasoure];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segView.selectedIndex==0){
        return HEIGHT_ROUTE_CELL;
    }
    else{
        return HEIGHT_ACTIVITY_CELL;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    if (_segView.selectedIndex==0) {
        RouteCell *routeCell = (RouteCell *)[tableView dequeueReusableCellWithIdentifier:ID_ROUTE_CELL];
        if (!routeCell) {
            routeCell=[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_ROUTE_CELL];
        }
        routeCell.route=_dataSource[indexPath.row];
        cell = routeCell;
    }
    else{
        ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:ID_ACTIVITY_CELL];
        
        if (!activityCell) {
            activityCell=[[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_ACTIVITY_CELL];
        }
        activityCell.activity=_dataSource[indexPath.row];
        cell = activityCell;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segView.selectedIndex==0) {
        [self performSegueWithIdentifier:@"goToRouteDetail" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"goToActivityDetail" sender:self];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationViewController = [segue destinationViewController];
    if (_segView.selectedIndex==0) {
        [destinationViewController setValue:_dataSource[self.tableView.indexPathForSelectedRow.row] forKey:@"Route"];
    }
    else{
        [destinationViewController setValue:_dataSource[self.tableView.indexPathForSelectedRow.row] forKey:@"Activity"];
    }
}


- (void)prepareSeg{
    _segView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, IOS_VERSION>=7.0?64:0, SCREEN_WIDTH, 50)];
    [_segView setSectionTitles:@[@"路线",@"活动"]];
    [_segView setBackgroundColor:MAIN_BACKGROUND_COLOR];
    [_segView setTextColor:[UIColor whiteColor]];
    [_segView setSelectionIndicatorColor:COLOR_SEG_VIEW_INDICATOR];
    [_segView setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    
    [self.view addSubview:_segView];
    [_segView addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
}
- (void)prepareTableView{
    CGSize bound = self.view.frame.size;
    CGRect segViewFrame = _segView.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segViewFrame.origin.y+segViewFrame.size.height, SCREEN_WIDTH, bound.height-(segViewFrame.origin.y+segViewFrame.size.height))];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=CLEARCOLOR;
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];
    
}
- (void)freshDatasoure{
    if (_segView.selectedIndex==0) {
        _dataSource=[[JFRoute sharedInstance] getFavorateRoutes];
    }
    else{
        _dataSource=[[JFActivity sharedInstance] getFavorateActivities];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)segmentedControlChangedValue{
    [self freshDatasoure];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}@end
