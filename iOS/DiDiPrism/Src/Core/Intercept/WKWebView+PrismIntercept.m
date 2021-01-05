//
//  WKWebView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/1/5.
//

#import "WKWebView+PrismIntercept.h"
#import "PrismBehaviorRecordManager.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation WKWebView (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithFrame:configuration:) swizzledSelector:@selector(autoDot_initWithFrame:configuration:)];
    });
}

- (instancetype)autoDot_initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    WKWebView *webView = [self autoDot_initWithFrame:frame configuration:configuration];
    
    if ([[PrismBehaviorRecordManager sharedInstance] canH5Upload]) {
        NSString *recordScript = @"!function(){\"use strict\";var e=new(function(){function e(){}return e.prototype.record=function(e){for(var t=this.getContent(e),r=[];e&&\"body\"!==e.nodeName.toLowerCase();){var n=e.nodeName.toLowerCase();if(e.id)n+=\"#\"+e.id;else{for(var i=e,o=1;i.previousElementSibling;)i=i.previousElementSibling,o+=1;o>1&&(n+=\":nth-child(\"+o+\")\")}r.unshift(n),e=e.parentElement}return r.unshift(\"body\"),{instruct:r.join(\">\"),content:t}},e.prototype.getContent=function(e){return e.innerText?this.getText(e):e.getAttribute(\"src\")?e.getAttribute(\"src\"):e.querySelectorAll(\"img\")&&e.querySelectorAll(\"img\").length>0?this.getImgSrc(e):\"\"},e.prototype.getText=function(e){if(!(e.childNodes&&e.childNodes.length>0))return e.innerText||e.nodeValue;for(var t=0;t<e.childNodes.length;t++)if(e.childNodes[t].childNodes){var r=this.getText(e.childNodes[t]);if(r)return r}},e.prototype.getImgSrc=function(e){var t=e.querySelectorAll(\"img\");return t&&t[0]&&t[0].src},e}());document.addEventListener(\"click\",(function(t){if(t.target)try{window.webkit.messageHandlers.prism_record_instruct&&window.webkit.messageHandlers.prism_record_instruct.postMessage(e.record(t.target))}catch(e){}}))}();";
        
        [webView autoDot_addCustomScript:recordScript withConfiguration:configuration];
        NSString *scriptName = @"prism_record_instruct";
        [webView.configuration.userContentController removeScriptMessageHandlerForName:scriptName];
        [webView.configuration.userContentController addScriptMessageHandler:[PrismBehaviorRecordManager sharedInstance] name:scriptName];
    }
    
    NSString *replayScript = @"!function(){\"use strict\";var t=new(function(){function t(){}return t.prototype.play=function(t){var e=this,n=document.querySelector(t);n&&(n.scrollIntoView({behavior:\"smooth\"}),this.change(n),setTimeout((function(){e.fireClick(n)}),3e3))},t.prototype.fireClick=function(t){if(document.createEvent){var e=document.createEvent(\"MouseEvents\");e.initEvent(\"click\",!0,!1),t.dispatchEvent(e)}},t.prototype.change=function(t){var e=t.getAttribute(\"style\"),n=\"background\",o=0,i=setTimeout((function r(){if(o)e?t.setAttribute(\"style\",e):t.setAttribute(\"style\",""),clearTimeout(i);else{var c=\"background-color: rgba(255, 0, 0,0.3)\";if(e&&(e.indexOf(n)>=0||e.indexOf(\"background-color\")>=0)){var u=e.split(\";\"),a=u.findIndex((function(t){return-1!==t.indexOf(n)||-1!==t.indexOf(\"background-color\")}));-1!==a&&u.splice(a,1,\"background-color: rgba(255, 0, 0,0.3)\"),c=u.join(\";\")}t.setAttribute(\"style\",c),o=1,i=setTimeout(r,1e3)}}),1e3)},t}());\"object\"==typeof window&&(window.PRISM_PLAYBACK_PLAY=t.play.bind(t))}();";
    
    [webView autoDot_addCustomScript:replayScript withConfiguration:configuration];
    
    return webView;
}

- (void)autoDot_addCustomScript:(NSString *)customScript withConfiguration:(WKWebViewConfiguration *)configuration {
    if(!customScript.length) return;
    
    NSArray *scripts = [configuration.userContentController userScripts];
    for(WKUserScript *script in scripts){
        if([script.source isEqualToString:customScript])
            return;
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:customScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
}
@end
