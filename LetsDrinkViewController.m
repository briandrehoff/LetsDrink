//
//  LetsDrinkViewController.m
//  Let's Drink
//
//  Created by Brian Drehoff on 3/6/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import "LetsDrinkViewController.h"
#import "LetsDrinkModelController.h"
#import "LetsDrinkSettingsController.h"
#import "LetsDrinkRulesController.h"
#import "TouchCircle.h"

@interface LetsDrinkViewController ()

@property (strong, nonatomic) LetsDrinkModelController *drinkController;
@property (strong, nonatomic) LetsDrinkSettingsController *settingsController;
@property (strong, nonatomic) LetsDrinkRulesController *rulesController;
@property (weak, nonatomic) IBOutlet UIButton *tapToPlay;
@property (weak, nonatomic) IBOutlet UIButton *tapToPause;
@property (weak, nonatomic) IBOutlet UILabel *loserDrinksLabel;
@property (weak, nonatomic) IBOutlet UILabel *getReadyLabel;
@property (weak, nonatomic) IBOutlet UILabel *letsDrinkLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *rulesButton;


@property (strong, nonatomic) NSMutableArray *touches;
@property (strong, nonatomic) NSMutableArray *touchImages;
@property (strong, nonatomic) NSMutableArray *touchViews;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) CFTimeInterval startTime;
@end

@implementation LetsDrinkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!_drinkController)
    {
        _drinkController = [[LetsDrinkModelController alloc] init];
    }
    if (!_settingsController)
    {
        _settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"LetsDrinkSettingsController"];
        _settingsController.drinkController = self.drinkController;
    }
    if (!_rulesController)
    {
        _rulesController = [self.storyboard instantiateViewControllerWithIdentifier:@"LetsDrinkRulesController"];
    }
    self.view.multipleTouchEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAnimation) name:UIApplicationWillEnterForegroundNotification object:nil]; // restarts animation on application foreground
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.drinkController.paused)
    {
        self.drinkController.gameStarted = NO;
        self.tapToPlay.alpha = 1;
        self.tapToPause.alpha = 0;
        self.loserDrinksLabel.alpha = 0;
        self.getReadyLabel.alpha = 0;
    }
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
        //[self.letsDrinkLabel setAlpha:1]; //first part of animation
        //[self.letsDrinkLabel setAlpha:0.8]; //first part of animation
        self.letsDrinkLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {}];
    //self.tapToPlay.imageView.image = [UIImage imageNamed:@"touchImage.png"];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [UIView setAnimationsEnabled:YES];
    [self.letsDrinkLabel.layer removeAllAnimations];
    self.letsDrinkLabel.layer.transform = CATransform3DIdentity;
}

