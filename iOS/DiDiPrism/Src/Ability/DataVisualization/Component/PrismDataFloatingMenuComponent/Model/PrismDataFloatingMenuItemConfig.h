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
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) void(^block)(UIView*);
@end

NS_ASSUME_NONNULL_END
