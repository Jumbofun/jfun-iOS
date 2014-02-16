//
//  StoreRowCell.h
//  jfun
//
//  Created by mmm on 14-1-27.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define ID_STORE_ROW_CELL @"StoreRowCell"
#define HEIGHT_STORE_ROW_CELL 90

#import <UIKit/UIKit.h>
#import "ActivityListViewController.h"
#import "StoreCell.h"


@interface StoreRowCell : UITableViewCell<JFunUserInfoRowDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *edgeImageViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *edgeImageViewRight;
@property (strong,nonatomic)MIQUInfoListRow *storeRow;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)categoryButtonPressed:(id)sender;
- (void)prepareForUseInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath storeRow:(MIQUInfoListRow *)storeRow sender:(id)sender;

@end
