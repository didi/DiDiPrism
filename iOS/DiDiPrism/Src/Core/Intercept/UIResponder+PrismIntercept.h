//
//  UIResponder+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (PrismIntercept)
@property (nonatomic, copy) NSString *prismAutoDotItemName; //辅助参数，用来存储通用ID
@property (nonatomic, copy) NSString *prismAutoDotSpecialMark; //支持为节点自定义标识
@end

NS_ASSUME_NONNULL_END
