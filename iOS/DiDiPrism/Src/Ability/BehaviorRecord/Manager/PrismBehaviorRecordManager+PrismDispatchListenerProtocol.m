//
//  PrismBehaviorRecordManager+PrismDispatchListenerProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismBehaviorRecordManager+PrismDispatchListenerProtocol.h"
#import <DiDiPrism/PrismInstructionParamUtil.h>
#import <DiDiPrism/PrismInstructionDefines.h>
#import <DiDiPrism/PrismInstructionModel.h>
// Category
#import <DiDiPrism/NSDictionary+PrismExtends.h>
#import <DiDiPrism/UIView+PrismExtends.h>
#import <DiDiPrism/UIControl+PrismIntercept.h>
#import <DiDiPrism/UIScreenEdgePanGestureRecognizer+PrismIntercept.h>
#import <DiDiPrism/WKWebView+PrismIntercept.h>
// Instruction
#import <DiDiPrism/PrismControlInstructionGenerator.h>
#import <DiDiPrism/PrismEdgePanInstructionGenerator.h>
#import <DiDiPrism/PrismTapGestureInstructionGenerator.h>
#import <DiDiPrism/PrismLongPressGestureInstructionGenerator.h>
#import <DiDiPrism/PrismCellInstructionGenerator.h>
#import <DiDiPrism/PrismViewControllerInstructionGenerator.h>
#import <DiDiPrism/PrismTextFieldInstructionGenerator.h>
#import <DiDiPrism/PrismRNViewInstructionGenerator.h>

