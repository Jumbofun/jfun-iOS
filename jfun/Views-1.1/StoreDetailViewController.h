//
//  StoreDetailViewController.h
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MIQUInfoListRow *storeRow;

@end
