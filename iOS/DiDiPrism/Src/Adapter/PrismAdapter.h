//
//  PrismAdapter.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/29.
//

#import "UIView+PrismDataVisualization.h"

#ifndef PrismAdapter_h
#define PrismAdapter_h

/*
 添加点击类型的埋点
 */
#define Prism_AddClickEventId(view, eventId) \
[view.relatedInfos addClickEventId:eventId];

#define Prism_AddClickEventIdAndParameters(view, eventId, parameters) \
[view.relatedInfos addClickEventId:eventId eventParameters:parameters];

/*
 添加曝光类型的埋点
 */
#define Prism_AddExposureEventId(view, eventId) \
[view.relatedInfos addExposureEventId:eventId];

#define Prism_AddExposureEventIdAndParameters(view, eventId, parameters) \
[view.relatedInfos addExposureEventId:eventId eventParameters:parameters];

/*
 移除埋点
 */
#define Prism_RemoveEventId(view, eventId) \
[view.relatedInfos removeEventId:eventId];

#define Prism_RemoveAllEventIds(view) \
[view.relatedInfos removeAllEventIds];


#endif /* PrismAdapter_h */
