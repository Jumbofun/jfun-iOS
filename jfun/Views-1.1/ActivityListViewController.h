//
//  ActivityListViewController.h
//  jfun
//
//  Created by mmm on 14-1-29.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreRowCell.h"

@interface ActivityListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,JFunUserInfoDelegate>

@property (strong,nonatomic) MIQUJFun *jFun;
@property (strong,nonatomic) NSMutableArray *selectedStores;
@property (weak, nonatomic) UILabel *priceAmountLbl;

@property (weak, nonatomic) IBOutlet UITableView *infoListTableView;

- (IBAction)commitButtonPressed:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)changeButtonPressed:(id)sender;

//- (IBAction)deleteBtn:(id)sender;
//- (IBAction)shareBtn:(id)sender;

- (void)showPrice;
@end
