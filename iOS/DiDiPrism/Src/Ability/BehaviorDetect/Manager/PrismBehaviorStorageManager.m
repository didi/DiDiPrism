//
//  PrismBehaviorStorageManager.m
//  DiDiPrism
//
//  Created by hulk on 2020/10/9.
//

#import "PrismBehaviorStorageManager.h"
#import <DiDiPrism/NSDate+PrismExtends.h>

@interface PrismBehaviorStorageManager()
@property (nonatomic, strong) NSMutableArray<NSDictionary*> *currentBehaviors;
@end

@implementation PrismBehaviorStorageManager
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PrismBehaviorStorageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PrismBehaviorStorageManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.workQueue = dispatch_queue_create("com.prism.behavior.detect", DISPATCH_QUEUE_SERIAL);
        [self addNotifications];
        [self clearFiles];
    }
    return self;
}

#pragma mark - public method
- (void)addInstruction:(NSString *)instruction withParams:(NSDictionary *)params {
    NSDictionary *dictionary = [self dictionaryWithInstruction:instruction withParams:params];
    [self.currentBehaviors addObject:dictionary];
    if (self.currentBehaviors.count >= 10) {
        [self saveToFile];
    }
}

- (NSArray<NSDictionary*>*)readFileOfDays:(NSInteger)days {
    NSDate *today = [[NSDate date] prism_beginningOfDay];
    NSMutableArray *allBehaviors = [NSMutableArray array];
    if (days > 0) {
        for (NSInteger index = days - 1; index >= 0; index--) {
            NSDate *date = [today prism_dateBySubtractingDays:index];
            NSString *filePath = [self fileNameWithTimeInterval:[date timeIntervalSince1970]];
            NSArray *historyBehaviors = [[NSMutableArray arrayWithContentsOfFile:filePath] copy];
            [allBehaviors addObjectsFromArray:historyBehaviors];
        }
    }
    return [allBehaviors copy];
}

#pragma mark - private method
- (void)clearFiles {
    dispatch_async(self.workQueue, ^{
        NSDate *today = [[NSDate date] prism_beginningOfDay];
        NSMutableArray *allFilePaths = [NSMutableArray array];
        for (NSInteger index = 0; index < PrismBehaviorDataMaxDay; index++) {
            NSDate *date = [today prism_dateBySubtractingDays:index];
            NSString *filePath = [self fileNameWithTimeInterval:[date timeIntervalSince1970]];
            [allFilePaths addObject:filePath];
        }
        NSString *prismFolderPath = [self prismFolderPath];
        NSDirectoryEnumerator *prismFolderEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:prismFolderPath];
        NSString *fileName = nil;
        while (fileName = [prismFolderEnumerator nextObject]) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self prismFolderPath], fileName];
            if (![allFilePaths containsObject:filePath]) {
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            }
        }
    });
}

- (void)saveToFile {
    if (!self.currentBehaviors.count) {
        return;
    }
    dispatch_async(self.workQueue, ^{
        NSString *filePath = [self fileNameWithTimeInterval:[[[NSDate date] prism_beginningOfDay] timeIntervalSince1970]];
        NSArray *historyBehaviors = [[NSMutableArray arrayWithContentsOfFile:filePath] copy];
        NSMutableArray *allBehaviors = [NSMutableArray arrayWithArray:historyBehaviors];
        [allBehaviors addObjectsFromArray:[self.currentBehaviors copy]];
        [self.currentBehaviors removeAllObjects];
        [allBehaviors writeToFile:filePath atomically:YES];
    });
}

- (NSDictionary*)dictionaryWithInstruction:(NSString*)instruction withParams:(NSDictionary*)params {
    if (!instruction.length) {
        return nil;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:instruction forKey:PrismBehaviorInstructionKey];
    if (params.allKeys.count) {
        [dictionary setValue:params forKey:PrismBehaviorParamsKey];
    }
    return [dictionary copy];
}

- (NSString*)fileNameWithTimeInterval:(NSTimeInterval)timeInterval {
    NSString *prismFolderPath = [self prismFolderPath];
    NSString *fileName = [prismFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"prism_behavior_%.0f.plist", timeInterval]];
    return fileName;
}

- (NSString*)prismFolderPath {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    NSString *folderPath = [cachePath stringByAppendingPathComponent:@"/prism_behavior/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath] == NO) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return folderPath;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - actions
- (void)willResignActive:(NSNotification*)notification {
    [self saveToFile];
}

#pragma mark - setters

#pragma mark - getters
- (NSMutableArray<NSDictionary *> *)currentBehaviors {
    if (!_currentBehaviors) {
        _currentBehaviors = [NSMutableArray array];
    }
    return _currentBehaviors;
}

@end
