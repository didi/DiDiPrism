//
//  PrismDataFloatingMenuItemConfig.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismDataFloatingMenuItemConfig : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) void(^block)(void);
@end

NS_ASSUME_NONNULL_END
