//
//  PrismInstructionModel.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/16.
//

#import "PrismInstructionModel.h"
#import "PrismInstructionDefines.h"

@implementation PrismInstructionModel
- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    self.vm.length ? [dictionary setObject:self.vm forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vm"]] : NO;
    self.vp.length ? [dictionary setObject:self.vp forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vp"]] : NO;
    self.vl.length ? [dictionary setObject:self.vl forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vl"]] : NO;
    self.vq.length ? [dictionary setObject:self.vq forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vq"]] : NO;
    self.vr.length ? [dictionary setObject:self.vr forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vr"]] : NO;
    self.e.length ? [dictionary setObject:self.e forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"e"]] : NO;
    self.vf.length ? [dictionary setObject:self.vf forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vf"]] : NO;
    self.h5.length ? [dictionary setObject:self.h5 forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"h5"]] : NO;
    return [dictionary copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Prism: vm:%@ | vp:%@ | vl:%@ | vq:%@ | vr:%@ | vf:%@ | h5:%@", self.vm ?: @"", self.vp ?: @"", self.vl ?: @"", self.vq ?: @"", self.vr ?: @"", self.vf ?: @"", self.h5 ?: @""];
}
@end
