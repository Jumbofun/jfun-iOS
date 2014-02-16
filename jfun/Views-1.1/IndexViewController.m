//
//  IndexViewController.m
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define y1 8
#define y2 30
#import "IndexViewController.h"
@implementation TopTable
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    if ([result isKindOfClass:[SAMultisectorControl class]])
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    return result;
}
@end
@interface IndexViewController (){
    BOOL _isMore;
    BOOL _needFresh;
    IndexViewMoreCell *_moreCell;
    NSArray *_activities;
}

@end

@implementation IndexViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNibs];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.tableView.backgroundView.backgroundColor= CLEARCOLOR;
    if (iPhone5)
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, -[[IndexViewMoreCell new] getHeight], 0);
    _isMore=NO;
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isMore) {
        switch (indexPath.section) {
            case 0:
                return HEIGHT_INDEX_VIEW_MAIN_CELL;
                break;
            case 1:
                return [[IndexViewMoreCell new] getHeight];
                break;
            default:
                return 1;
                break;
        }
    }
    else{
        switch (indexPath.section) {
            case 0:
                return [[IndexViewMoreCell new] getHeight];
                break;
            case 1:
                return HEIGHT_ACTIVITY_CELL;
                break;
            default:
                return 1;
                break;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!_isMore) {
        return 1;
    }
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [_activities count]==0?1:[_activities count];
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    if (!_isMore) {
        if (indexPath.section==0) {
            IndexViewMainCell *indexViewMainCell = (IndexViewMainCell *)[tableView dequeueReusableCellWithIdentifier:ID_INDEX_VIEW_MAIN_CELL forIndexPath:indexPath];
            indexViewMainCell.fatherController = self;
            cell=indexViewMainCell;
            [cell becomeFirstResponder];
        }
        else if(indexPath.section==1){
            cell = (IndexViewMoreCell *)[tableView dequeueReusableCellWithIdentifier:ID_INDEX_VIEW_MORE_CELL forIndexPath:indexPath];
            _moreCell=cell;
        }
    }
    else{
        if(indexPath.section==0){
            cell = (IndexViewMoreCell *)[tableView dequeueReusableCellWithIdentifier:ID_INDEX_VIEW_MORE_CELL forIndexPath:indexPath];
            _moreCell=cell;
        }
        else{
            if ([_activities count]) {
                ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:ID_ACTIVITY_CELL];
                if (!activityCell) {
                    activityCell=[[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_ACTIVITY_CELL];
                }
                activityCell.activity=[_activities objectAtIndex:indexPath.row];
                cell=activityCell;
            }
            else{
                LoadingCell *loadingCell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:ID_LOADING_CELL];
                if (!loadingCell) {
                    loadingCell=[[LoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_LOADING_CELL];
                }
                cell=loadingCell;
            }
        }

    }
    return cell;
}
- (void)scrollViewDidScroll:(CGFloat)angle{
    CGFloat y;
if (IOS_VERSION>=7.0)
    y = self.tableView.contentOffset.y+64;
else
    y = self.tableView.contentOffset.y;

    if (!_isMore) {
        if (y<=y2&&y>y1)
            [_moreCell scrollViewDidScroll:0 isDown:YES];
        else if (y>y2)
            [_moreCell scrollViewDidScroll:180 isDown:YES];
        else
            [_moreCell endScroll];
    }
    else if (_isMore){
        if (y>=-y1&&y<0)
            [_moreCell scrollViewDidScroll:180 isDown:NO];
        else if (y<-y1)
            [_moreCell scrollViewDidScroll:0 isDown:NO];
        else
            [_moreCell endScroll];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
        //[_moreCell endScroll];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_isMore) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 50, 0);
    }
    else{
        if (iPhone5)
            self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, -[[IndexViewMoreCell new] getHeight], 0);
    }

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat y;
if (IOS_VERSION>=7.0)
        y = self.tableView.contentOffset.y+64;
else
        y = self.tableView.contentOffset.y;
    
    if (!_isMore) {
        if (y>y2){
            _isMore=YES;
            [self freshActivities];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationTop];
        }
            *targetContentOffset = IOS_VERSION>=7.0?CGPointMake(0, -64):CGPointMake(0, 0);
    }
    else if (y<-y1&&_isMore){
        _isMore=NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
- (void)scrollToTop{
if (IOS_VERSION>=7.0)
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
else
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    if (_isMore&&indexPath.section==1)
        [self performSegueWithIdentifier:@"goToActivityDetail" sender:self];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id destinationViewController = [segue destinationViewController];
    if ([destinationViewController isKindOfClass:[ActivityDetailViewController class]]) {
        [destinationViewController setValue:_activities[self.tableView.indexPathForSelectedRow.row] forKey:@"Activity"];
    }
    else {
        UIViewController *des = segue.destinationViewController;
        [des setValue:self.jFun forKey:@"jFun"];
    }
}
- (void)loadNibs{
    //load nib
    UINib *cellNib;
    if (iPhone5)
        cellNib=[UINib nibWithNibName:@"IndexViewMainCell" bundle:[NSBundle mainBundle]];
    else
        cellNib=[UINib nibWithNibName:@"IndexViewMainCell23" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ID_INDEX_VIEW_MAIN_CELL];
    cellNib=[UINib nibWithNibName:@"IndexViewMoreCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ID_INDEX_VIEW_MORE_CELL];

}

#pragma mark -- jfun
- (void)startFresh{
    self.jFun = [[MIQUJFun alloc] initWithUserInfo:self.userInput];
    self.jFun.delegate = self;
    
    [self.jFun startFreshFromServer];
}
- (void)JfunDidFreshing:(BOOL)isError{
    if (!isError) {
        [ProgressHUD dismiss];
        [self performSegueWithIdentifier:@"gotoDetail" sender:self];
    }
    else{
        [ProgressHUD showError:MyLocal(@"no-network")];
        NSLog(@"Error when freshing");
    }
}
- (void)recievedActivities:(NSArray *)activities error:(NSError *)er{
    if (er) {
        [ProgressHUD showError:MyLocal(@"no-network")];
        NSLog(@"Error when freshing");
    }
    else{
        _activities=activities;
        if (_isMore)
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]  withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)commitWithShaking:(BOOL)isShake{
    [self startFresh];
    [ProgressHUD show:@"路线生成中..." Interacton:NO];
}
- (void)freshActivities{
    JFActivity *jfactivity = [JFActivity sharedInstance];
    [jfactivity startFreshFromServerWithReturnNumber:10];
    jfactivity.delegate=self;
}
@end
