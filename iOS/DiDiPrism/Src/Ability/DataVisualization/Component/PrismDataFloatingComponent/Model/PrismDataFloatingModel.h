//
//  PrismDataFloatingModel.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismDataFloatingModel : PrismDataBaseModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *flagContent;
@property (nonatomic, assign) NSInteger value;
@end

NS_ASSUME_NONNULL_END
