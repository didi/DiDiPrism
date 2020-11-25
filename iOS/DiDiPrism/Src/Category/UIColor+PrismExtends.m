//
//  UIColor+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/10/23.
//

#import "UIColor+PrismExtends.h"

@implementation UIColor (PrismExtends)
CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];

    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

#pragma mark - public method
+ (UIColor *)prism_colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;

    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue = colorComponentFrom(colorString, 2, 1);
            break;

        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue = colorComponentFrom(colorString, 3, 1);
            break;

        case 6: // #RRGGBB
            alpha = 1.0f;
            red = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue = colorComponentFrom(colorString, 4, 2);
            break;

        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue = colorComponentFrom(colorString, 6, 2);
            break;

        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
