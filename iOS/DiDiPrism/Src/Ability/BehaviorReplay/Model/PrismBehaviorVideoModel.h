//
//  PrismBehaviorVideoModel.h
//  DiDiPrism
//
//  Created by hulk on 2019/11/8.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorVideoModel : NSObject
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, strong) PrismInstructionFormatter *instructionFormatter;
@property (nonatomic, copy) NSString *descTime; //单步操作停留时长
@end

NS_ASSUME_NONNULL_END
