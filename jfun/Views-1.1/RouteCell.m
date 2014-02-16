//
//  RouteCell.m
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define COLOR_DESCRIPTION [UIColor grayColor]
#define COLOR_STYLE COLOR(255, 136, 0, 1)
#import "RouteCell.h"
@interface RouteCell(){
    UIView *_boundView;
    UIView *_rightView;
    UILabel *_titleLabel;
    UILabel *_descriptionLabel;
    UILabel *_styleLabel;
}
@end
@implementation RouteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=CLEARCOLOR;
        [self prepareTriangleView];
        [self prepareLabelView];
        [self prepareImageView];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    [super setSelected:selected animated:NO];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:NO];
}
- (void)setRoute:(JFOneRoute *)route{
    _route=route;
    _titleLabel.text=route.title;
    _descriptionLabel.text=route.description;
    _styleLabel.text=route.style;
    
    [self.TriangleView setPictureURLString:route.picURL];
}

- (void)prepareTriangleView{
    _boundView = [[UIView alloc] initWithFrame:CGRectMake(6, 3, 308, 120)];
    _boundView.clipsToBounds=YES;
    self.TriangleView = [[TriangleCell alloc] initWithFrame:CGRectMake(0, 0, _boundView.frame.size.width , _boundView.frame.size.height)];
    _rightView=self.TriangleView.rightView;
    [self.contentView addSubview:_boundView];
    [_boundView addSubview:self.TriangleView];
}
- (void)prepareLabelView{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 8, 118, 20)];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 26, 118, 40)];
    _descriptionLabel.textColor=COLOR_DESCRIPTION;
    _descriptionLabel.font=[UIFont systemFontOfSize:14];
    _descriptionLabel.numberOfLines=3;
    
    _styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 86, 100, 20)];
    _styleLabel.textColor = COLOR_STYLE;
    _styleLabel.font = [UIFont systemFontOfSize:14];
    
    [_rightView addSubview:_titleLabel];
    [_rightView addSubview:_descriptionLabel];
    [_rightView addSubview:_styleLabel];
    
}
- (void)prepareImageView{
    UIImage *rightImage = [UIImage imageNamed:@"triangle-cell-right-activity"];
    [self.TriangleView setRightPicture:rightImage];
    self.TriangleView.mainPictureWidth=185;
}

@end
