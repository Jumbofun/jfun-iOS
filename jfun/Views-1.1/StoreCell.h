//
//  StoreCell.h
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define HEIGHT_STORE_CELL 80
#define WIDTH_STORE_CELL 250
#define ID_STORE_CELL @"StoreCell"

#import <UIKit/UIKit.h>
#import "MIQUStore.h"
#import "TriangleCell.h"

@interface StoreCell : UITableViewCell
@property (strong, nonatomic)  TriangleCell *triangleCell;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UIImageView *firstStarImageView;
@property (strong, nonatomic)  UILabel *priceLabel;

- (instancetype)prepareForUseWithStore:(MIQUStore *)store tableView:(UITableView *)tableView controller:(id)controller;
@end
