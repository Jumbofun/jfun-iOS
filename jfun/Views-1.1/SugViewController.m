//
//  SugViewController.m
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "SugViewController.h"

@interface SugViewController (){
    NSUInteger _selectedButton;
    NSArray *_dataSource;
    JFRoute *_JFRoute;
    JFActivity *_JFActivity;
    BOOL _routeFreshed;
}

@end

@implementation SugViewController

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
    [self firstLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstLoad{
    UIButton *button = [self.selectionButtons lastObject];
    _selectedButton = [self.selectionButtons indexOfObject:button];
    [button setSelected:YES];
    
    _JFRoute = [JFRoute sharedInstance];
    _JFRoute.delegate=self;
    _JFActivity = [JFActivity sharedInstance];
    _JFActivity.delegate=self;
    
    [_JFActivity getActivitiesWithNumber:10];
    [self performSelector:@selector(firstFresh) withObject:nil afterDelay:0.1];
    _routeFreshed=NO;
    //freshControl
    // Set up the UIRefreshControl.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(RefreshViewControlEventValueChanged)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    self.refreshControl.tintColor=[[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    // Create a UITableViewController so we can use a UIRefreshControl.
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:self.tableView.style];
    tvc.tableView = self.tableView;
    tvc.refreshControl = self.refreshControl;
    [self addChildViewController:tvc];
}
- (void)firstFresh{
    [self.tableView setContentOffset:CGPointMake(0, -100) animated:YES];
    [self.refreshControl beginRefreshing];
    [self RefreshViewControlEventValueChanged];
}
- (void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"刷新中"];
    [self fresh];
}
- (IBAction)selectButttonPressed:(id)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectButttonPressed:) object:sender];
    
    for (UIButton *button in self.selectionButtons) {
        if ([sender isEqual:button]) {
            button.selected = YES;
            _selectedButton=[self.selectionButtons indexOfObject:button];
        }
        else{
            button.selected = NO;
        }
    }
    
    if (_selectedButton==0) {
        [_JFRoute getRoutesWithNumber:10];
    }
    else{
        [_JFActivity getActivitiesWithNumber:10];
    }

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedButton==0){
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
    if (_selectedButton==0) {
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedButton==0) {
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
     if (_selectedButton==0) {
         [destinationViewController setValue:_dataSource[self.tableView.indexPathForSelectedRow.row] forKey:@"Route"];
     }
     else{
         [destinationViewController setValue:_dataSource[self.tableView.indexPathForSelectedRow.row] forKey:@"Activity"];
     }
 }


#pragma mark JFRouteDelegate
- (void)recievedRoutes:(NSArray *)routes error:(NSError *)er{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    if (!er) {
        [ProgressHUD dismiss];
        if (_selectedButton==1) return;
        _dataSource=routes;
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        if (!_routeFreshed){
            _routeFreshed=YES;
            [self firstFresh];
        }
    }
    else{
        [ProgressHUD showError:MyLocal(@"no-network")];
    }
}
#pragma mark JFActivitryDelegate
- (void)recievedActivities:(NSArray *)activities error:(NSError *)er{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    if (!er) {
        [ProgressHUD dismiss];
        if (_selectedButton==0) return;
        _dataSource=activities;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        [ProgressHUD showError:MyLocal(@"no-network")];
    }
}
- (void)fresh{
    if (_selectedButton==0) {
        [_JFRoute startFreshFromServerWithReturnNumber:10];
    }
    else{
        [_JFActivity startFreshFromServerWithReturnNumber:10];
    }
}
- (void)scrollToTop{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