@implementation PrismBehaviorRecordManager (PrismDispatchListenerProtocol)
#pragma mark -delegate
#pragma mark PrismDispatchListenerProtocol
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventUIControlSendAction_Start) {
        UIControl *control = (UIControl*)sender;
        NSObject *target = [params objectForKey:@"target"];
        NSString *action = [params objectForKey:@"action"];
        NSString *targetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), action];
        NSDictionary<NSString*,NSString*> *prismAutoDotTargetAndSelector = [control.prismAutoDotTargetAndSelector copy];
        if ([[prismAutoDotTargetAndSelector allValues] containsObject:targetAndSelector]) {
            NSMutableString *controlEvents = [NSMutableString string];
            for (NSString *key in [prismAutoDotTargetAndSelector allKeys]) {
                if ([prismAutoDotTargetAndSelector[key] isEqualToString:targetAndSelector]) {
                    if (controlEvents.length) {
                        [controlEvents appendString:@"_&_"];
                    }
                    [controlEvents appendString:key];
                }
            }
            PrismInstructionModel *instructionModel = [PrismControlInstructionGenerator getInstructionModelOfControl:control withTargetAndSelector:targetAndSelector withControlEvents:[controlEvents copy]];
            NSString *instruction = [instructionModel toString];
            if (instruction.length) {
                NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:control];
                [self addInstruction:instruction withEventParams:eventParams];
            }
        }
    }
    else if (event == PrismDispatchEventUIScreenEdgePanGestureRecognizerAction) {
        UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer*)sender;
        if (edgePanGestureRecognizer.edges != UIRectEdgeLeft) {
            return;
        }
        if (edgePanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            UIViewController *viewController = [edgePanGestureRecognizer.view prism_viewController];
            UINavigationController *navigationController = [viewController isKindOfClass:[UINavigationController class]] ? (UINavigationController*)viewController : viewController.navigationController;
            [edgePanGestureRecognizer setPrismAutoDotNavigationController:navigationController];
            NSInteger viewControllerCount = navigationController.viewControllers.count;
            [edgePanGestureRecognizer setPrismAutoDotViewControllerCount:[NSNumber numberWithInteger:viewControllerCount]];
        }
        // 输入后退手势时，如果手指始终未离开屏幕，state会变为UIGestureRecognizerStateCancelled
        if (edgePanGestureRecognizer.state != UIGestureRecognizerStateEnded &&
            edgePanGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
            return;
        }
        
        PrismInstructionModel *instructionModel = [PrismEdgePanInstructionGenerator getInstructionModelOfEdgePanGesture:edgePanGestureRecognizer];
        NSString *instruction = [instructionModel toString];
        if (!instruction.length) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UINavigationController *navigationController = [edgePanGestureRecognizer prismAutoDotNavigationController];
            NSInteger viewControllerCount = navigationController.viewControllers.count;
            if (navigationController && (viewControllerCount <= [edgePanGestureRecognizer prismAutoDotViewControllerCount].integerValue)) {
                [self addInstruction:instruction];
            }
        });
    }
    else if (event == PrismDispatchEventUITapGestureRecognizerAction) {
        UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
        PrismInstructionModel *instructionModel = [PrismTapGestureInstructionGenerator getInstructionModelOfTapGesture:tapGestureRecognizer];
        NSString *instruction = [instructionModel toString];
        if (instruction.length) {
            NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:tapGestureRecognizer.view];
            [self addInstruction:instruction withEventParams:eventParams];
        }
    }
    else if (event == PrismDispatchEventRCTSurfaceTouchHandlerSetState) {
        UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)sender;
        if ([gestureRecognizer isKindOfClass:NSClassFromString(@"RCTSurfaceTouchHandler")]) {
            UIView *view = gestureRecognizer.view;
            NSObject *surface = nil;
            if ([view respondsToSelector:@selector(surface)]) {
                surface = [view performSelector:@selector(surface)];
            }
            NSObject *properties = nil;
            if (surface && [surface respondsToSelector:@selector(properties)]) {
                properties = [surface performSelector:@selector(properties)];
            }
            NSString *pageInfo = nil;
            if (properties && [properties isKindOfClass:[NSDictionary class]]) {
                pageInfo = [(NSDictionary*)properties prism_stringForKey:@"drnPage"];
            }
            
            CGPoint viewPoint = [gestureRecognizer locationInView:view];
            // 背景是曾经遇到过研发自行重写了hitTest:withEvent:方法，并且存在不符合官方建议的定制逻辑。
            // 导致我们在主动调用hitTest:withEvent:方法时，触发了不必要的业务逻辑，导致非预期的问题。（官方是允许主动调用这个方法的）
            // RN支撑的前端代码不会对hitTest:withEvent:有特殊业务定制，所以可放心调用。
            UIView *hitView = [view hitTest:viewPoint withEvent:nil];
            
            // hitView为RCTImageComponentView大概率获取不到有效信息
            // 两种情况：
            // 一种是确实是有效按钮，比如后退按钮，需要交换RN框架已有实现来取得图片信息。
            // 一种是可能为一个占位符，非有效图片，需要遍历其superview找有效内容。
            if ([hitView isKindOfClass:NSClassFromString(@"RCTImageComponentView")]) {
                while ([hitView superview] &&
                       [[hitView superview] isKindOfClass:NSClassFromString(@"RCTViewComponentView")]) {
                    hitView = [hitView superview];
                    if ([hitView isMemberOfClass:NSClassFromString(@"RCTViewComponentView")]) {
                        break;
                    }
                }
            }
            
            PrismInstructionModel *instructionModel = [PrismRNViewInstructionGenerator getInstructionModelOfView:hitView withPageInfo:pageInfo];
            NSString *instruction = [instructionModel toString];
            if (instruction.length) {
                NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:hitView];
                [self addInstruction:instruction withEventParams:eventParams];
            }
        }
    }
    else if (event == PrismDispatchEventUILongPressGestureRecognizerAction) {
        UILongPressGestureRecognizer *longPressGesture = (UILongPressGestureRecognizer*)sender;
        PrismInstructionModel *instructionModel = [PrismLongPressGestureInstructionGenerator getInstructionModelOfLongPressGesture:longPressGesture];
        NSString *instruction = [instructionModel toString];
        if (instruction.length) {
            NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:longPressGesture.view];
            [self addInstruction:instruction withEventParams:eventParams];
        }
    }
    else if (event == PrismDispatchEventUIViewTouchesEnded_End) {
        UIView *view = (UIView*)sender;
        if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]]) {
            PrismInstructionModel *instructionModel = [PrismCellInstructionGenerator getInstructionModelOfCell:view];
            NSString *instruction = [instructionModel toString];
            if (instruction.length) {
                NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:view];
                [self addInstruction:instruction withEventParams:eventParams];
            }
        }
    }
    else if (event == PrismDispatchEventUIViewControllerViewDidAppear) {
        UIViewController *viewController = (UIViewController*)sender;
        PrismInstructionModel *instructionModel = [PrismViewControllerInstructionGenerator getInstructionModelOfViewController:viewController];
        NSString *instruction = [instructionModel toString];
        [self addInstruction:instruction];
    }
    else if (event == PrismDispatchEventWKWebViewInitWithFrame) {
        WKWebView *webView = (WKWebView*)sender;
        WKWebViewConfiguration *configuration = [params objectForKey:@"configuration"];
        NSString *recordScript = @"!function(){\"use strict\";var e=new(function(){function e(){}return e.prototype.record=function(e){for(var t=this.getContent(e),n=[];e&&\"body\"!==e.nodeName.toLowerCase();){var r=e.nodeName.toLowerCase();if(e.id)r+=\"#\"+e.id;else{for(var i=e.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\"),o=!(null===i||\"\"===i),s=e,c=1;s.previousElementSibling;)s=s.previousElementSibling,o&&s.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\")===i&&(o=!1),c+=1;if(o)for(s=e;s.nextElementSibling;)if(s=s.nextElementSibling,o&&s.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\")===i){o=!1;break}o?r+=\".\"+i:c>1&&(r+=\":nth-child(\"+c+\")\")}n.unshift(r),e=e.parentElement}return n.unshift(\"body\"),{instruct:n.join(\">\"),content:t}},e.prototype.getContent=function(e){return e.innerText?this.getText(e):e.getAttribute(\"src\")?e.getAttribute(\"src\"):e.querySelectorAll(\"img\")&&e.querySelectorAll(\"img\").length>0?this.getImgSrc(e):\"\"},e.prototype.getText=function(e){if(!(e.childNodes&&e.childNodes.length>0))return e.innerText||e.nodeValue;for(var t=0;t<e.childNodes.length;t++)if(e.childNodes[t].childNodes){var n=this.getText(e.childNodes[t]);if(n)return n}},e.prototype.getImgSrc=function(e){var t=e.querySelectorAll(\"img\");return t&&t[0]&&t[0].src},e}()),t=!1;document.addEventListener(\"touchmove\",(function(){!0!==t&&(t=!0)})),document.addEventListener(\"touchend\",(function(n){if(!0!==t){if(n.target)try{window.webkit.messageHandlers.prism_record_instruct&&window.webkit.messageHandlers.prism_record_instruct.postMessage(e.record(n.target))}catch(e){}}else t=!1}))}();";
        
        [webView prism_autoDot_addCustomScript:recordScript withConfiguration:configuration];
        NSString *scriptName = @"prism_record_instruct";
        [webView.configuration.userContentController removeScriptMessageHandlerForName:scriptName];
        [webView.configuration.userContentController addScriptMessageHandler:self name:scriptName];
    }
    else if (event == PrismDispatchEventUIApplicationLaunchByURL) {
        NSString *openUrl = [params objectForKey:@"openUrl"];
        NSString *instruction = [NSString stringWithFormat:@"%@%@%@", kUIApplicationOpenURL, kBeginOfViewRepresentativeContentFlag, openUrl ?: @""];
        [self addInstruction:instruction];
    }
    else if (event == PrismDispatchEventUIApplicationDidBecomeActive) {
        [self addInstruction:kUIApplicationBecomeActive];
    }
    else if (event == PrismDispatchEventUIApplicationWillResignActive) {
        [self addInstruction:kUIApplicationResignActive];
    }
    else if (event == PrismDispatchEventUITextFieldBecomeFirstResponder) {
        UITextField *textField = (UITextField*)sender;
        PrismInstructionModel *instructionModel = [PrismTextFieldInstructionGenerator getInstructionModelOfTextField:textField withEvent:event];
        NSString *instruction = [instructionModel toString];
        [self addInstruction:instruction];
    }
    else if (event == PrismDispatchEventUITextFieldResignFirstResponder) {
        UITextField *textField = (UITextField*)sender;
        PrismInstructionModel *instructionModel = [PrismTextFieldInstructionGenerator getInstructionModelOfTextField:textField withEvent:event];
        NSString *instruction = [instructionModel toString];
        [self addInstruction:instruction];
    }
}
@end
