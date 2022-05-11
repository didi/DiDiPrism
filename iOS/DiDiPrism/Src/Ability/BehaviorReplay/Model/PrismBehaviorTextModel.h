//
//  PrismBehaviorTextModel.h
//  DiDiPrism
//
//  Created by hulk on 2019/11/7.
//

#import <Foundation/Foundation.h>
#import <DiDiPrism/PrismInstructionAreaInfoUtil.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismBehaviorDescType) {
    PrismBehaviorDescTypeNone,
    PrismBehaviorDescTypeText,
    PrismBehaviorDescTypeNetworkImage,
    PrismBehaviorDescTypeLocalImage,
    PrismBehaviorDescTypeCode,
};

@interface PrismBehaviorTextModel : NSObject
@property (nonatomic, copy) NSString *operationName; //操作文案
@property (nonatomic, assign) PrismInstructionArea areaInfo; //区位信息
@property (nonatomic, copy) NSString *areaText; //区位信息文案
@property (nonatomic, copy) NSString *moduleText; //模块名称
@property (nonatomic, copy) NSString *elementName; //操作元素类型名称
@property (nonatomic, assign) PrismBehaviorDescType descType; //操作内容呈现类型
@property (nonatomic, copy) NSString *descContent; //操作内容
@property (nonatomic, copy) NSString *descTime; //间隔时长
@end

NS_ASSUME_NONNULL_END
