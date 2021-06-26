//
//  PrismInstructionModel.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/16.
//

#import "PrismInstructionModel.h"

@implementation PrismInstructionModel
- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    self.vm.length ? [dictionary setObject:self.vm forKey:@"prism-vm"] : NO;
    self.vp.length ? [dictionary setObject:self.vp forKey:@"prism-vp"] : NO;
    self.vl.length ? [dictionary setObject:self.vl forKey:@"prism-vl"] : NO;
    self.vq.length ? [dictionary setObject:self.vq forKey:@"prism-vq"] : NO;
    self.vr.length ? [dictionary setObject:self.vr forKey:@"prism-vr"] : NO;
    self.e.length ? [dictionary setObject:self.e forKey:@"prism-e"] : NO;
    self.vf.length ? [dictionary setObject:self.vf forKey:@"prism-vf"] : NO;
    self.h5.length ? [dictionary setObject:self.h5 forKey:@"prism-h5"] : NO;
    return [dictionary copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Prism: vm:%@ | vp:%@ | vl:%@ | vq:%@ | vr:%@ | vf:%@ | h5:%@", self.vm ?: @"", self.vp ?: @"", self.vl ?: @"", self.vq ?: @"", self.vr ?: @"", self.vf ?: @"", self.h5 ?: @""];
}
@end
