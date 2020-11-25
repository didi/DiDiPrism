//
//  PrismBehaviorTextModel.h
//  DiDiPrism
//
//  Created by hulk on 2019/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismBehaviorDescType) {
    PrismBehaviorDescTypeNone,
    PrismBehaviorDescTypeText,
    PrismBehaviorDescTypeNetworkImage,
    PrismBehaviorDescTypeLocalImage,
};

@interface PrismBehaviorTextModel : NSObject
@property (nonatomic, copy) NSString *operationName;
@property (nonatomic, assign) PrismBehaviorDescType descType;
@property (nonatomic, copy) NSString *descContent;
@property (nonatomic, copy) NSString *descTime;
@end

NS_ASSUME_NONNULL_END
