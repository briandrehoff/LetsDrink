//
//  LetsDrinkModelController.h
//  Let's Drink
//
//  Created by Brian Drehoff on 3/6/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LetsDrinkModelController : NSObject

@property (strong, nonatomic) UIImage *touchImage;
@property (strong, nonatomic) NSNumber *timeTilNextDrink;

@property (nonatomic) BOOL paused;
@property (nonatomic) BOOL gameStarted;

- (NSNumber*)getTimeTilNextMatch;
- (NSNumber*)getLoserDrinkCount;

@end
