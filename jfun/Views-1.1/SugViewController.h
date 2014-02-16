//
//  SugViewController.h
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ActivityCell.h"
#import "RouteCell.h"

@interface SugViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JFRouteDelegate,JFActivityDelegate>

@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectionButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)selectButttonPressed:(id)sender;
@end