// Reloads the bouncing "Let's Drink!" animation on application foreground.
- (void) reloadAnimation
{
    [UIView setAnimationsEnabled:YES];
    [self.letsDrinkLabel.layer removeAllAnimations];
    self.letsDrinkLabel.layer.transform = CATransform3DIdentity;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
        //[self.letsDrinkLabel setAlpha:1]; //first part of animation
        //[self.letsDrinkLabel setAlpha:0.8]; //first part of animation
        self.letsDrinkLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //[self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

#pragma mark - Mutable array getter methods

// Getter methods for mutable array properties.
- (NSMutableArray*)touches
{
    if (!_touches)
    {
        _touches = [[NSMutableArray alloc] init];
    }
    return _touches;
}

- (NSMutableArray*)touchImages
{
    if (!_touchImages)
    {
        _touchImages = [[NSMutableArray alloc] init];
    }
    return _touchImages;
}

- (NSMutableArray*)touchViews
{
    if (!_touchViews)
    {
        _touchViews = [[NSMutableArray alloc] init];
    }
    return _touchViews;
}

#pragma mark - Button events

- (IBAction)tapToStartButton:(UIButton*)sender
{
    self.drinkController.paused = NO;
    self.tapToPlay.alpha = 0;
    self.tapToPause.alpha = 1;
    self.settingsButton.alpha = 0;
    self.rulesButton.alpha = 0;
    [self startMatch];
}

- (IBAction)tapToPauseButton:(UIButton*)sender
{
    // Stops timer in case a game match is currently being played.
    [self.timer invalidate];
    self.timer = nil;
    
    [self.touches removeAllObjects];
    for (UIImageView *imageView in self.touchImages)
    {
        [imageView removeFromSuperview];
    }
    [self.touchImages removeAllObjects];
    
    for (UIView *touchView in self.touchViews)
    {
        [touchView removeFromSuperview];
    }
    [self.touchViews removeAllObjects];
    
    self.drinkController.paused = YES;
    self.drinkController.gameStarted = NO;
    self.tapToPlay.alpha = 1;
    self.tapToPause.alpha = 0;
    self.loserDrinksLabel.alpha = 0;
    self.settingsButton.alpha = 1;
    self.getReadyLabel.alpha = 0;
    self.rulesButton.alpha = 1;
    self.letsDrinkLabel.alpha = 1;
    
    [self.tapToPause setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (IBAction)settingsButtonTapped:(UIButton*)sender
{
    [self presentViewController:self.settingsController animated:YES completion:nil];
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)rulesButtonTapped:(UIButton *)sender
{
    [self presentViewController:self.rulesController animated:YES completion:nil];
}


#pragma mark - Touch events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    int numberOfPlayers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"];
    
    if ([self.touches count] < numberOfPlayers && !self.drinkController.paused && self.drinkController.gameStarted)
    {
        for (UITouch *touch in touches)
        {
            if (![self.touches containsObject:touch])
            {
                BOOL isLast = NO;
                [self.touches addObject:touch];
                
                //UIImageView *playerTouchImage = [[UIImageView alloc] initWithImage:self.drinkController.touchImage];
                if ([self.touches count] == numberOfPlayers)
                {
                    isLast = YES;
                    //playerTouchImage.image = [UIImage imageNamed:@"lastTouchImage.png"];
                }
                
                CGPoint location = [touch locationInView:self.view];
                CGRect imageFrame = CGRectMake(location.x, location.y, 75, 75);
                
                CFTimeInterval elapsedTime = CACurrentMediaTime() - self.startTime;
                
                TouchCircle *playerTouchCircle = [[TouchCircle alloc] initWithFrame:imageFrame withTime:elapsedTime isLast:isLast];
                playerTouchCircle.center = location;
                
                [self.view addSubview:playerTouchCircle];
                [self.view bringSubviewToFront:playerTouchCircle];
                
                playerTouchCircle.center = [touch locationInView:self.view];
                [self.touchViews addObject:playerTouchCircle];
                [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
                    [playerTouchCircle setAlpha:1]; //first part of animation
                    [playerTouchCircle setAlpha:0.7]; //second part of animation
                    playerTouchCircle.transform = CGAffineTransformMakeScale(0.8, 0.8);
                } completion:nil];
                /*
                [self.view addSubview:playerTouchImage];
                [self.view bringSubviewToFront:playerTouchImage];
                [self.touchImages addObject:playerTouchImage];
                playerTouchImage.center = [touch locationInView:self.view];
                 */
                if ([self.touches count] == numberOfPlayers)
                {
                    SystemSoundID gulps;
                    SystemSoundID burp;
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"gulps" ofType:@"mp3"];
                    NSURL *soundURL = [NSURL fileURLWithPath:path];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &gulps);
                    
                    path = [[NSBundle mainBundle] pathForResource:@"burp" ofType:@"mp3"];
                    soundURL = [NSURL fileURLWithPath:path];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &burp);
                    
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                    //AudioServicesPlaySystemSound(gulps);
                    AudioServicesPlaySystemSound(burp);
                    self.view.backgroundColor = [UIColor redColor];
                    
                    [self matchEnded];
                }
            }
        }
    }
    
    if (self.drinkController.paused)
    {
        SystemSoundID bell;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"mp3"];
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &bell);
        AudioServicesPlaySystemSound(bell);
        
        [self startMatch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    /*
    int numberOfPlayers = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"];
    
    if ([self.touches count] < numberOfPlayers && !self.drinkController.paused && self.drinkController.gameStarted)
    {
        for (UITouch *touch in touches)
        {
            for (UITouch *currentTouch in self.touches)
            {
                if (currentTouch == touch)
                {
                    UIImageView *currentImageView = self.touchImages[[self.touches indexOfObject:currentTouch]];
                    currentImageView.center = [currentTouch locationInView:self.view];
                }
            }
        }

    }*/
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // The following block of code is used for 5 players or less if players are required to hold finger
    // on screen since there is a maximum of 5 touches allowed on the iphone.
    /*
    if ([self.touches count] < [self.drinkController.numberOfPlayers intValue] && !self.drinkController.paused && self.drinkController.gameStarted)
    {
        for (UITouch *touch in touches)
        {
            for (UITouch *currentTouch in self.touches)
            {
                if (currentTouch == touch)
                {
                    NSUInteger index = [self.touches indexOfObject:currentTouch];
                    UIImageView *currentImageView = self.touchImages[index];
                    [self.touchImages removeObjectAtIndex:index];
                    [self.touches removeObjectAtIndex:index];
                    [currentImageView removeFromSuperview];
                    break;
                }
            }
        }
    }*/
}

- (void)startMatch
{
    self.drinkController.paused = NO;
    self.drinkController.gameStarted = NO;
    
    self.tapToPlay.alpha = 0;
    self.tapToPause.alpha = 1;
    self.loserDrinksLabel.alpha = 0;
    self.settingsButton.alpha = 0;
    self.getReadyLabel.alpha = 1;
    self.rulesButton.alpha = 0;
    self.letsDrinkLabel.alpha = 0;
    
    [self.touches removeAllObjects];
    for (UIImageView *imageView in self.touchImages)
    {
        [imageView removeFromSuperview];
    }
    [self.touchImages removeAllObjects];
    
    
    for (UIView *touchView in self.touchViews)
    {
        [touchView removeFromSuperview];
    }
    [self.touchViews removeAllObjects];
    
    [self.tapToPause setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSNumber *timeTilNextMatch = [self.drinkController getTimeTilNextMatch];
    NSLog(@"Timer about to fire!");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[timeTilNextMatch intValue] target:self selector:@selector(fireAfterTimer) userInfo:nil repeats:NO];
}

- (void)fireAfterTimer
{
    NSLog(@"Timer fired after %d seconds!", [self.drinkController.timeTilNextDrink intValue]);
    self.getReadyLabel.alpha = 0;
    self.tapToPause.alpha = 0;
    
    SystemSoundID pouringBeerID;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pouringBeer" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &pouringBeerID);
    
    AudioServicesPlaySystemSound(pouringBeerID);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tapToPause setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.drinkController.gameStarted = YES;
    
    self.startTime = CACurrentMediaTime();
    [self.timer invalidate];
    self.timer = nil;
}

#define READ_TIME 10.0

- (void)matchEnded
{
    NSNumber *drinkCount = [self.drinkController getLoserDrinkCount];
    self.loserDrinksLabel.text = [NSString stringWithFormat:@"Loser Drinks\n%u", [drinkCount intValue]];
    [self.view bringSubviewToFront:self.loserDrinksLabel];
    self.loserDrinksLabel.alpha = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:READ_TIME target:self selector:@selector(startMatch) userInfo:nil repeats:NO];
}

#pragma mark - iAd Delegate Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
