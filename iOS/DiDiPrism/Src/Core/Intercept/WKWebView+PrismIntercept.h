//
//  WKWebView+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2021/1/5.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (PrismIntercept)

+ (void)prism_swizzleMethodIMP;
- (void)prism_autoDot_addCustomScript:(NSString *)customScript withConfiguration:(WKWebViewConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
