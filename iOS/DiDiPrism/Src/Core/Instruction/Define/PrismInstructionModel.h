//
//  PrismInstructionModel.h
//  DiDiPrism
//
//  Created by hulk on 2021/6/16.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface PrismInstructionModel : NSObject
@property (nonatomic, copy) NSString *vm;
@property (nonatomic, copy) NSString *vp;
@property (nonatomic, copy) NSString *vl;
@property (nonatomic, copy) NSString *vq;
@property (nonatomic, copy) NSString *vr;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *vf;
@property (nonatomic, copy) NSString *h5;

- (NSDictionary*)toDictionary;
@end

NS_ASSUME_NONNULL_END
