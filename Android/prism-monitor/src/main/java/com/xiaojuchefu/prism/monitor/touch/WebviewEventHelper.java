package com.xiaojuchefu.prism.monitor.touch;

import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.model.EventData;

public class WebviewEventHelper  {

    private static final String COLLECT_JS = "!function(){\"use strict\";var e=new(function(){function e(){}return e.prototype.record=function(e){for(var t=this.getContent(e),n=[];e&&\"body\"!==e.nodeName.toLowerCase();){var r=e.nodeName.toLowerCase();if(e.id)r+=\"#\"+e.id;else{for(var i=e.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\"),o=!(null===i||\"\"===i),s=e,c=1;s.previousElementSibling;)s=s.previousElementSibling,o&&s.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\")===i&&(o=!1),c+=1;if(o)for(s=e;s.nextElementSibling;)if(s=s.nextElementSibling,o&&s.className.split(\" \").filter((function(e){return\"\"!==e.trim()})).join(\".\")===i){o=!1;break}o?r+=\".\"+i:c>1&&(r+=\":nth-child(\"+c+\")\")}n.unshift(r),e=e.parentElement} n.unshift(\"body\"); return n.join(\">\")+\">\"+t;},e.prototype.getContent=function(e){return e.innerText?this.getText(e):e.getAttribute(\"src\")?e.getAttribute(\"src\"):e.querySelectorAll(\"img\")&&e.querySelectorAll(\"img\").length>0?this.getImgSrc(e):\"\"},e.prototype.getText=function(e){if(!(e.childNodes&&e.childNodes.length>0))return e.innerText||e.nodeValue;for(var t=0;t<e.childNodes.length;t++)if(e.childNodes[t].childNodes){var n=this.getText(e.childNodes[t]);if(n)return n}},e.prototype.getImgSrc=function(e){var t=e.querySelectorAll(\"img\");return t&&t[0]&&t[0].src},e}()),t=!1;document.addEventListener(\"touchmove\",(function(){!0!==t&&(t=!0)})),document.addEventListener(\"touchend\",(function(n){if(!0!==t){if(n.target)try{omega_collect_js_click.onClick(e.record(n.target))}catch(e){}}else t=!1}))}();";
    private static final String OMEGA_WEBVIEW_COLLECT_JS_TAG = "Omega_webview_collect_js";
    private static final String OMEGA_WEBVIEW_COLLECT_JS_NAME = "omega_collect_js_click";
    private static boolean mIsMonitor;

    public static void startMonitor() {
        mIsMonitor = true;
    }

    public static void addWebviewEventObject(WebView webView) {
        if(null == webView || !mIsMonitor) return;
        webView.addJavascriptInterface(WebviewEventHelper.JSObject.getInstance(), OMEGA_WEBVIEW_COLLECT_JS_NAME);
    }

    private static class JSObject {
        private static JSObject getInstance() {
            return onlyone;
        }
        private static JSObject onlyone = new JSObject();
        @JavascriptInterface
        public void onClick(String js) {
            if (!PrismMonitor.getInstance().isMonitoring() || !mIsMonitor) return;
            if(TextUtils.isEmpty(js)) return;
            int index = js.lastIndexOf(">");
            EventData eventData = new EventData(PrismConstants.Event.H5_TOUCH);
            if(index > 0) {
                eventData.h5 = js.substring(0,index);
                eventData.vr = js.substring(index+1,js.length());
            } else {
                eventData.vr = js;
            }
            PrismMonitor.getInstance().post(eventData);
        }
    }

    public static void collectWebView(View targetView) {
        if(null == targetView || !(targetView instanceof WebView) || !mIsMonitor) return;
        WebView webView = (WebView)targetView;
        bridgeJs(webView,OMEGA_WEBVIEW_COLLECT_JS_TAG,COLLECT_JS);
    }

    private static void bridgeJs(WebView webView,String tag,String js) {
        if(null == webView || TextUtils.isEmpty(tag) || TextUtils.isEmpty(js) || !mIsMonitor) return;

        Object retO = webView.getTag(tag.hashCode());
        if(null != retO) {
            if(retO instanceof Boolean) {
                Boolean o = (Boolean)retO;
                if(o) return;
            }
        }

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);//启用js
        webView.evaluateJavascript("javascript:" + js, null);
        webView.setTag(tag.hashCode(), true);
    }
}
