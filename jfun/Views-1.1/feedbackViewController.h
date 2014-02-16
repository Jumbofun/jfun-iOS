//
//  feedbackViewController.h
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedbackViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)commitButtonPressed:(id)sender;

@end
