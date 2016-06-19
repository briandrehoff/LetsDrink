//
//  TouchCircle.m
//  Let's Drink
//
//  Created by Brian Drehoff on 3/24/14.
//  Copyright (c) 2014 DreamFi. All rights reserved.
//

#import "TouchCircle.h"

@interface TouchCircle()
@property (nonatomic) float timeElapsed;
@property (nonatomic) BOOL isLast;
@end
@implementation TouchCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self makeShadow];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTime:(float)time isLast:(BOOL)isLast
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self makeShadow];
        self.timeElapsed = time;
        self.isLast = isLast;
    }
    return self;
}

# pragma mark - Drawing

#define SCALE_FACTOR 0.5
#define OFFSET 1.0
- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // Drawing code
    // Draw a circle (filled)
    
    if (self.isLast)
    {
        CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.9);
    }
    else
    {
        CGContextSetRGBFillColor(contextRef, 0, 255, 0, 0.9);
    }
    CGContextFillEllipseInRect(contextRef, rect);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *infoFont = [UIFont systemFontOfSize:self.bounds.size.width * SCALE_FACTOR];
    
    NSAttributedString *time = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%f", self.timeElapsed] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : infoFont, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    CGRect textBounds;
    textBounds.origin = CGPointMake(self.bounds.origin.x, self.bounds.size.height/2-time.size.height/2);
    textBounds.size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    [time drawInRect:textBounds];
}

- (void)makeShadow
{
    // border radius
    //[self.layer setCornerRadius:CORNER_RADIUS];
    
    // border
    //[self.layer setBorderColor:[UIColor blackColor].CGColor];
    //[self.layer setBorderWidth:1.0f];
    
    // drop shadow
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.7];
    [self.layer setShadowRadius:4.0];
    [self.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
}


@end
