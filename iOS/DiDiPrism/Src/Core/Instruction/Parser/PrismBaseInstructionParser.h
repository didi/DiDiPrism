//
//  PrismBaseInstructionParser.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionFormatter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismInstructionParseResult) {
    PrismInstructionParseResultSuccess, //解析成功
    PrismInstructionParseResultFail, //解析失败，主要场景是页面还未加载完毕
    PrismInstructionParseResultError, //解析异常，如指令异常
};

@interface PrismBaseInstructionParser : NSObject
+ (instancetype)instructionParserWithFormatter:(PrismInstructionFormatter*)formatter;

@property (nonatomic, assign) BOOL didScroll; //是否发生了滚动，用于针对滚动效果做优化
@property (nonatomic, assign) BOOL needExecute; //是否真正触发。
@property (nonatomic, assign) BOOL isCompatibleMode; //是否是兼容模式

- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter*)formatter;
@end

NS_ASSUME_NONNULL_END
