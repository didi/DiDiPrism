//
//  PrismBaseInstructionParser+Protected.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismBaseInstructionParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBaseInstructionParser (Protected)
- (UIResponder*)searchRootResponderWithClassName:(NSString*)className;
- (UIView*)searchScrollViewCellWithScrollViewClassName:(NSString*)scrollViewClassName
                                         cellClassName:(NSString*)cellClassName
                                  cellSectionOrOriginX:(CGFloat)cellSectionOrOriginX
                                      cellRowOrOriginY:(CGFloat)cellRowOrOriginY
                                         fromSuperView:(UIView*)superView;
- (NSArray<UIResponder*>*)searchRespondersWithClassName:(NSString*)className superResponders:(NSArray<UIResponder*>*)superResponders;
- (void)scrollToIdealOffsetWithScrollView:(UIScrollView*)scrollView targetElement:(UIView*)targetElement;
- (BOOL)isAreaInfoEqualBetween:(NSString*)one withAnother:(NSString*)another allowCompatibleMode:(BOOL)allowCompatibleMode;
@end

NS_ASSUME_NONNULL_END
