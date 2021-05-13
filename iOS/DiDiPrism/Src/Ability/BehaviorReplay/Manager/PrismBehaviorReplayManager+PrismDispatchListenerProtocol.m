//
//  PrismBehaviorReplayManager+PrismDispatchListenerProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismBehaviorReplayManager+PrismDispatchListenerProtocol.h"
// Category
#import "WKWebView+PrismIntercept.h"

@implementation PrismBehaviorReplayManager (PrismDispatchListenerProtocol)
#pragma mark -delegate
#pragma mark PrismDispatchListenerProtocol
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventWKWebViewInitWithFrame) {
        WKWebView *webView = (WKWebView*)sender;
        WKWebViewConfiguration *configuration = [params objectForKey:@"configuration"];
        NSString *replayScript = @"!function(){\"use strict\";var t=new(function(){function t(){}return t.prototype.play=function(t){var e=this,n=document.querySelector(t);n&&(n.scrollIntoView({behavior:\"smooth\"}),this.change(n),setTimeout((function(){e.fireClick(n)}),3e3))},t.prototype.fireClick=function(t){if(document.createEvent){var e=document.createEvent(\"MouseEvents\");e.initEvent(\"click\",!0,!1),t.dispatchEvent(e)}},t.prototype.change=function(t){var e=t.getAttribute(\"style\"),n=\"background\",o=0,i=setTimeout((function r(){if(o)e?t.setAttribute(\"style\",e):t.setAttribute(\"style\",""),clearTimeout(i);else{var c=\"background-color: rgba(255, 0, 0,0.3)\";if(e&&(e.indexOf(n)>=0||e.indexOf(\"background-color\")>=0)){var u=e.split(\";\"),a=u.findIndex((function(t){return-1!==t.indexOf(n)||-1!==t.indexOf(\"background-color\")}));-1!==a&&u.splice(a,1,\"background-color: rgba(255, 0, 0,0.3)\"),c=u.join(\";\")}t.setAttribute(\"style\",c),o=1,i=setTimeout(r,1e3)}}),1e3)},t}());\"object\"==typeof window&&(window.PRISM_PLAYBACK_PLAY=t.play.bind(t))}();";
        
        [webView autoDot_addCustomScript:replayScript withConfiguration:configuration];
    }
}
@end
