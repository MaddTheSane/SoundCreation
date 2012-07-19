//
//  BSAlert.m
//  alert
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import "BSAlert.h"

@implementation BSAlert

+ (void)alert {
    [[[BSAlert alloc] initWithTitle:@"This is custom alert" message:@"Cool huh?" delegate:nil cancelButtonTitle:@"cool" otherButtonTitles:nil, nil] show];
}

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        
        // Hide default alert view
        if ([view isMemberOfClass:[UIImageView class]]) { 
            view.hidden = YES;
        }
        
        // Change labels
        if ([view isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(1.0f, 1.0f);
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#define kRadius      10.0
#define kEdge_Inset  5.5
    
    CGRect alertRect = CGRectMake(kEdge_Inset,
                                  kEdge_Inset,
                                  self.bounds.size.width  - (kEdge_Inset * 2.0),
                                  self.bounds.size.height - (kEdge_Inset * 2.0));
    
    // Add path to context
    CGPathRef alertPath = [UIBezierPath bezierPathWithRoundedRect:alertRect cornerRadius:kRadius].CGPath;
    CGContextAddPath(context, alertPath);
    
    // Set alert color and shadow
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, [UIColor blackColor].CGColor);
    
    // Draw!
    CGContextDrawPath(context, kCGPathFill);
    
//    TODO: Learn about this
    // Don't know what this does
    CGContextSaveGState(context); 
    CGContextAddPath(context, alertPath);
    CGContextClip(context);
    
    // Setup a new color space for the GRADIENT
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    size_t count = 3;
    CGFloat locations[3] = { 0.0, 0.5, 1.0 }; // 0 = top; 1 = bottom
    CGFloat components[12] = 
    {
        70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f,
        55.0f/255.0f, 55.0f/255.0f, 55.0f/255.0f, 1.0f,
        40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    CGPoint gradientStart  = CGPointMake(self.bounds.size.width * 0.5, 0.0);
    CGPoint gradientEnd    = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
    CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, 0);
    
    // Do we need to release these with ARC?
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
#define kHatch_Offset 77.5
    
    // Save context state
    CGContextSaveGState(context);
    
    // Create frame for hatches
    CGRect hatchFrame = CGRectMake(0.0, kHatch_Offset, self.bounds.size.width, (self.bounds.size.height - kHatch_Offset));
    
    CGContextClipToRect(context, hatchFrame);
    
    CGFloat hatchSpace = 4.0;
    int rows = (self.bounds.size.width + (self.bounds.size.height / hatchSpace));
    CGFloat padding = 0.0;
    CGMutablePathRef hatchPath = CGPathCreateMutable();
    for(int i = 1; i <= rows; i++) {
        CGPathMoveToPoint(hatchPath, NULL, hatchSpace * i, padding);
        CGPathAddLineToPoint(hatchPath, NULL, padding, hatchSpace * i);
    }
    CGContextAddPath(context, hatchPath);
    CGPathRelease(hatchPath);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.15f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
    
    // Separating line
    CGMutablePathRef linePath = CGPathCreateMutable(); 
    CGFloat linePathY = (kHatch_Offset - 1.0f);
    CGPathMoveToPoint(linePath, NULL, 0.0f, linePathY);
    CGPathAddLineToPoint(linePath, NULL, self.bounds.size.width, linePathY);
    CGContextAddPath(context, linePath);
    CGPathRelease(linePath);
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSaveGState(context);
    
    // Line shadow
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f,
                                [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
    
    // Alert border
    CGContextAddPath(context, alertPath);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:0.7f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, [UIColor blackColor].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
//    // Redraw path to avoid pixelation
//    CGContextRestoreGState(context);
//    CGContextAddPath(context, alertPath);
//    CGContextSetLineWidth(context, 3.0f);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:0.7f].CGColor);
//    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f),0.0f,[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f].CGColor);
}

@end