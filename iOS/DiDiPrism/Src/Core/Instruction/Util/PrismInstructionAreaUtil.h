//
//  PrismInstructionAreaUtil.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismInstructionArea) {
    PrismInstructionAreaUnknown = 0,
    PrismInstructionAreaCenter = 1,
    PrismInstructionAreaUp = 2,
    PrismInstructionAreaBottom = 3,
    PrismInstructionAreaLeft = 4,
    PrismInstructionAreaRight = 5,
    PrismInstructionAreaUpLeft = 8,
    PrismInstructionAreaUpRight = 10,
    PrismInstructionAreaBottomLeft = 12,
    PrismInstructionAreaBottomRight = 15,
    PrismInstructionAreaCanScroll = 100,
};

@interface PrismInstructionAreaUtil : NSObject

+ (NSString*)getAreaInfoWithElement:(UIView *)element;
+ (NSInteger)getIndexOf:(UIView*)element fromScrollView:(UIScrollView*)scrollView;
@end

NS_ASSUME_NONNULL_END
