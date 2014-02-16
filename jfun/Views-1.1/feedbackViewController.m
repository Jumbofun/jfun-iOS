//
//  feedbackViewController.m
//  jfun
//
//  Created by mmm on 14-2-1.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()

@end

@implementation feedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 3);
    [self prepareToolBar];
    
    self.textView.text=[NSString stringWithFormat:@"iOS版本：%@\n是否5、5S:%@\n",    [NSNumber numberWithFloat:IOS_VERSION],(iPhone5?@"YES":@"NO")];
    self.countLabel.text = [NSString stringWithFormat:@"%d字",[self.textView.text length]];

}
- (void)viewDidAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self keyboardDidShow];
}
- (void)textViewDidChange:(UITextView *)textView{
    self.countLabel.text = [NSString stringWithFormat:@"%d字",[self.textView.text length]];
}
- (IBAction)commitButtonPressed:(id)sender {
    [ProgressHUD showSuccess:@"您的建议已在后台提交，十分感谢:)"];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardDidHidden];

}

- (void)prepareToolBar{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    
    [self.textView setInputAccessoryView:topView];
}
//隐藏键盘
- (void)resignKeyboard {
    [self keyboardDidHidden];
}

// 键盘弹出时
-(void)keyboardDidShow
{
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.2f];
    
    //设置view的frame，往上平移
    [self.view setFrame:CGRectMake(0,-130, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}
//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    //设置view的frame，往下平移
    [self.view setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    //隐藏键盘
    [self.textView resignFirstResponder];
}
@end
