//
//  ActivityDetailViewController.m
//  jfun
//
//  Created by mmm on 14-2-9.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define PIC_NAME_CELL_HEIGHT 250
#define PRICE_STAR_CELL_HEIGHT 44
#define PHONE_CELL_HEIGHT 44
#define ADDRESS_CELL_HEIGHT 44
#define NORMAL_CELL_HEIGHT 44

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController (){
    
}

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor=MAIN_BACKGROUND_COLOR;
    self.tableView.backgroundView=nil;
    self.tableView.separatorColor=[UIColor whiteColor];
    [self freshButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return PIC_NAME_CELL_HEIGHT;
            break;
        case 5:
            return [self getDescriptionHeight] + 25;
            break;
        default:
            return NORMAL_CELL_HEIGHT;
            break;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"pic&nameCell"];
            [self configurePic:cell];
            [self configureName:cell];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell"];
            [self configureDate:cell];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
            [self configureTime:cell];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            [self configurePrice:cell];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            [self configureAddress:cell];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
            [self configureDesciption:cell];
            break;
        default:
            break;
    }
    cell.backgroundColor=CLEARCOLOR;
    cell.backgroundView=nil;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)freshButton{
    [self.favorateButton setSelected:[[JFActivity sharedInstance] isFavorateWithActivity:self.activity]];
}
- (void)configurePic:(UITableViewCell *)cell{
    UIScrollView *mainPicScorllView = (UIScrollView *)[cell viewWithTag:1];
    mainPicScorllView.contentSize = CGSizeMake(mainPicScorllView.frame.size.width*[_activity.plink count], mainPicScorllView.frame.size.height);
    mainPicScorllView.delegate = self;
    int i = 0;
    for (NSString *url in _activity.plink) {
        CGSize size = mainPicScorllView.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*i, 0, size.width, size.height)];
        
        [imgView setImageWithURL:[NSURL URLWithString:_activity.plink[i]] placeholderImage:[UIImage imageNamed:@"icon.png"]];
        [mainPicScorllView addSubview:imgView];
        i++;
    }

    [mainPicScorllView setContentOffset:CGPointMake(0, 0)];
    
}
- (void)configureName:(UITableViewCell *)cell{
    UILabel *storeNameLbl;
    storeNameLbl = (UILabel *)[cell viewWithTag:10];
    storeNameLbl.text = _activity.name;
}

- (void)configurePrice:(UITableViewCell *)cell{
    UILabel *averageLbl = (UILabel *)[cell viewWithTag:10];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@ ~ ￥%@",_activity.lowestprice,_activity.hightestprice];
    averageLbl.text = priceStr;
}
- (void)configureDate:(UITableViewCell *)cell{
    UILabel *phoneLbl = (UILabel *)[cell viewWithTag:10];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"MM月d日";
    NSString *dateString = [NSString stringWithFormat:@"%@ ~ %@",[dateFormatter stringFromDate:_activity.startdatetime],[dateFormatter stringFromDate:_activity.enddatetime]];
    phoneLbl.text = dateString;
}
- (void)configureTime:(UITableViewCell *)cell{
    UILabel *phoneLbl = (UILabel *)[cell viewWithTag:10];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat=@"HH:m";
    NSString *timeString = [NSString stringWithFormat:@"%@-%@",[timeFormatter stringFromDate:_activity.startdatetime],[timeFormatter stringFromDate:_activity.enddatetime]];
    
    phoneLbl.text = timeString;
}
- (void)configureAddress:(UITableViewCell *)cell{
    UILabel *addressLbl = (UILabel *)[cell viewWithTag:10];
    addressLbl.text = _activity.address;
}
- (void)configureDesciption:(UITableViewCell *)cell{
    UILabel *descriptionLbl = (UILabel *)[cell viewWithTag:10];
    CGRect frame = descriptionLbl.frame;
    descriptionLbl.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, [self getDescriptionHeight]);
    descriptionLbl.text = _activity.description;
}
- (CGFloat)getDescriptionHeight{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize size = [_activity.description sizeWithFont:font constrainedToSize:CGSizeMake(280, MAXFLOAT)];
    return size.height;
}
- (IBAction)favorateButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.isSelected];
    if (button.isSelected){
        [[JFActivity sharedInstance] favorateWithActivity:self.activity];
        [ProgressHUD showSuccess:MyLocal(@"favorate")];
    }
    else{
        [[JFActivity sharedInstance] deFavorateWithActivity:self.activity];
        [ProgressHUD showSuccess:MyLocal(@"defavorate")];
    }

}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
