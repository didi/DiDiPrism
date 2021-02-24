//
//  PrismDataHeatMapView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataHeatMapView.h"
// Category
#import "UIColor+PrismExtends.h"

@interface PrismDataHeatMapView()

@end

@implementation PrismDataHeatMapView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - override method
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray<UIColor*> *allColor = @[[UIColor prism_colorWithHex:0x340019 andAlpha:0.9],
                                  [UIColor prism_colorWithHex:0x780008 andAlpha:0.8],
                                  [UIColor prism_colorWithHex:0xEE000F andAlpha:0.8],
                                  [UIColor prism_colorWithHex:0xFF4B00 andAlpha:0.8],
                                  [UIColor prism_colorWithHex:0xFFAD0B andAlpha:0.8],
                                  [UIColor prism_colorWithHex:0xFFED20 andAlpha:0.8]];
    NSInteger value = (NSInteger)(self.value / self.standardValue * 4);
    value = value > 5 ? 5 : value;
    value = value < 0 ? 0 : value;
    UIColor *startColor = allColor[5 - value];
    UIColor *endColor = startColor;
    CGRect elementFrame = self.bounds;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:(id)startColor.CGColor,(id)endColor.CGColor,nil];
    const CGFloat locations[2] = {0.0,1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
    CGFloat elementOrignX = elementFrame.origin.x;
    CGFloat elementOrignY = elementFrame.origin.y;
    CGFloat elementWidth = elementFrame.size.width;
    CGFloat elementHeight = elementFrame.size.height;
    CGPoint centerPoint = CGPointMake(elementOrignX + elementWidth/2, elementOrignY + elementHeight/2);
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = elementWidth > elementHeight ? elementWidth : elementHeight;
    
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    
    CGContextAddRect(context, elementFrame);
    CGContextClip(context);
    
    CGContextDrawRadialGradient(context, gradient, centerPoint, startRadius, centerPoint, endRadius, kCGGradientDrawsAfterEndLocation);

    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

#pragma mark - setters
- (void)setValue:(NSInteger)value {
    _value = value;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

#pragma mark - getters

@end
