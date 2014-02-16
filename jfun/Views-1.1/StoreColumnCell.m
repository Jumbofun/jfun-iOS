//
//  StoreColumnCell.m
//  jfun
//
//  Created by mmm on 14-1-31.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "StoreColumnCell.h"

@implementation StoreColumnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
- (instancetype)prepareForUseWithStore:(JFOneStore *)store tableView:(UITableView *)tableView{
    self.titleLabel.text = store.name;
    self.addressLabel.text = store.address;

    [self.storeImageVIew setImageWithURL:[NSURL URLWithString:store.photos[0]] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    self.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity-list-cell-%@-normal",store.category]];
    
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    // Drawing line.
    CGContextBeginPath(context);
    CGRect frame = self.timeLabel.frame;
    CGContextMoveToPoint(context, frame.origin.x,frame.origin.y);
    CGContextAddLineToPoint(context, frame.origin.x, self.categoryImageView.frame.origin.y+self.categoryImageView.frame.size.height-7);
    CGContextStrokePath(context);
}
@end
