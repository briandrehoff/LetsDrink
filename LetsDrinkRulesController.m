//
//  LetsDrinkRulesController.m
//  Let's Drink
//
//  Created by Brian Drehoff on 3/25/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import "LetsDrinkRulesController.h"

@interface LetsDrinkRulesController ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation LetsDrinkRulesController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Touch events

// All touch events are implemented but left blank in order to prevent the background/parent view controller from activating.
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


#pragma mark - Set status bar to white
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
