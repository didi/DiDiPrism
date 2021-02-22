//
//  PrismDispatchEventDefine.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#ifndef PrismDispatchEventDefine_h
#define PrismDispatchEventDefine_h

typedef NS_ENUM(NSUInteger, PrismDispatchEvent) {
    // UIView
    PrismDispatchEventUIViewTouchesEnded,
    // UIControl
    PrismDispatchEventUIControlSendActionStart,
    // UIScreenEdgePanGestureRecognizer
    PrismDispatchEventUIScreenEdgePanGestureRecognizerAction,
    // UITapGestureRecognizer
    PrismDispatchEventUITapGestureRecognizerAction,
    // UIViewController
    PrismDispatchEventUIViewControllerViewDidAppear,
    // WKWebView
    PrismDispatchEventWKWebViewInitWithFrame,
};

#endif /* PrismDispatchEventDefine_h */
