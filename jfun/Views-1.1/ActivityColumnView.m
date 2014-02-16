//
//  ActivityColumnView.m
//  jfun
//
//  Created by mmm on 14-2-3.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "ActivityColumnView.h"
@interface ActivityColumnView(){
    UITableView *_tableView;
    UIButton *_locationButton;
    UIImageView *_imageView;
    NSArray *_stores;
}
@end
@implementation ActivityColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self loadButton];
        [self loadTableView];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self loadButton];
        [self loadTableView];
       
    }
    return self;
}
- (void)layoutSubviews{
    // Initialization code


}
- (void)setRoute:(JFOneRoute *)route{
    _route=route;
    [self loadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH_STORE_COLUMN_CELL;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_stores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        StoreColumnCell *colCell;
        colCell = (StoreColumnCell *)[tableView dequeueReusableCellWithIdentifier:ID_STORE_COLUMN_CELL];
        cell = [colCell prepareForUseWithStore:[_stores objectAtIndex:indexPath.row] tableView:tableView];
    }
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    return cell;
}
- (void)loadNibs{
    UINib *cellNib=[UINib nibWithNibName:@"StoreColumnCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:ID_STORE_COLUMN_CELL];
    
}
- (void)loadTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-HEIGHT_STORE_COLUMN_CELL, self.bounds.size.width, HEIGHT_STORE_COLUMN_CELL)];
    
    _tableView.transform =  CGAffineTransformMakeRotation(M_PI/-2);
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 10, 0);
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [self loadNibs];
}
- (void)loadButton{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activityColumn-main-location-background"]];
    [self addSubview:_imageView];
    
    _locationButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 6, 13, 23)];
    [_locationButton setImage:[UIImage imageNamed:@"activityColumn-main-location-location"] forState:UIControlStateNormal];
    [self addSubview:_locationButton];
    [self bringSubviewToFront:_locationButton];
    [_locationButton addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadData{
    if (self.route.isGenerated) {
    [[JFStore sharedInstance] cacheWithSids:self.route.storeIDs completeBlock:^(NSDictionary *result){
        _stores=[result allValues];
        [_tableView reloadData];
    }];
    }
    else{
    [[JFPoint sharedInstance] startFreshFromServerWithSids:self.route.storeIDs completeBlock:^(NSDictionary *result){
            _stores=[result allValues];
            [_tableView reloadData];
        }];
    
    }
}
- (IBAction)locationButtonPressed:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end
