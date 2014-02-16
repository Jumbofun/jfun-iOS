//
//  ActivityCell.m
//  jfun
//
//  Created by mmm on 14-1-26.
//  Copyright (c) 2014年 miqu. All rights reserved.
//
#define COLOR_DESCRIPTION [UIColor grayColor]
#define COLOR_TEXT_BACKGROUND COLOR(255, 248, 1, 1)

#import "ActivityCell.h"
@interface ActivityCell(){
    UIView *_rightView;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_locationLabel;
    UIView *_boundView;
}
@end
@implementation ActivityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}
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
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
- (void)setActivity:(JFOneActivity *)activity{
    _activity=activity;
    _titleLabel.text=activity.name;
    _locationLabel.text=activity.address;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"MM月d日";
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat=@"HH:m";
    
    NSString *dateString = [NSString stringWithFormat:@"%@ ~ %@",[dateFormatter stringFromDate:activity.startdatetime],[dateFormatter stringFromDate:activity.enddatetime]];
    NSString *timeString = [NSString stringWithFormat:@"%@-%@",[timeFormatter stringFromDate:activity.startdatetime],[timeFormatter stringFromDate:activity.enddatetime]];
    NSString *datetimeString = [NSString stringWithFormat:@"%@\n%@",dateString,timeString];
    _timeLabel.text=datetimeString;
    
    [_TriangleView setPictureURLString:[activity.plink firstObject]];
}
- (void)setCellProperty:(CELL_PROPERTY)cellProperty{
    _cellProperty=cellProperty;
    
    UIImage *leftImage;
    if (cellProperty==NONE) {
        leftImage = nil;
    }
    else if (cellProperty==HOT_ACTIVITY){
        leftImage = [UIImage imageNamed:@"triangle-cell-left-hot"];
    }
    else if (cellProperty==NEW_ACTIVITY){
        leftImage = [UIImage imageNamed:@"triangle-cell-left-new"];
    }
    else{
        NSLog(@"Invalid cellProperty");
        return;
    }
    [self.TriangleView setLeftPicture:leftImage];
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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 4, 125, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 41, 118, 46)];
    _timeLabel.textColor=COLOR_DESCRIPTION;
    _timeLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel.numberOfLines=3;
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 102, 125, 13)];
    _locationLabel.textColor = COLOR_DESCRIPTION;
    _locationLabel.font = [UIFont systemFontOfSize:13];
    
    [_rightView addSubview:_titleLabel];
    [_rightView addSubview:_timeLabel];
    [_rightView addSubview:_locationLabel];
    
    //fixed time&locaton label
    UILabel *fixedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 29, 37, 13)];
    fixedTimeLabel.font=[UIFont systemFontOfSize:14];
    fixedTimeLabel.textColor=COLOR_DESCRIPTION;
    fixedTimeLabel.backgroundColor=COLOR_TEXT_BACKGROUND;
    fixedTimeLabel.text=@"时间:";
    UILabel *fixedLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 87, 37, 13)];
    fixedLocationLabel.font=[UIFont systemFontOfSize:14];
    fixedLocationLabel.textColor=COLOR_DESCRIPTION;
    fixedLocationLabel.backgroundColor=COLOR_TEXT_BACKGROUND;
    fixedLocationLabel.text=@"地点:";
    [_rightView addSubview:fixedTimeLabel];
    [_rightView addSubview:fixedLocationLabel];
    
}
- (void)prepareImageView{
    UIImage *rightImage = [UIImage imageNamed:@"triangle-cell-right-live-activity"];
    [self.TriangleView setRightPicture:rightImage];
    self.TriangleView.mainPictureWidth=185;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
