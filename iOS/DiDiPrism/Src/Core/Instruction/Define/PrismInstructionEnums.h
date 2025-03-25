//
//  PrismInstructionEnums.h
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#ifndef PrismInstructionEnums_h
#define PrismInstructionEnums_h

typedef NS_ENUM(NSUInteger, PrismInstructionMode) {
    PrismInstructionModeInclusive,  //包容模式（默认）
    PrismInstructionModeStrict,  //严格模式
};

typedef NS_ENUM(NSUInteger, PrismInstructionFragmentType) {
    PrismInstructionFragmentTypeViewMotion, //触发类型
    PrismInstructionFragmentTypeViewPath, //响应链信息
    PrismInstructionFragmentTypeViewList, //列表信息
    PrismInstructionFragmentTypeViewQuadrant, //区位信息
    PrismInstructionFragmentTypeViewRepresentativeContent, //参考信息
    PrismInstructionFragmentTypeEvent, //通用事件
    PrismInstructionFragmentTypeViewFunction, //功能信息
    PrismInstructionFragmentTypeH5View, //H5指令
    PrismInstructionFragmentTypeViewTree, //页面详细层级信息（仅在严格模式下产生）
};

#endif /* PrismInstructionEnums_h */
