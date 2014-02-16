//
//  StoreColumCell.h
//  jfun
//
//  Created by mmm on 14-1-30.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define ID_STORE_COLUMN_CELL @"StoreColumnCell"
#define WIDTH_STORE_COLUMN_CELL 172
#define HEIGHT_STORE_COLUMN_CELL 322

#import <UIKit/UIKit.h>

@interface StoreColumnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (instancetype)prepareForUseWithStore:(JFOneStore *)store tableView:(UITableView *)tableView;
@end
