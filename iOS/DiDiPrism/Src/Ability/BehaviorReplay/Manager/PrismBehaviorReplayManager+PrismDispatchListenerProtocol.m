//
//  PrismBehaviorReplayManager+PrismDispatchListenerProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismBehaviorReplayManager+PrismDispatchListenerProtocol.h"
// Category
#import <DiDiPrism/WKWebView+PrismIntercept.h>

@implementation PrismBehaviorReplayManager (PrismDispatchListenerProtocol)
#pragma mark -delegate
#pragma mark PrismDispatchListenerProtocol
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventWKWebViewInitWithFrame) {
        WKWebView *webView = (WKWebView*)sender;
        WKWebViewConfiguration *configuration = [params objectForKey:@"configuration"];
        NSString *replayScript = @"!function(){\"use strict\";var t=new(function(){function t(){}return t.prototype.play=function(t){var e=this,n=document.querySelector(t);n&&(n.scrollIntoView({behavior:\"smooth\",block:\"center\",inline:\"nearest\"}),this.change(n),setTimeout((function(){var t=n.getBoundingClientRect();e.sendTouchEvent((t.left+t.right)/2,(t.top+t.bottom)/2,n,\"touchstart\"),e.sendTouchEvent((t.left+t.right)/2,(t.top+t.bottom)/2,n,\"touchend\"),e.fireClick(n)}),200))},t.prototype.fireClick=function(t){if(document.createEvent){var e=document.createEvent(\"MouseEvents\");e.initEvent(\"click\",!0,!1),t.dispatchEvent(e)}},t.prototype.change=function(t){var e=t.getAttribute(\"style\"),n=\"background\",o=0,i=setTimeout((function c(){if(o)e?t.setAttribute(\"style\",e):t.setAttribute(\"style\",\"\"),clearTimeout(i);else{var r=\"background-color: rgba(255, 0, 0,0.3)\";if(e&&(e.indexOf(n)>=0||e.indexOf(\"background-color\")>=0)){var u=e.split(\";\"),a=u.findIndex((function(t){return-1!==t.indexOf(n)||-1!==t.indexOf(\"background-color\")}));-1!==a&&u.splice(a,1,\"background-color: rgba(255, 0, 0,0.3)\"),r=u.join(\";\")}t.setAttribute(\"style\",r),o=1,i=setTimeout(c,400)}}),0)},t.prototype.sendTouchEvent=function(t,e,n,o){var i=new Touch({identifier:Date.now(),target:n,clientX:t,clientY:e,screenX:t,screenY:e,pageX:t,pageY:e,radiusX:5.5,radiusY:5.5,rotationAngle:0,force:1}),c=new TouchEvent(o,{cancelable:!0,bubbles:!0,touches:[i],targetTouches:[i],changedTouches:[i],shiftKey:!0});n.dispatchEvent(c)},t}());\"object\"==typeof window&&(window.PRISM_PLAYBACK_PLAY=t.play.bind(t))}();";
        
        [webView prism_autoDot_addCustomScript:replayScript withConfiguration:configuration];
    }
}
@end
