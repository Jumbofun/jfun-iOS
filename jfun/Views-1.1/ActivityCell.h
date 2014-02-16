//
//  ActivityCell.h
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "TriangleCell.h"

#define HEIGHT_ACTIVITY_CELL 130
#define ID_ACTIVITY_CELL @"ActivityCell"

typedef enum CELL_PROPERTY {
    NONE,
    HOT_ACTIVITY,
    NEW_ACTIVITY
}CELL_PROPERTY;

@interface ActivityCell : UITableViewCell
@property (strong, nonatomic) TriangleCell *TriangleView;
@property (strong,nonatomic) JFOneActivity *activity;

@property (nonatomic) CELL_PROPERTY cellProperty;

@end
