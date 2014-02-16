//
//  StoreCell.m
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "StoreCell.h"
@interface StoreCell(){
    NSMutableArray *_starImageViews;
    id _controller;
}
@end

@implementation StoreCell
@synthesize triangleCell,titleLabel,addressLabel,firstStarImageView,priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 250, 80);
        
        self.triangleCell = [[TriangleCell alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
        [self.contentView addSubview:self.triangleCell];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 135, 21)];
        titleLabel.font=[UIFont boldSystemFontOfSize:16];
        self.addressLabel =[[UILabel alloc] initWithFrame:CGRectMake(37, 24, 135, 21)];
        addressLabel.font=[UIFont systemFontOfSize:13];
        addressLabel.textColor=[UIColor grayColor];
        self.priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(99, 53, 62, 21)];
        priceLabel.font=[UIFont systemFontOfSize:13];
        priceLabel.textColor=[UIColor colorWithRed:229/255.0 green:127/255.0 blue:65/255.0 alpha:255/255.0];
        self.firstStarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 59, 10, 10)];
        
        [self.triangleCell.rightView addSubview:self.titleLabel];
        [self.triangleCell.rightView addSubview:self.addressLabel];
        [self.triangleCell.rightView addSubview:self.priceLabel];
        [self.triangleCell.rightView addSubview:self.firstStarImageView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    //[_controller setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    //[_controller setHighlighted:highlighted animated:NO];
}

- (instancetype)prepareForUseWithStore:(MIQUStore *)store tableView:(UITableView *)tableView controller:(id)controller{
    _controller = controller;
    //picture
    triangleCell.leftPicture = nil;
    triangleCell.rightPicture = [UIImage imageNamed:@"activity-list-cell-right"];
    triangleCell.mainPictureWidth = 120;
    triangleCell.pictureURLString = store.photos[0];
    //text
    titleLabel.text = store.name;
    addressLabel.text = store.address;
    NSString *priceStr;
    if ([store.price integerValue]>0) {
        priceStr = [NSString stringWithFormat:@"￥ %@",store.price];
    }
    else if([store.price integerValue]==0){
        priceStr = @"免费";
    }
    else{
        priceStr = @"以实际为准";
        priceLabel.font = [UIFont systemFontOfSize:12];
    }
    priceLabel.text = priceStr;
    //star
    [self configureStarImageForRating:[store.rating integerValue]];
    return self;
}

- (void)configureStarImageForRating:(NSInteger)rating{
    //initialation
    if (!_starImageViews)
    {
        _starImageViews = [NSMutableArray arrayWithObject:self.firstStarImageView];
        CGRect frame = firstStarImageView.frame;
        for (int i = 1; i <= 4; i++) {
            CGRect frame1 = CGRectMake(frame.origin.x + 12 * i, frame.origin.y, frame.size.width, frame.size.height);
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:frame1];
            [self.triangleCell.rightView addSubview:starImageView];
            [_starImageViews addObject:starImageView];
        }
    }
    
    UIImage *starFullImage = [UIImage imageNamed:@"starFull"];
    UIImage *starEmptyImage = [UIImage imageNamed:@"starEmpty"];
    int i;
    for (i = 0; i < rating; i++) {
        UIImageView *starImageView = _starImageViews[i];
        starImageView.image = starFullImage;
    }
    for (; i<5; i++) {
        UIImageView *starImageView = _starImageViews[i];
        starImageView.image = starEmptyImage;
    }
}
@end
