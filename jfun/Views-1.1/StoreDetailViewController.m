//
//  StoreDetailViewController.m
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define PIC_NAME_CELL_HEIGHT 250
#define PRICE_STAR_CELL_HEIGHT 44
#define PHONE_CELL_HEIGHT 44
#define ADDRESS_CELL_HEIGHT 44

#import "StoreDetailViewController.h"

@interface StoreDetailViewController (){
    NSArray *_stores;
    NSMutableArray *_starImageViews;
}

@end

@implementation StoreDetailViewController

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
    self.tableView.backgroundColor=MAIN_BACKGROUND_COLOR;
    self.tableView.backgroundView=nil;
    self.tableView.separatorColor=[UIColor whiteColor];
    _stores = [self.storeRow getArr];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --tableview dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"pic&nameCell"];
            [self configurePic:cell];
            [self configureName:cell];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"price&starCell"];
            [self configurePrice:cell];
            [self configureStar:cell];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
            [self configurePhone:cell];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            [self configureAddress:cell];
            break;
        case 4:
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return PIC_NAME_CELL_HEIGHT;
            break;
        case 1:
            return PRICE_STAR_CELL_HEIGHT;
            break;
        case 2:
            return PHONE_CELL_HEIGHT;
            break;
        case 3:
            return ADDRESS_CELL_HEIGHT;
            break;
        case 4:
            return [self getDescriptionHeight] + 25;
            break;
        default:
            return 0;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2 && indexPath.section == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.storeRow.lastStore.phone]]];
    }
}
- (void)configurePic:(UITableViewCell *)cell{
    UIScrollView *mainPicScorllView = (UIScrollView *)[cell viewWithTag:1];
    mainPicScorllView.contentSize = CGSizeMake(mainPicScorllView.frame.size.width*[_stores count], mainPicScorllView.frame.size.height);
    mainPicScorllView.delegate = self;
    int i = 0;
    for (JFOneStore *store in _stores) {
        CGSize size = mainPicScorllView.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*i, 0, size.width, size.height)];
        
        [imgView setImageWithURL:[NSURL URLWithString:store.photos[0]] placeholderImage:[UIImage imageNamed:@"icon.png"]];
        [mainPicScorllView addSubview:imgView];
        i++;
    }
    NSInteger N = [_stores indexOfObject:self.storeRow.lastStore];
    [mainPicScorllView setContentOffset:CGPointMake(N*mainPicScorllView.frame.size.width, 0)];
    
}
- (void)configureName:(UITableViewCell *)cell{
    UILabel *storeNameLbl;
    JFOneStore *store = self.storeRow.lastStore;
    storeNameLbl = (UILabel *)[cell viewWithTag:4];
    storeNameLbl.text = store.name;
}
- (void)configureStar:(UITableViewCell *)cell{
    JFOneStore *store = self.storeRow.lastStore;
    //initialation
    if (!_starImageViews) {
        UIImageView *starImageView = (UIImageView *)[cell viewWithTag:13];
        _starImageViews = [NSMutableArray arrayWithObject:starImageView];
        CGRect frame = starImageView.frame;
        for (int i = 1; i <= 4; i++) {
            CGRect frame1 = CGRectMake(frame.origin.x + 12 * i, frame.origin.y, frame.size.width, frame.size.height);
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:frame1];
            [cell addSubview:starImageView];
            [cell bringSubviewToFront:starImageView];
            [_starImageViews addObject:starImageView];
        }
    }
    
    UIImage *starFullImage = [UIImage imageNamed:@"starFull"];
    UIImage *starEmptyImage = [UIImage imageNamed:@"starEmpty"];
    int i;
    for (i = 0; i < [store.rating integerValue]; i++) {
        UIImageView *starImageView = _starImageViews[i];
        starImageView.image = starFullImage;
    }
    for (; i<5; i++) {
        UIImageView *starImageView = _starImageViews[i];
        starImageView.image = starEmptyImage;
    }
    
}
- (void)configurePrice:(UITableViewCell *)cell{
    JFOneStore *store = self.storeRow.lastStore;
    UILabel *averageLbl = (UILabel *)[cell viewWithTag:5];
    NSString *priceStr;
    if ([store.price integerValue]>0) {
        priceStr = [NSString stringWithFormat:@"￥ %@",store.price];
    }
    else if([store.price integerValue]==0){
        priceStr = @"免费";
    }
    else{
        priceStr = @"以实际为准";
    }
    averageLbl.text = priceStr;
}
- (void)configurePhone:(UITableViewCell *)cell{
    JFOneStore *store = self.storeRow.lastStore;
    UILabel *phoneLbl = (UILabel *)[cell viewWithTag:14];
    phoneLbl.text = store.phone;
}
- (void)configureAddress:(UITableViewCell *)cell{
    JFOneStore *store = self.storeRow.lastStore;
    UILabel *addressLbl = (UILabel *)[cell viewWithTag:15];
    addressLbl.text = store.address;
}
- (void)configureDesciption:(UITableViewCell *)cell{
    JFOneStore *store = self.storeRow.lastStore;
    UILabel *descriptionLbl = (UILabel *)[cell viewWithTag:16];
    CGRect frame = descriptionLbl.frame;
    descriptionLbl.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, [self getDescriptionHeight]);
    descriptionLbl.text = store.description;
}
- (CGFloat)getDescriptionHeight{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize size = [self.storeRow.lastStore.description sizeWithFont:font constrainedToSize:CGSizeMake(280, MAXFLOAT)];
    return size.height;
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
