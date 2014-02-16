//
//  StoreRowCell.m
//  jfun
//
//  Created by mmm on 14-1-27.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "StoreRowCell.h"
@interface StoreRowCell(){
    MIQUInfoListRow *_storeRow;
    ActivityListViewController *_controller;
    UITableView *_fatherTableView;
    NSIndexPath *_indexPath;
    UILabel *_descriptionLabel;
    UIView *_descriptionBackgroundView;
    BOOL _isFreshing;
    //ios 6 sdk
    __weak UITableView *_tbView;
}

@end
@implementation StoreRowCell
@synthesize storeRow=_storeRow,tableView=_tbView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    [super setSelected:selected animated:NO];

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setSelected:highlighted animated:NO];
}

- (IBAction)categoryButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [button setSelected:NO];
        _storeRow.categoty = allCategory;
    }
    else{
        JFOneStore *store = _storeRow.lastStore;
        [button setSelected:YES];
        _storeRow.categoty = [JFOneStore categoryTypeForString:store.category];
    }
    [self freshView];
    [self.tableView reloadData];
}

- (void)prepareForUseInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath storeRow:(MIQUInfoListRow *)storeRow sender:(id)sender{
    UIImageView *leftUpImageView,*leftDownImageView;

    _storeRow = storeRow;
    _storeRow.cell = self;
    _controller = sender;
    _fatherTableView = tableView;
    _indexPath = indexPath;
    _isFreshing = NO;
    
    leftUpImageView = (UIImageView *)[self viewWithTag:2];
    leftDownImageView = (UIImageView *)[self viewWithTag:3];
    
    //configure image
    if (_indexPath.row == 0) {
        leftUpImageView.hidden = YES;
        leftDownImageView.hidden = NO;
    }
    else if (indexPath.row == [tableView numberOfRowsInSection:0] - 1){
        leftUpImageView.hidden = NO;
        leftDownImageView.hidden = YES;
    }
    else{
        leftUpImageView.hidden = NO;
        leftDownImageView.hidden = NO;
    }
    
    //configure tableview
    self.tableView.transform =  CGAffineTransformMakeRotation(M_PI/-2);
    [self.tableView setPagingEnabled:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self freshView];
    
}
#pragma mark --scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger n = scrollView.contentOffset.y/scrollView.frame.size.width;
    NSArray *stores;
    stores = [_storeRow getArr];
    
    JFOneStore *store = stores[n];
    _storeRow.lastStore = store;
    

    //change main list price
    NSMutableArray *selectedStores =[_controller valueForKey:@"selectedStores"];
    [selectedStores setObject:store atIndexedSubscript:_indexPath.section];
    [_controller performSelector:@selector(showPrice) withObject:nil afterDelay:0.1f];
    //freshing
    if (n >= [_storeRow.stores count] - 2 && !_isFreshing) {
        _isFreshing = YES;
        MIQUJFun *jFun = _storeRow.jFun;
        if (_storeRow.categoty == allCategory){
            [jFun startFreshFromServerByTime:_storeRow.time];
        }
        else{
            [jFun startFreshFromServerByTime:_storeRow.time categoty:_storeRow.categoty];
        }
    }
    [self freshView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH_STORE_CELL;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_storeRow getArr] count];
}

- (StoreCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCell *cell;
    cell = (StoreCell *)[tableView dequeueReusableCellWithIdentifier:ID_STORE_CELL];
    if (!cell)
        cell=[[StoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID_STORE_CELL];
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    [cell prepareForUseWithStore:[_storeRow getArr][indexPath.row] tableView:tableView controller:self];

    return cell;
}
//pass selection event to father tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_controller tableView:_fatherTableView didSelectRowAtIndexPath:_indexPath];
}
- (void)rowDidFresh:(id)sender{
    _isFreshing = NO;
    [self.tableView reloadData];
}
- (void)freshView{
    //button
    [self.categoryButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"activity-list-cell-%@-normal",_storeRow.lastStore.category]] forState:UIControlStateNormal];
    [self.categoryButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"activity-list-cell-%@-highlighted",_storeRow.lastStore.category]] forState:UIControlStateSelected];
    //edge image
    BOOL isSelected = self.categoryButton.isSelected;
    [self.edgeImageViewLeft setHighlighted:isSelected];
    [self.edgeImageViewRight setHighlighted:isSelected];
}

@end
