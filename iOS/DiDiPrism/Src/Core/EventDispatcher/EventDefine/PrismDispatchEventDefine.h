//
//  PrismDispatchEventDefine.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#ifndef PrismDispatchEventDefine_h
#define PrismDispatchEventDefine_h

typedef NS_ENUM(NSUInteger, PrismEventCategory) {
    PrismEventCategoryTouch = 1 << 0, //点击事件
    PrismEventCategorySlip = 1 << 1, //滑动事件
    PrismEventCategoryPageSwitch = 1 << 2, //页面切换事件
    PrismEventCategoryNetwork = 1 << 3, //网络事件
    PrismEventCategorySystem = 1 << 4, //系统事件
    PrismEventCategoryInput = 1 << 5, //输入事件
    
    PrismEventCategoryAll = 0xFFFFFFFF
};


typedef NS_ENUM(NSUInteger, PrismDispatchEvent) {
    /*
     UIView
     */
    PrismDispatchEventUIViewTouchesEnded_Start,
    PrismDispatchEventUIViewTouchesEnded_End,
    PrismDispatchEventUIViewDidMoveToSuperview,
    PrismDispatchEventUIViewDidMoveToWindow,
    PrismDispatchEventUIViewSetFrame,
    PrismDispatchEventUIViewSetHidden,
    /*
     UIControl
     */
    PrismDispatchEventUIControlSendAction_Start,
    PrismDispatchEventUIControlTouchDownAction,
    PrismDispatchEventUIControlTouchUpInsideAction,
    PrismDispatchEventUIControlTouchUpOutsideAction,
    PrismDispatchEventUIControlOtherAction,
    /*
     UIScreenEdgePanGestureRecognizer
     */
    PrismDispatchEventUIScreenEdgePanGestureRecognizerAction,
    /*
     UITapGestureRecognizer
     */
    PrismDispatchEventUITapGestureRecognizerSetState,
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
    /*
     UIApplication
     */
    PrismDispatchEventUIApplicationDidBecomeActive,
    PrismDispatchEventUIApplicationWillResignActive,
    PrismDispatchEventUIApplicationLaunchByURL,
    /*
     UIScrollView
     */
    PrismDispatchEventUIScrollViewSetContentOffset,
    /*
     UITextField
     */
    PrismDispatchEventUITextFieldBecomeFirstResponder,
    PrismDispatchEventUITextFieldResignFirstResponder,
};

#endif /* PrismDispatchEventDefine_h */
