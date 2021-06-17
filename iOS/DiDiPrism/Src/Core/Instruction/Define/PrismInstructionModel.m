//
//  PrismInstructionModel.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/16.
//

#import "PrismInstructionModel.h"

@implementation PrismInstructionModel

- (NSString *)description {
    return [NSString stringWithFormat:@"Prism: vm:%@ | vp:%@ | vl:%@ | vq:%@ | vr:%@ | vf:%@ | h5:%@", self.vm ?: @"", self.vp ?: @"", self.vl ?: @"", self.vq ?: @"", self.vr ?: @"", self.vf ?: @"", self.h5 ?: @""];
}
@end
