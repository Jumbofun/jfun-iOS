//
//  ActivityListViewController.m
//  jfun
//
//  Created by mmm on 14-1-29.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "ActivityListViewController.h"

@interface ActivityListViewController (){
        NSMutableArray *_rows;
}

@end

@implementation ActivityListViewController

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
    [self loadNibs];
    [self prepareData];
    
}
- (void)prepareData{
    _rows = [NSMutableArray arrayWithArray:[self.jFun getInfoListRows]];
    
    self.selectedStores = [NSMutableArray array];
    for (MIQUInfoListRow *row in _rows) {
        [self.selectedStores addObject:row.stores[0]];
    }
    [self showPrice];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)commitButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"goToColumn" sender:self];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeButtonPressed:(id)sender {
    [ProgressHUD show:@"路线生成中..." Interacton:NO];
    [_jFun clearData];
    _jFun.delegate=self;
    [_jFun startFreshFromServer];
}
- (void)showPrice{
    [self.infoListTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSUInteger)calPrice{
    NSUInteger price = 0;
    for (MIQUStore *store in self.selectedStores) {
        if (store)
            price += [store.price integerValue];
    }
    return price;
}
#pragma mark --tableview dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [_rows count];
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        MIQUInfoListRow *storeRow = _rows[indexPath.row];
        StoreRowCell *rowCell = [tableView dequeueReusableCellWithIdentifier:ID_STORE_ROW_CELL];
        [rowCell prepareForUseInTableView:tableView indexPath:indexPath storeRow:storeRow sender:self];
        cell = rowCell;
    }
    else if(indexPath.section==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"TotalPriceCell"];
        UILabel *priceLabel = cell.textLabel;
        priceLabel.text = [NSString stringWithFormat:@"行程总价:%d元",[self calPrice]];
        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommitCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return HEIGHT_STORE_ROW_CELL;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        [self performSegueWithIdentifier:@"goToDetail" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        UIViewController *des = segue.destinationViewController;
        StoreRowCell *cell = sender;
        [des setValue:cell.storeRow forKey:@"storeRow"];
    }
    if ([segue.identifier isEqualToString:@"goToColumn"]) {
        UIViewController *des = segue.destinationViewController;

        JFOneRoute *route = [self.jFun generateRouteWithStores:self.selectedStores];
        [des setValue:route forKey:@"route"];
    }
}
#pragma mark jfun delegate
- (void)JfunDidFreshing:(BOOL)isError{
    if (!isError) {
        [ProgressHUD dismiss];
        [self prepareData];
        [self.infoListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
        [ProgressHUD showError:@"无法连接到服务器，请检查网络设置:("];
        NSLog(@"ActivityListView: when freshing");
    }
}
- (void)loadNibs{
    UINib *cellNib=[UINib nibWithNibName:@"StoreRowCell" bundle:[NSBundle mainBundle]];
    [self.infoListTableView registerNib:cellNib forCellReuseIdentifier:ID_STORE_ROW_CELL];
}


@end
