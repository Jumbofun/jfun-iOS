//
//  RouteCell.h
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleCell.h"

#define HEIGHT_ROUTE_CELL 130
#define ID_ROUTE_CELL @"RouteCell"


@interface RouteCell : UITableViewCell

@property (strong, nonatomic) TriangleCell *TriangleView;
@property (strong, nonatomic) JFOneRoute *route;

@end
