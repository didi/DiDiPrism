//
//  PrismElementRelatedInfo.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/29.
//

#import "PrismElementRelatedInfo.h"

@implementation PrismElementRelatedInfo
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[PrismElementRelatedInfo class]]) {
        return NO;
    }
    PrismElementRelatedInfo *objectInfo = (PrismElementRelatedInfo*)object;
    BOOL isIDEqual = [self.eventID isEqualToString:objectInfo.eventID];
    BOOL isParamEqual = YES;
    if (self.eventParameters.allKeys.count) {
        for (NSString *key in self.eventParameters.allKeys) {
            if (![self.eventParameters[key] isKindOfClass:[objectInfo.eventParameters[key] class]]
                && ![objectInfo.eventParameters[key] isKindOfClass:[self.eventParameters[key] class]]) {
                isParamEqual = NO;
                break;
            }
            if ([self.eventParameters[key] isKindOfClass:[NSString class]]
                && ![self.eventParameters[key] isEqualToString:objectInfo.eventParameters[key]]) {
                isParamEqual = NO;
                break;
            }
            else if ([self.eventParameters[key] isKindOfClass:[NSNumber class]]
                     && ![self.eventParameters[key] isEqualToNumber:objectInfo.eventParameters[key]]) {
                isParamEqual = NO;
                break;
            }
            else if (![self.eventParameters[key] isEqual:objectInfo.eventParameters[key]]) {
                isParamEqual = NO;
                break;
            }
        }
    }
    return isIDEqual && isParamEqual;
}

- (NSUInteger)hash {
    return [self.eventID hash] ^ [self.eventParameters hash];
}

- (id)copyWithZone:(NSZone *)zone {
    PrismElementRelatedInfo *newEventInfo = [[PrismElementRelatedInfo alloc] init];
    newEventInfo.eventID = self.eventID;
    newEventInfo.eventParameters = self.eventParameters;
    return newEventInfo;
}
@end



@interface PrismElementRelatedInfos()
@property (nonatomic, strong) NSMutableArray<PrismElementRelatedInfo*> *relatedInfos;
@property (nonatomic, strong) PrismElementRelatedInfo *clickRelatedInfo;
@property (nonatomic, strong) PrismElementRelatedInfo *exposureRelatedInfo;
@end

@implementation PrismElementRelatedInfos

#pragma mark - override method
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[PrismElementRelatedInfos class]]) {
        return NO;
    }
    PrismElementRelatedInfos *objectInfos = object;
    BOOL isEqual = [[self.relatedInfos copy] isEqualToArray:[objectInfos.relatedInfos copy]];
    return isEqual;
}

- (NSUInteger)hash {
    NSUInteger value = [self.relatedInfos hash];
    return value;
}

- (NSString *)description {
    if (!self.relatedInfos.count) {
        return nil;
    }
    NSMutableString *description = [NSMutableString string];
    for (PrismElementRelatedInfo *info in self.relatedInfos) {
        [description appendString:[NSString stringWithFormat:@" %@", info.eventID]];
    }
    return [description copy];
}

- (id)copyWithZone:(NSZone *)zone {
    PrismElementRelatedInfos *newInfos = [[PrismElementRelatedInfos alloc] init];
    newInfos.relatedInfos = [self.relatedInfos mutableCopy];
    newInfos.clickRelatedInfo = [self.clickRelatedInfo copy];
    newInfos.exposureRelatedInfo = [self.exposureRelatedInfo copy];
    return newInfos;
}

#pragma mark - public method
- (void)addClickRelatedInfo:(PrismElementRelatedInfo *)relatedInfo {
    if (!relatedInfo) {
        return;
    }
    self.clickRelatedInfo = relatedInfo;
    [self addEventInfo:relatedInfo];
}

- (void)addClickEventId:(NSString *)eventId {
    if (!eventId) {
        return;
    }
    PrismElementRelatedInfo *eventInfo = [[PrismElementRelatedInfo alloc] init];
    eventInfo.eventID = eventId;
    [self addClickRelatedInfo:eventInfo];
}

- (void)addClickEventId:(NSString *)eventId eventParameters:(NSDictionary *)eventParameters {
    if (!eventId) {
        return;
    }
    PrismElementRelatedInfo *eventInfo = [[PrismElementRelatedInfo alloc] init];
    eventInfo.eventID = eventId;
    eventInfo.eventParameters = eventParameters;
    [self addClickRelatedInfo:eventInfo];
}

- (void)addExposureRelatedInfo:(PrismElementRelatedInfo *)exposureRelatedInfo {
    if (!exposureRelatedInfo) {
        return;
    }
    self.exposureRelatedInfo = exposureRelatedInfo;
    [self addEventInfo:exposureRelatedInfo];
}

- (void)addExposureEventId:(NSString *)eventId {
    if (!eventId) {
        return;
    }
    PrismElementRelatedInfo *eventInfo = [[PrismElementRelatedInfo alloc] init];
    eventInfo.eventID = eventId;
    [self addExposureRelatedInfo:eventInfo];
    
}

- (void)addExposureEventId:(NSString *)eventId eventParameters:(NSDictionary *)eventParameters {
    if (!eventId) {
        return;
    }
    PrismElementRelatedInfo *eventInfo = [[PrismElementRelatedInfo alloc] init];
    eventInfo.eventID = eventId;
    eventInfo.eventParameters = eventParameters;
    [self addExposureRelatedInfo:eventInfo];
}

- (void)addEventInfo:(PrismElementRelatedInfo *)eventInfo {
    if (!eventInfo || [self isExistOfEventInfo:eventInfo]) {
        return;
    }
    [self.relatedInfos addObject:eventInfo];
}

- (void)removeEventId:(NSString *)eventId {
    PrismElementRelatedInfo *itemNeedRemove = nil;
    for (PrismElementRelatedInfo *eventInfo in self.relatedInfos) {
        if ([eventInfo.eventID isEqualToString:eventId]) {
            itemNeedRemove = eventInfo;
            break;
        }
    }
    [self.relatedInfos removeObject:itemNeedRemove];
    if (itemNeedRemove == self.clickRelatedInfo) {
        self.clickRelatedInfo = nil;
    }
    if (itemNeedRemove == self.exposureRelatedInfo) {
        self.exposureRelatedInfo = nil;
    }
}

-(void)removeAllEventIds {
    [self.relatedInfos removeAllObjects];
    self.clickRelatedInfo = nil;
    self.exposureRelatedInfo = nil;
}

- (NSInteger)count {
    return self.relatedInfos.count;
}

- (NSString *)clickTypeEventId {
    if (self.clickRelatedInfo) {
        return self.clickRelatedInfo.eventID;
    }
    return nil;
}

- (NSString *)exposureTypeEventId {
    if (self.exposureRelatedInfo) {
        return self.exposureRelatedInfo.eventID;
    }
    return nil;
}

- (NSDictionary *)eventParametersOfEventId:(NSString *)eventId {
    for (PrismElementRelatedInfo *info in self.relatedInfos) {
        if ([info.eventID isEqualToString:eventId]) {
            return info.eventParameters;
        }
    }
    return nil;
}

#pragma mark - private method
- (BOOL)isExistOfEventInfo:(PrismElementRelatedInfo*)eventInfo {
    for (PrismElementRelatedInfo *info in self.relatedInfos) {
        if ([info isEqual:eventInfo]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - getter
- (NSMutableArray<PrismElementRelatedInfo *> *)relatedInfos {
    if (!_relatedInfos) {
        _relatedInfos = [NSMutableArray array];
    }
    return _relatedInfos;
}
@end

