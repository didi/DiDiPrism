//
//  PrismInstructionFormatter.h
//  DiDiPrism
//
//  Created by hulk on 2020/4/18.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionDefines.h"
#import "PrismInstructionEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismInstructionFormatter : NSObject
@property (nonatomic, copy, readonly) NSString *instruction;

- (instancetype)initWithInstruction:(NSString*)instruction;
/*
 getter
 */
- (NSArray<NSString*>*)instructionFragmentWithType:(PrismInstructionFragmentType)type;
- (NSString*)instructionFragmentContentWithType:(PrismInstructionFragmentType)type;

@end

NS_ASSUME_NONNULL_END
