//
//  ActivityDetailViewController.h
//  jfun
//
//  Created by mmm on 14-2-9.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)favorateButtonPressed:(id)sender;
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *favorateButton;
@property (nonatomic,strong)JFOneActivity *activity;

@end
