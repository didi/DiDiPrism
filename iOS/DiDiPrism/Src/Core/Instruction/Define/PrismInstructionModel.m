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
    self.vt.length ? [dictionary setObject:self.vt forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vt"]] : NO;
    self.vl.length ? [dictionary setObject:self.vl forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vl"]] : NO;
    self.vq.length ? [dictionary setObject:self.vq forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vq"]] : NO;
    self.vr.length ? [dictionary setObject:self.vr forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vr"]] : NO;
    self.e.length ? [dictionary setObject:self.e forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"e"]] : NO;
    self.vf.length ? [dictionary setObject:self.vf forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"vf"]] : NO;
    self.h5.length ? [dictionary setObject:self.h5 forKey:[NSString stringWithFormat:@"%@%@", kDictionaryKeyPrefix, @"h5"]] : NO;
    return [dictionary copy];
}

- (NSString *)toString {
    NSMutableString *str = [NSMutableString string];
    self.e.length ? [str appendString:self.e] : NO;
    self.vm.length ? [str appendFormat:@"%@%@",kBeginOfViewMotionFlag,self.vm] : NO;
    self.vp.length ? [str appendFormat:@"%@%@",kBeginOfViewPathFlag,self.vp] : NO;
    self.vt.length ? [str appendFormat:@"%@%@",kBeginOfViewTreeFlag ,self.vt] : NO;
    self.vl.length ? [str appendFormat:@"%@%@",kBeginOfViewListFlag,self.vl] : NO;
    self.vq.length ? [str appendFormat:@"%@%@",kBeginOfViewQuadrantFlag,self.vq] : NO;
    self.vr.length ? [str appendFormat:@"%@%@",kBeginOfViewRepresentativeContentFlag,self.vr] : NO;
    self.vf.length ? [str appendFormat:@"%@%@",kBeginOfViewFunctionFlag,self.vf] : NO;
    return [str copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Prism: e:%@ | vm:%@ | vp:%@ | vt:%@ | vl:%@ | vq:%@ | vr:%@ | vf:%@ | h5:%@", self.e ?: @"", self.vm ?: @"", self.vp ?: @"", self.vt ?: @"", self.vl ?: @"", self.vq ?: @"", self.vr ?: @"", self.vf ?: @"", self.h5 ?: @""];
}
@end
