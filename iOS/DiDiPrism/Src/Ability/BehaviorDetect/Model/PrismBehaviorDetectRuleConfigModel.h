//
//  PrismBehaviorDetectRuleConfigModel.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/29.
//

#import <JSONModel/JSONModel.h>
#import <DiDiPrism/PrismInstructionFormatter.h>

NS_ASSUME_NONNULL_BEGIN

/*
 根据JSON结构由内向外依次定义Model
 */

@protocol PrismBehaviorDetectRuleModel,PrismBehaviorDetectRuleInstructionModel;

#pragma mark - PrismBehaviorDetectRuleFragmentModel
@interface PrismBehaviorDetectRuleFragmentModel : JSONModel
@property (nonatomic, copy) NSArray<NSString*> *value; //数组元素之间是且关系
@property (nonatomic, copy) NSString *operatorString; // =:等于 %:包含

- (BOOL)isEqualWithInstructionFragment:(NSString*)instructionFragment;
@end

#pragma mark - PrismBehaviorDetectRuleInstructionModel
@interface PrismBehaviorDetectRuleInstructionModel : JSONModel
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vm;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vp;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vl;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vq;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vr;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *vf;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *e;
@property (nonatomic, copy) PrismBehaviorDetectRuleFragmentModel *h5;

- (BOOL)isEqualWithInstructionFormatter:(PrismInstructionFormatter*)instructionFormatter;
@end


#pragma mark - PrismBehaviorDetectRuleExpressionModel
@interface PrismBehaviorDetectRuleExpressionModel : JSONModel
@property (nonatomic, copy) NSArray<PrismBehaviorDetectRuleInstructionModel> *instruction; //数组元素之间是或关系
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *type; // same_person_number:点击次数 same_item_number:任一item的点击次数 same_person_date:访问天数  same_item_date:任一item的访问天数  same_person_category:访问种类数
@property (nonatomic, copy) NSString *operatorString; // gte:大于等于
@property (nonatomic, copy) NSArray *typeValue; // 默认有一个元素，为扩展预留。
@property (nonatomic, strong) NSNumber *basePoint; // 是否是基准，0:不是 1:是， 注：一套rule中最多只有一个basePoint
@property (nonatomic, strong) NSNumber *consultBasePoint;  // 是否参考基准，0:不参考 1:参考， 注：与basePoint互斥
/*
 非接口返回
 */
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*> *currentValues; //统计不同item的点击次数
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSMutableArray*> *currentDays; //统计不同item的访问天数

- (PrismBehaviorDetectRuleExpressionModel*)searchBasePointModel;
- (BOOL)isEstablishedWithBasePointResultKey:(NSString *)basePointResultKey;
- (NSString *)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter
                            withParams:(NSDictionary *)params
                      withBasePointKey:(NSString *)basePointKey;
- (void)reset;
@end


#pragma mark - PrismBehaviorDetectRuleRelationModel
@interface PrismBehaviorDetectRuleRelationModel : JSONModel
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSArray *rules;

- (PrismBehaviorDetectRuleExpressionModel*)searchBasePointModel;
- (BOOL)isEstablishedWithBasePointResultKey:(NSString*)basePointResultKey;
- (NSString *)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter
                            withParams:(NSDictionary *)params
                      withBasePointKey:(NSString *)basePointKey;
- (void)reset;
@end


#pragma mark - PrismBehaviorDetectRuleModel
@interface PrismBehaviorDetectRuleModel : JSONModel
@property (nonatomic, strong) NSNumber *ruleId;
@property (nonatomic, strong) NSNumber *cityId;
@property (nonatomic, strong) NSNumber *period; // 周期天数 0:本次访问 1:当天 2:今天和昨天 依次类推。
@property (nonatomic, strong) NSNumber *effectiveTime; // 线索生效时间 秒级时间戳
@property (nonatomic, strong) NSNumber *cycleTrigger; // 是否循环触发 0:不循环 1:循环
@property (nonatomic, strong) NSNumber *containHistory; // 0:不包含 1:包含
@property (nonatomic, strong) NSNumber *triggerMoment; // 0:满足条件时触发 1:满足条件后，访问基准商品时触发
@property (nonatomic, strong) NSNumber *triggerDelay; // 触发延时，单位秒
@property (nonatomic, strong) PrismBehaviorDetectRuleRelationModel *ruleContent;
/*
非接口返回
*/
@property (nonatomic, copy) NSString *lastBasePointKey; //最近一次匹配到的基准点key
@property (nonatomic, strong) NSMutableArray<NSString*> *basePointResultKeys; //最终符合条件的基准点key
@property (nonatomic, assign) BOOL isLastInstructionEffective; //最近一次触发的操作是否命中基准点

- (BOOL)isEstablishedWithCityId:(NSNumber *)cityId;
- (void)feedInstructionFormatter:(PrismInstructionFormatter*)instructionFormatter withParams:(NSDictionary*)params;
- (void)reset;
@end


#pragma mark - PrismBehaviorDetectRuleConfigModel
@interface PrismBehaviorDetectRuleConfigModel : JSONModel
@property (nonatomic, copy) NSArray<PrismBehaviorDetectRuleModel> *rules;

/*
 初始化，如加载历史数据
 */
- (void)setupWithLoader:(NSArray<NSDictionary*>*(^)(NSInteger))loader;
/*
 检查是否有规则满足。
 @return 所有命中的rule
 */
- (NSArray<PrismBehaviorDetectRuleModel*>*)detectRuleWithCityId:(NSNumber*)cityId;

/*
 输入操作行为指令
 */
- (void)feedInstructionFormatter:(PrismInstructionFormatter*)instructionFormatter withParams:(NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
