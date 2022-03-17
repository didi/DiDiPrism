//
//  PrismBaseInstructionParser.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBaseInstructionParser : NSObject
+ (instancetype)instructionParserWithFormatter:(PrismInstructionFormatter*)formatter;

@property (nonatomic, assign) BOOL didScroll; //是否发生了滚动，用于针对滚动效果做优化
@property (nonatomic, assign) BOOL isCompatibleMode; //是否是兼容模式

- (NSObject*)parseWithFormatter:(PrismInstructionFormatter*)formatter;
@end

NS_ASSUME_NONNULL_END
