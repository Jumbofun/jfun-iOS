//
//  MineMainViewController.h
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> 
@property (strong, nonatomic) UIScrollView *imageScroller;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
