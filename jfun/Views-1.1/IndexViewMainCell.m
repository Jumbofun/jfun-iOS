//
//  IndexViewMainCell.m
//  jfun
//
//  Created by mmm on 14-1-24.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#define TAG_SECTOR_HOUR             2
#define TAG_SECTOR_PERSON           1
#define TAG_BUTTON_CATEGORY_LOVER   10
#define TAG_BUTTON_CATEGORY_FRIEND  11

#define COLOR_BUTTON_LOCATION       UIColorFromRGB(0xf5af7e)
#define COLOR_MUL_EMPTY_CIRCLE      UIColorFromRGB(0x344050)
#define COLOR_MUL_CIRCLE            UIColorFromRGB(0xEB6772)
#define COLOR_HOUR_LABEL_CIRCLE     UIColorFromRGB(0xf39800)

#import "IndexViewMainCell.h"
@interface IndexViewMainCell(){
    MLTableAlert *_alert;
    NSArray *_locations;
}
@end
@implementation IndexViewMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}
- (void)layoutSubviews{
    self.cc.contentSize=CGSizeMake(320, 900);
    [self configLabels];
    [self freshLocationArray];
    //initialize circle slider
    [self configMultiSector];
    //initialize button
    UIButton *button = [self.buttonCategories lastObject];
    [button setSelected:YES];
    self.buttonLocation.backgroundColor = COLOR_BUTTON_LOCATION;
    
}

- (void)dealloc{
    [self resignFirstResponder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (IBAction)buttonLocationPressed:(id)sender {
    [self showLocationAlert];

}

- (IBAction)buttonCategoryPressed:(id)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonCategoryPressed:) object:sender];
    
    for (UIButton *button in self.buttonCategories) {
        if ([sender isEqual:button]) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }

}

- (IBAction)buttonCommitPressed:(id)sender {
    IndexViewController *fatherController = self.fatherController;
    if (fatherController) {
        Style style = [self.buttonCategories[1] isSelected]?lovers:friends;
        SAMultisectorSector *sector = [self.MutiSectorControl sectors][0];
        NSInteger startTime = (NSInteger)sector.startValue;
        NSInteger endTime = (NSInteger)sector.endValue;
        
        MIQUUserInput *userinput = [[MIQUUserInput alloc]
                                    initWithStyle:style
                                    location:self.labelLocation.text
                                    fromTime:startTime
                                    toTime:endTime];
        if ([fatherController canPerformAction:@selector(setUserInput:) withSender:userinput]) {
            fatherController.userInput = userinput;
            [fatherController commitWithShaking:NO];
        }
    }
    
}
- (void)configLabels{
    self.labelEndHour.transitionDuration=0.6;
    self.labelPeople.transitionDuration=0.6;
    self.labelStartHour.transitionDuration=0.6;
    self.labelHours.transitionDuration=0.6;
    
if (IOS_VERSION>=7.0)
    self.labelHours.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:70];
else
    self.labelHours.font = [UIFont fontWithName:@"Helvetica Neue" size:70];
    self.labelStartHour.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    self.labelEndHour.font =[UIFont fontWithName:@"Helvetica Neue" size:13];
    self.labelPeople.font = [UIFont boldSystemFontOfSize:13];
    
    self.labelHours.textColor = [UIColor whiteColor];
    self.labelStartHour.textColor = [UIColor whiteColor];
    self.labelEndHour.textColor = [UIColor whiteColor];
    self.labelPeople.textColor = [UIColor whiteColor];
    
    self.labelStartHour.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
    self.labelEndHour.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
    self.labelHours.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
    self.labelPeople.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
    
    self.labelEndHour.backgroundColor=COLOR_HOUR_LABEL_CIRCLE;
    self.labelStartHour.backgroundColor=COLOR_HOUR_LABEL_CIRCLE;
}
- (void)configMultiSector{
    if ([[self.MutiSectorControl sectors] count]) return;
    [self.MutiSectorControl addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.MutiSectorControl.emptyCircleColor = COLOR_MUL_EMPTY_CIRCLE;

    UIColor *sectorHourColor = COLOR_MUL_CIRCLE;

    SAMultisectorSector *hourSector = [SAMultisectorSector sectorWithColor:sectorHourColor minValue:0 maxValue:24];
    hourSector.tag = TAG_SECTOR_HOUR;
    
    [self.MutiSectorControl addSector:hourSector];
    
    hourSector.startValue=0;
    hourSector.endValue=0;
    [self performSelector:@selector(configTimeSector:) withObject:hourSector afterDelay:0.1f];
    [self freshLabel];
}
- (void)configTimeSector:(SAMultisectorSector *)hourSector{
    //now
    NSDate *now = [NSDate date];
    NSDateFormatter *f=[NSDateFormatter new];
    f.dateFormat=@"H";
    NSInteger nowHour = [[f stringFromDate:now] integerValue];
    [self.MutiSectorControl setStartValueWithSector:hourSector value:nowHour];
    [self.MutiSectorControl setEndValueWithSector:hourSector value:(nowHour+6)%24];
}
- (void)multisectorValueChanged:(id)sender{
    [self freshLabel];
    
}
- (void)freshLabel{

    SAMultisectorSector *sector = [self.MutiSectorControl sectors][0];

    [self.labelHours setText:[NSString stringWithFormat:@"%02d",(int)(sector.endValue+.5)-(int)(sector.startValue+.5)] animated:YES];

    [self.labelStartHour setText: [NSString stringWithFormat:@"%02d:00",(int)(sector.startValue+.5)] animated:YES];
    [self.labelEndHour setText: [NSString stringWithFormat:@"%02d:00",(int)(sector.endValue+.5)] animated:YES];
    
}
- (void)showLocationAlert{
    // create the alert
	_alert = [MLTableAlert tableAlertWithTitle:@"选择商圈" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
              {
                  return [_locations count];
              }
                                      andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
              {
                  static NSString *CellIdentifier = @"CellIdentifier";
                  UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                  if (cell == nil)
                      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                  
                  cell.textLabel.text = [NSString stringWithFormat:@"%@",_locations[indexPath.row]];
                  
                  return cell;
              }];
	
	// Setting custom alert height
	_alert.height = 350;
	
	// configure actions to perform
	[_alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
		self.labelLocation.text = _locations[selectedIndex.row];
	} andCompletionBlock:^{
		
	}];
	
	// show the alert
	[_alert show];
}
- (void)freshLocationArray{
    if (!_locations) {
        _locations = [USER_DEFAULT arrayForKey:DEFAULT_NAME_LOCATION_ARRAY];
    }
}


@end
