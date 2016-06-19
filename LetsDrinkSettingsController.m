//
//  LetsDrinkSettingsController.m
//  Let's Drink
//
//  Created by Brian Drehoff on 3/7/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import "LetsDrinkSettingsController.h"

@interface LetsDrinkSettingsController ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *playersLabel;
@property (weak, nonatomic) IBOutlet UILabel *minWaitLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxWaitLabel;
@property (weak, nonatomic) IBOutlet UILabel *minDrinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxDrinkLabel;
@property (weak, nonatomic) IBOutlet UIStepper *playersStepper;
@property (weak, nonatomic) IBOutlet UIStepper *minWaitStepper;
@property (weak, nonatomic) IBOutlet UIStepper *maxWaitStepper;
@property (weak, nonatomic) IBOutlet UIStepper *minDrinkStepper;
@property (weak, nonatomic) IBOutlet UIStepper *maxDrinkStepper;

@end

@implementation LetsDrinkSettingsController

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
    int minWait = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"minWait"];
    int maxWait = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxWait"];
    if (minWait < 6)
    {
        self.minWaitStepper.value = minWait;
        self.minWaitLabel.text = [NSString stringWithFormat:@"%u s", minWait*10];
    }
    else
    {
        self.minWaitStepper.value = minWait;
        self.minWaitLabel.text = [NSString stringWithFormat:@"%u m", minWait-5];
    }
    if (maxWait < 6)
    {
        self.maxWaitStepper.value = maxWait;
        self.maxWaitLabel.text = [NSString stringWithFormat:@"%u s", maxWait*10];
    }
    else
    {
        self.maxWaitStepper.value = maxWait;
        self.maxWaitLabel.text = [NSString stringWithFormat:@"%u s", maxWait-5];
    }
    
    self.playersStepper.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"];
    self.playersLabel.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"]];
    
    self.minDrinkStepper.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"minDrink"];
    self.minDrinkLabel.text = [NSString stringWithFormat:@"%ld s", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"minDrink"]];
    self.maxDrinkStepper.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxDrink"];
    self.maxDrinkLabel.text = [NSString stringWithFormat:@"%ld s", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxDrink"]];
    
    self.minDrinkStepper.maximumValue = self.maxDrinkStepper.value;
    self.minWaitStepper.maximumValue = self.maxWaitStepper.value;
    self.maxDrinkStepper.minimumValue = self.minDrinkStepper.value;
    self.maxWaitStepper.minimumValue = self.minWaitStepper.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDrinkController:(LetsDrinkModelController *)drinkController
{
    _drinkController = drinkController;
}

#pragma mark - Button press methods

- (IBAction)donePressed:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playersStepper:(UIStepper*)sender
{
    int value = [sender value];
    self.playersLabel.text = [NSString stringWithFormat:@"%u", value];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"numberOfPlayers"];
}

- (IBAction)minWaitStepper:(UIStepper*)sender
{
    int value = [sender value];
    self.maxWaitStepper.minimumValue = value;
    if (value < 6)
    {
        int seconds = value*10;
        self.minWaitLabel.text = [NSString stringWithFormat:@"%u s", seconds];
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"minWait"];
    }
    else
    {
        int minutes = value-5;
        self.minWaitLabel.text = [NSString stringWithFormat:@"%u m", minutes];
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"minWait"];
    }
}

- (IBAction)maxWaitStepper:(UIStepper*)sender
{
    int value = [sender value];
    self.minWaitStepper.maximumValue = value;
    if (value < 6)
    {
        int seconds = [sender value]*10;
        self.maxWaitLabel.text = [NSString stringWithFormat:@"%u s", seconds];
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"maxWait"];
    }
    else
    {
        int minutes = value-5;
        self.maxWaitLabel.text = [NSString stringWithFormat:@"%u m", minutes];
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"maxWait"];
    }
}

- (IBAction)minDrinkStepper:(UIStepper*)sender
{
    int value = [sender value];
    self.maxDrinkStepper.minimumValue = value;
    self.minDrinkLabel.text = [NSString stringWithFormat:@"%u s", value];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"minDrink"];
}

- (IBAction)maxDrinkStepper:(UIStepper*)sender
{
    int value = [sender value];
    self.minDrinkStepper.maximumValue = value;
    self.maxDrinkLabel.text = [NSString stringWithFormat:@"%u s", value];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"maxDrink"];
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
