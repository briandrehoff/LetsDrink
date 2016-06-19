//
//  LetsDrinkModelController.m
//  Let's Drink
//
//  Created by Brian Drehoff on 3/6/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import "LetsDrinkModelController.h"

@interface LetsDrinkModelController()

@end

@implementation LetsDrinkModelController

- (id)init {
    self = [super init];
    if (self) {
        // Create the data model.
        self.touchImage = [UIImage imageNamed:@"touchImage.png"];
        if (![[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"touchImage.png" forKey:@"touchImage"];
            [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"numberOfPlayers"];
            [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"minWait"];
            [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"maxWait"];
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"minDrink"];
            [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"maxDrink"];
        }
        
        self.paused = YES;
        self.gameStarted = NO;
    }
    return self;
}

- (NSNumber*)getTimeTilNextMatch
{
    int minWait = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"minWait"];
    int maxWait = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxWait"];
    
    if (minWait < 6)
    {
        minWait = minWait*10;
    }
    else
    {
        minWait = (minWait-5)*60;
    }
    if (maxWait < 6)
    {
        maxWait = maxWait*10;
    }
    else
    {
        maxWait = (maxWait-5)*60;
    }
    
    NSNumber *waitTime = [NSNumber numberWithInt:arc4random_uniform(maxWait-minWait+1)];
    NSNumber *randomWaitTime = [NSNumber numberWithInt:([waitTime intValue] + minWait)];
    NSLog(@"Wait time: %i", [randomWaitTime intValue]);
    self.timeTilNextDrink = randomWaitTime;
    return randomWaitTime;
}

- (NSNumber *)getLoserDrinkCount
{
    int maxDrink = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxDrink"];
    int minDrink = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"minDrink"];
    NSNumber *drinkTime = [NSNumber numberWithInt:arc4random_uniform(maxDrink-minDrink+1)];
    NSNumber *randomDrinkTime = [NSNumber numberWithInt:([drinkTime intValue] + minDrink)];
    NSLog(@"Drink time: %i", [randomDrinkTime intValue]);
    return randomDrinkTime;
}

@end
