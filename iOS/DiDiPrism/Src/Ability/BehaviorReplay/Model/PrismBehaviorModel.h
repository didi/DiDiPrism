//
//  PrismBehaviorModel.h
//  DiDiPrism
//
//  Created by hulk on 2019/10/12.
//

#import "JSONModel.h"
#import "PrismBehaviorTextModel.h"
#import "PrismBehaviorVideoModel.h"
#import "PrismInstructionFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismBehaviorItemModel,PrismBehaviorItemRequestInfoModel;

#pragma mark - PrismBehaviorListModel
@interface PrismBehaviorListModel : JSONModel
@property (nonatomic, copy) NSString *xId;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSNumber *isCollect;
@property (nonatomic, copy) NSString *collectDesc;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *eventStartTime;
@property (nonatomic, copy) NSString *eventEndTime;
@property (nonatomic, copy) NSString *triggerInstruction;
@property (nonatomic, copy) NSString *triggerEventName;
@property (nonatomic, copy) NSArray<PrismBehaviorItemModel> *instructions;

/*
 非接口返回
 */
@property (nonatomic, copy, readonly) NSArray<PrismBehaviorVideoModel*> *instructionArray; //对instructions的加工
@property (nonatomic, copy, readonly) NSArray<PrismBehaviorTextModel *>* instructionTextArray; //对instructions的加工，转化为可读文本。
@property (nonatomic, assign) BOOL canReplay; //是否可视频回放
@property (nonatomic, assign) NSInteger startIndex; //视频回放起点的索引
@property (nonatomic, assign) NSInteger endIndex; //视频回放终点的索引
@property (nonatomic, assign) BOOL isReplayed; //是否点击过视频回放
@property (nonatomic, assign) BOOL isTextReplayed; //是否点击过文字回放
@property (nonatomic, assign) BOOL isLookRelationship; //是否点击过查看血缘
@property (nonatomic, assign) NSInteger replayFailIndex; //视频回放失败的节点索引（从startIndex开始）
@property (nonatomic, assign) BOOL isPreloaded; //是否预加载过
@end


#pragma mark - PrismBehaviorItemModel
@interface PrismBehaviorItemModel : JSONModel
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, copy) NSString *eventTime;
@property (nonatomic, copy) NSArray<PrismBehaviorItemRequestInfoModel> *requestInfo;

/*
 非接口返回
 */
@property (nonatomic, strong) PrismInstructionFormatter *instructionFormatter;
@end


#pragma mark - PrismBehaviorItemRequestInfoModel
@interface PrismBehaviorItemRequestInfoModel : JSONModel
@property (nonatomic, copy) NSString *originUrl;
/*
 1、支持通过网络请求的traceId获取数据源。
 */
@property (nonatomic, copy) NSString *mockUrl;
@property (nonatomic, copy) NSString *traceId;
/*
 2、也支持直接传入准备好的数据源。
 */
@property (nonatomic, copy) NSDictionary *result;
@end

NS_ASSUME_NONNULL_END
