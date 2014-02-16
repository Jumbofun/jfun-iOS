//
//  IndexViewMainCell.h
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexViewController.h"

#define HEIGHT_INDEX_VIEW_MAIN_CELL iPhone5?455:455+480-568
#define ID_INDEX_VIEW_MAIN_CELL @"IndexViewMainCell"

@interface IndexViewMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SAMultisectorControl *MutiSectorControl;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *labelHours;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *labelPeople;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *labelStartHour;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *labelEndHour;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) id fatherController;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCategories;
@property (weak, nonatomic) IBOutlet UIScrollView *cc;

- (IBAction)buttonLocationPressed:(id)sender;
- (IBAction)buttonCategoryPressed:(id)sender;
- (IBAction)buttonCommitPressed:(id)sender;


@end
