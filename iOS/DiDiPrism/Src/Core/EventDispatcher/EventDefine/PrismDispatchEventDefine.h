//
//  PrismDispatchEventDefine.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#ifndef PrismDispatchEventDefine_h
#define PrismDispatchEventDefine_h

typedef NS_ENUM(NSUInteger, PrismDispatchEvent) {
    /*
     UIView
     */
    PrismDispatchEventUIViewTouchesEnded_End,
    PrismDispatchEventUIViewDidMoveToSuperview,
    PrismDispatchEventUIViewDidMoveToWindow,
    /*
     UIControl
     */
    PrismDispatchEventUIControlSendAction_Start,
    PrismDispatchEventUIControlTouchAction,
    /*
     UIScreenEdgePanGestureRecognizer
     */
    PrismDispatchEventUIScreenEdgePanGestureRecognizerAction,
    /*
     UITapGestureRecognizer
     */
    PrismDispatchEventUITapGestureRecognizerAction,
    /*
     UILongPressGestureRecognizer
     */
    PrismDispatchEventUILongPressGestureRecognizerAction,
    /*
     UIViewController
     */
    PrismDispatchEventUIViewControllerViewDidAppear,
    PrismDispatchEventUIViewControllerViewPresentVC,
    PrismDispatchEventUIViewControllerViewDismissVC,
    PrismDispatchEventUIViewControllerViewAddChildVC,
    PrismDispatchEventUIViewControllerViewRemoveChildVC,
    /*
     UINavigationController
     */
    PrismDispatchEventUINavigationControllerPushVC,
    PrismDispatchEventUINavigationControllerPopVC,
    PrismDispatchEventUINavigationControllerPopToVC,
    PrismDispatchEventUINavigationControllerPopToRootVC,
    /*
     WKWebView
     */
    PrismDispatchEventWKWebViewInitWithFrame,
};

#endif /* PrismDispatchEventDefine_h */
