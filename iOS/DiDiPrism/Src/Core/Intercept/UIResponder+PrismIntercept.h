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
@property (nonatomic, copy) NSString *prismAutoDotSpecialMark; //支持为响应链节点自定义标识
@property (nonatomic, assign) BOOL prismAutoDotContentCollectOff; //元素内容采集开关，默认NO代表采集开启。（如涉及敏感/隐私内容的控件，可置为YES来关闭对目标控件的采集）
@end

NS_ASSUME_NONNULL_END
