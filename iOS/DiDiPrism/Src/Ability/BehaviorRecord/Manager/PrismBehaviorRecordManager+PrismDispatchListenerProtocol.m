//
//  PrismBehaviorRecordManager+PrismDispatchListenerProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismBehaviorRecordManager+PrismDispatchListenerProtocol.h"
#import "PrismInstructionParamUtil.h"
// Category
#import "NSDictionary+PrismExtends.h"
#import "UIView+PrismExtends.h"
#import "UIControl+PrismIntercept.h"
#import "UIScreenEdgePanGestureRecognizer+PrismIntercept.h"
#import "WKWebView+PrismIntercept.h"
// Instruction
#import "PrismControlInstructionGenerator.h"
#import "PrismEdgePanInstructionGenerator.h"
#import "PrismTapGestureInstructionGenerator.h"
#import "PrismCellInstructionGenerator.h"
#import "PrismViewControllerInstructionGenerator.h"

@implementation PrismBehaviorRecordManager (PrismDispatchListenerProtocol)
#pragma mark -delegate
#pragma mark PrismDispatchListenerProtocol
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (![self canUpload]) {
        return;
    }
    if (event == PrismDispatchEventUIControlSendAction_Start) {
        UIControl *control = (UIControl*)sender;
        NSObject *target = [params objectForKey:@"target"];
        NSString *action = [params objectForKey:@"action"];
        NSString *targetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), action];
        if ([targetAndSelector isEqualToString:control.prismAutoDotTargetAndSelector]) {
            NSString *instruction = [PrismControlInstructionGenerator getInstructionOfControl:control];
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
        
        NSString *instruction = [PrismEdgePanInstructionGenerator getInstructionOfEdgePanGesture:edgePanGestureRecognizer];
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
        NSString *instruction = [PrismTapGestureInstructionGenerator getInstructionOfTapGesture:tapGestureRecognizer];
        if (instruction.length) {
            NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:tapGestureRecognizer.view];
            [self addInstruction:instruction withEventParams:eventParams];
        }
    }
    else if (event == PrismDispatchEventUIViewTouchesEnded_End) {
        UIView *view = (UIView*)sender;
        if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]]) {
            NSString *instruction = [PrismCellInstructionGenerator getInstructionOfCell:view];
            if (instruction.length) {
                NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:view];
                [self addInstruction:instruction withEventParams:eventParams];
            }
        }
    }
    else if (event == PrismDispatchEventUIViewControllerViewDidAppear) {
        UIViewController *viewController = (UIViewController*)sender;
        NSString *instruction = [PrismViewControllerInstructionGenerator getInstructionOfViewController:viewController];
        [self addInstruction:instruction];
    }
    else if (event == PrismDispatchEventWKWebViewInitWithFrame) {
        if (![self canH5Upload]) {
            return;
        }
        WKWebView *webView = (WKWebView*)sender;
        WKWebViewConfiguration *configuration = [params objectForKey:@"configuration"];
        NSString *recordScript = @"!function(){\"use strict\";var e=new(function(){function e(){}return e.prototype.record=function(e){for(var t=this.getContent(e),r=[];e&&\"body\"!==e.nodeName.toLowerCase();){var n=e.nodeName.toLowerCase();if(e.id)n+=\"#\"+e.id;else{for(var i=e,o=1;i.previousElementSibling;)i=i.previousElementSibling,o+=1;o>1&&(n+=\":nth-child(\"+o+\")\")}r.unshift(n),e=e.parentElement}return r.unshift(\"body\"),{instruct:r.join(\">\"),content:t}},e.prototype.getContent=function(e){return e.innerText?this.getText(e):e.getAttribute(\"src\")?e.getAttribute(\"src\"):e.querySelectorAll(\"img\")&&e.querySelectorAll(\"img\").length>0?this.getImgSrc(e):\"\"},e.prototype.getText=function(e){if(!(e.childNodes&&e.childNodes.length>0))return e.innerText||e.nodeValue;for(var t=0;t<e.childNodes.length;t++)if(e.childNodes[t].childNodes){var r=this.getText(e.childNodes[t]);if(r)return r}},e.prototype.getImgSrc=function(e){var t=e.querySelectorAll(\"img\");return t&&t[0]&&t[0].src},e}());document.addEventListener(\"click\",(function(t){if(t.target)try{window.webkit.messageHandlers.prism_record_instruct&&window.webkit.messageHandlers.prism_record_instruct.postMessage(e.record(t.target))}catch(e){}}))}();";
        
        [webView prism_autoDot_addCustomScript:recordScript withConfiguration:configuration];
        NSString *scriptName = @"prism_record_instruct";
        [webView.configuration.userContentController removeScriptMessageHandlerForName:scriptName];
        [webView.configuration.userContentController addScriptMessageHandler:self name:scriptName];
    }
}
@end
