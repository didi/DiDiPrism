//
//  PrismElementRelatedInfo.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface PrismElementRelatedInfo : NSObject <NSCopying>

@property (nonatomic, copy) NSString *eventID;
/*
 埋点属性
 注：此字段适用于一个event id绑定在多个元素上的场景，此时是通过埋点属性来区分不同元素的。
    因此在这种场景下，可以把用来区分不同元素的埋点属性存入其中，便于我们区分元素。
 */
@property (nonatomic, copy) NSDictionary *eventParameters;
//@property (nonatomic, strong) NSNumber *itemIndex; //列表中的元素通用位置索引
//@property (nonatomic, copy) NSString *itemName; //列表中元素通用ID
@end

@interface PrismElementRelatedInfos : NSObject <NSCopying>
/*
 添加点击类型的埋点
 */
- (void)addClickRelatedInfo:(PrismElementRelatedInfo*)relatedInfo;
- (void)addClickEventId:(NSString*)eventId;
- (void)addClickEventId:(NSString*)eventId eventParameters:(NSDictionary*)eventParameters;

/*
 添加曝光类型的埋点
 */
- (void)addExposureRelatedInfo:(PrismElementRelatedInfo*)exposureRelatedInfo;
- (void)addExposureEventId:(NSString*)eventId;
- (void)addExposureEventId:(NSString*)eventId eventParameters:(NSDictionary*)eventParameters;

/*
 移除埋点
 */
- (void)removeEventId:(NSString*)eventId;
- (void)removeAllEventIds;

/*
 获取
 */
- (NSInteger)count;
- (NSString*)clickTypeEventId;
- (NSString*)exposureTypeEventId;
- (NSDictionary*)eventParametersOfEventId:(NSString*)eventId;

@end

NS_ASSUME_NONNULL_END
