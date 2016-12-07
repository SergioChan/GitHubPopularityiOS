//
//  SCStarGraphView.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCStarGraphView.h"
#import "SCStar.h"

@implementation SCStarGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layerWillDraw:(CALayer *)layer {
    [super layerWillDraw:layer];
    layer.contentsFormat = kCAContentsFormatRGBA8Uint;
}

- (void)refreshFromStars:(NSMutableArray *)array
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        [[UIColor clearColor] setFill];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        int frameWidth = self.frame.size.width;
        int width = (int)(frameWidth / 12 - 1);
        for (int weekFromNow = 0; weekFromNow < width; weekFromNow ++)
        {
            NSMutableArray *week = [array objectAtIndex:weekFromNow];
            for (SCStar *day in week)
            {
                CGRect rect = CGRectMake(self.frame.size.width - weekFromNow * 12 - 24, day.weekDay.intValue * 12 - 6, 10, 10);
                [day.color setFill];
                CGContextFillRect(context,rect);
            }
            
            
            SCStar *firstDayOfWeek = [week firstObject];
            NSString* monthName = [self monthName:[firstDayOfWeek.month intValue]];
            // Setup the font specific variables
            NSDictionary *attributes = @{
                                         NSFontAttributeName   : [UIFont fontWithName:@"Helvetica" size:8],
                                         NSStrokeWidthAttributeName    : @(0),
                                         NSForegroundColorAttributeName    : [UIColor whiteColor]
                                         };
            // Draw text with CGPoint and attributes
            [monthName drawAtPoint:CGPointMake(self.frame.size.width - weekFromNow * 12 - 24 + 1,8 * 12 - 6) withAttributes:attributes];
        }
        
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.image = im;
    }
}

- (NSString *)monthName:(int)month
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"J",@"F",@"M",@"A",@"M",@"J",@"J",@"A",@"S",@"O",@"N",@"D", nil];
    return [array objectAtIndex:month - 1];
}

@end
