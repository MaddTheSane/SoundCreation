#import "UIColor+BSColors.h"

@implementation UIColor (BSColors)

+ (UIColor *)offWhiteColorWithAlpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithRed:(249.0 / 255.0) green:(246.0 / 255.0) blue:(228.0 / 255.0) alpha:alpha];
}

+ (UIColor *)niceGreenColorWithAlpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithRed:(42.0 / 255.0) green:(194.0 / 255.0) blue:(10.0 / 255.0) alpha:alpha];
}

+ (UIColor *)niceRedColorWithAlpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithRed:(232.0 / 255.0) green:(12.0 / 255.0) blue:(31.0 / 255.0) alpha:alpha];
}
@end