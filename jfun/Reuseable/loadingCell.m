//
//  loadingCell.m
//  jfun
//
//  Created by mmm on 14-2-9.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "loadingCell.h"

@implementation LoadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGSize bound = self.contentView.bounds.size;
        CGSize size = indicator.frame.size;
        indicator.frame=CGRectMake(bound.width/2-size.width/2, bound.height/2-size.height/2, size.width, size.height);
        [self.contentView addSubview:indicator];
        [indicator startAnimating];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:NO];
}
@end
