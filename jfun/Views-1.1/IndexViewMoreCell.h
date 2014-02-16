//
//  IndexViewMoreCell.h
//  jfun
//
//  Created by mmm on 14-1-25.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexViewController.h"

#define ID_INDEX_VIEW_MORE_CELL @"IndexViewMoreCell"

@interface IndexViewMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (CGFloat)getHeight;
- (void)scrollViewDidScroll:(CGFloat)angle isDown:(BOOL)isDown;
- (void)endScroll;
@end
