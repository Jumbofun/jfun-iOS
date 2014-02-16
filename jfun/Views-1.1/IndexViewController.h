//
//  IndexViewController.h
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexViewMainCell.h"
#import "IndexViewMoreCell.h"
#import "ActivityCell.h"
#import "loadingCell.h"
#import "ActivityDetailViewController.h"

@interface IndexViewController : UITableViewController<JFunUserInfoDelegate,JFActivityDelegate>

@property (nonatomic,strong) MIQUJFun *jFun;
@property (nonatomic,strong) MIQUUserInput *userInput;

- (void)commitWithShaking:(BOOL)isShake;
@end

@interface TopTable : UITableView

@end