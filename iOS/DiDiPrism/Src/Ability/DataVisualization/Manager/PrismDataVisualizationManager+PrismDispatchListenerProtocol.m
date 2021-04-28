//
//  PrismDataVisualizationManager+PrismDispatchListenerProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataVisualizationManager+PrismDispatchListenerProtocol.h"

@implementation PrismDataVisualizationManager (PrismDispatchListenerProtocol)
#pragma mark -delegate
#pragma mark PrismDispatchListenerProtocol
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    for (PrismDataBaseComponent *component in self.allComponents) {
        [component dispatchEvent:event withSender:sender params:params];
    }
}
@end
