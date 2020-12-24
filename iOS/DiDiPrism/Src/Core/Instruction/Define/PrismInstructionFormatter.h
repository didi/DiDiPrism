//
//  PrismInstructionFormatter.h
//  DiDiPrism
//
//  Created by hulk on 2020/4/18.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionDefines.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismInstructionFragmentType) {
    PrismInstructionFragmentTypeViewMotion, //触发类型
    PrismInstructionFragmentTypeViewPath, //响应链信息
    PrismInstructionFragmentTypeViewList, //列表信息
    PrismInstructionFragmentTypeViewQuadrant, //区位信息
    PrismInstructionFragmentTypeViewRepresentativeContent, //参考信息
    PrismInstructionFragmentTypeEvent, //通用事件
    PrismInstructionFragmentTypeViewFunction, //功能信息
    PrismInstructionFragmentTypeH5View, //H5指令
};

@interface PrismInstructionFormatter : NSObject
@property (nonatomic, copy, readonly) NSString *instruction;

- (instancetype)initWithInstruction:(NSString*)instruction;
- (NSArray<NSString*>*)instructionFragmentWithType:(PrismInstructionFragmentType)type;
- (NSString*)instructionFragmentContentWithType:(PrismInstructionFragmentType)type;

@end

NS_ASSUME_NONNULL_END
