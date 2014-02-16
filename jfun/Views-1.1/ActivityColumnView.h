//
//  ActivityColumnView.h
//  jfun
//
//  Created by mmm on 14-2-3.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreColumnCell.h"
@interface ActivityColumnView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) void (^block)();
@property (strong, nonatomic) JFOneRoute *route;

- (IBAction)locationButtonPressed:(id)sender;

@end
