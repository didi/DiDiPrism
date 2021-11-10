//
//  PrismBehaviorModel.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/12.
//

#import "PrismBehaviorModel.h"
#import <DiDiPrism/PrismInstructionDefines.h>
#import <DiDiPrism/PrismInstructionFormatter.h>
#import "PrismBehaviorTranslater.h"

static NSDictionary *list_customKeyMapper = nil;
static NSDictionary *item_customKeyMapper = nil;
static NSDictionary *itemRequest_customKeyMapper = nil;

#pragma mark - PrismBehaviorListModel
@interface PrismBehaviorListModel ()
@property (nonatomic, copy) NSArray<PrismBehaviorVideoModel*> *instructionArray; //对instructions的封装
@property (nonatomic, copy) NSArray<PrismBehaviorTextModel *> *instructionTextArray; //对instructions的加工，转化为可读文本。

@property (nonatomic, copy) NSArray<NSString*> *startNodes; //可定制视频回放的开始节点
@property (nonatomic, copy) NSArray<NSString*> *endNodes; //可定制视频回放的结束节点
@end

@implementation PrismBehaviorListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self customKeyMapper]];
}

+ (void)setCustomKeyMapper:(NSDictionary *)customKeyMapper {
    list_customKeyMapper = customKeyMapper;
}
+ (NSDictionary *)customKeyMapper {
    return list_customKeyMapper;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.replayFailIndex = -1;
    }
    return self;
}

- (NSArray<PrismBehaviorVideoModel *> *)instructionArray {
    if (!_instructionArray) {
        NSMutableArray<PrismBehaviorVideoModel*> *videoModelMutaArray = [NSMutableArray array];
        NSMutableArray<NSString*> *instructionMutaArray = [NSMutableArray array];
        [self.instructions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PrismBehaviorItemModel *model = obj;
            PrismBehaviorVideoModel *videoModel = [[PrismBehaviorVideoModel alloc] init];
            videoModel.instruction = model.instruction;
            videoModel.instructionFormatter = model.instructionFormatter;
            if (idx < self.instructions.count - 1) {
                NSInteger nextIdx = idx + 1;
                NSString *nextInstruction = ((PrismBehaviorItemModel*)self.instructions[nextIdx]).instruction;
                //排除同时触发的指令，修正时间。
                if ([nextInstruction containsString:kUIViewControllerDidAppear]) {
                    nextIdx = nextIdx + 1;
                }
                if (nextIdx < self.instructions.count) {
                    NSTimeInterval thisTime = model.eventTime.integerValue;
                    NSTimeInterval nextTime = ((PrismBehaviorItemModel*)self.instructions[nextIdx]).eventTime.integerValue;
                    NSInteger minutes = (nextTime - thisTime) / 60;
                    NSInteger seconds = (NSInteger)(nextTime - thisTime) % 60;
                    videoModel.descTime = [NSString stringWithFormat:@"%ld′%ld″", (long)minutes, (long)seconds];
                }
            }
            [instructionMutaArray addObject:model.instruction];
            [videoModelMutaArray addObject:videoModel];
        }];
        _instructionArray = [videoModelMutaArray copy];
        
        // 裁剪
        if (self.startNodes.count) {
            self.startIndex = instructionMutaArray.count + 1;
            [self.startNodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                for (NSInteger index = 0; index < instructionMutaArray.count; index++) {
                    NSString *instruction = instructionMutaArray[index];
                    // 入口模糊匹配
                    PrismInstructionFormatter *instructionFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:obj];
                    NSString *vmContent = [instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewMotion];
                    NSString *vpContent = [instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewPath];
                    NSString *vrContent = [instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
                    BOOL containObjComponents = vmContent && [instruction containsString:vmContent] && vpContent && [instruction containsString:vpContent] && vrContent && [instruction containsString:vrContent];
                    if ([instruction isEqualToString:obj] || containObjComponents) {
                        self.canReplay = YES;
                        self.startIndex = index;
                        break;
                    }
                }
                if (self.canReplay) {
                    *stop = YES;
                }
            }];
        }
        else {
            self.startIndex = 0;
        }
        
        if (self.endNodes.count) {
            self.endIndex = instructionMutaArray.count + 1;
            [self.endNodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([instructionMutaArray containsObject:obj]) {
                    self.endIndex = MIN(self.endIndex, [instructionMutaArray indexOfObject:obj]);
                }
            }];
        }
        else {
            self.endIndex = instructionMutaArray.count - 1;
        }
    }
    return _instructionArray;
}

- (NSArray<PrismBehaviorTextModel *> *)instructionTextArray {
    if (!_instructionTextArray) {
        NSMutableArray<PrismBehaviorTextModel*> *instructionMutaArray = [NSMutableArray array];
        [self.instructionArray enumerateObjectsUsingBlock:^(PrismBehaviorVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PrismBehaviorTextModel *textModel = [PrismBehaviorTranslater translateWithModel:obj];
            [instructionMutaArray addObject:textModel];
        }];
        _instructionTextArray = [instructionMutaArray copy];
    }
    return _instructionTextArray;
}

#pragma mark - getter
- (NSArray<NSString *> *)startNodes {
    return _startNodes;
}

- (NSArray<NSString *> *)endNodes {
    return _endNodes;
}
@end


#pragma mark - PrismBehaviorItemModel
@interface PrismBehaviorItemModel ()

@end

@implementation PrismBehaviorItemModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self customKeyMapper]];
}

+ (void)setCustomKeyMapper:(NSDictionary *)customKeyMapper {
    item_customKeyMapper = customKeyMapper;
}
+ (NSDictionary *)customKeyMapper {
    return item_customKeyMapper;
}


- (PrismInstructionFormatter *)instructionFormatter {
    if (!_instructionFormatter) {
        _instructionFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:self.instruction];
    }
    return _instructionFormatter;
}
@end


#pragma mark - PrismBehaviorItemRequestInfoModel
@implementation PrismBehaviorItemRequestInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self customKeyMapper]];
}

+ (void)setCustomKeyMapper:(NSDictionary *)customKeyMapper {
    itemRequest_customKeyMapper = customKeyMapper;
}
+ (NSDictionary *)customKeyMapper {
    return itemRequest_customKeyMapper;
}

@end
