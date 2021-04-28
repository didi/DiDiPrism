//
//  PrismDataBaseComponent.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import <UIKit/UIKit.h>
#import "PrismEventDispatcher.h"
#import "PrismIdentifierUtil.h"
#import "PrismDataBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PrismDataBaseComponent;

@protocol PrismDataBaseComponentDelegate <NSObject>

@end

@protocol PrismDataProviderProtocol <NSObject>
- (void)provideDataToComponent:(PrismDataBaseComponent*)component
                    withParams:(NSDictionary*)params
                withCompletion:(void(^)(PrismDataBaseModel*))completion;
@end

@interface PrismDataBaseComponent : NSObject
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, weak) id<PrismDataBaseComponentDelegate> delegate;
@property (nonatomic, weak) id<PrismDataProviderProtocol> dataProvider;

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params;

#pragma mark - protected method
- (UIViewController*)_protected_searchMainViewController;
@end

NS_ASSUME_NONNULL_END
