package com.xiaojuchefu.prism.monitor.event;

import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.core.WindowCallbacks;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.monitor.touch.TouchEventHelper;
import com.xiaojuchefu.prism.monitor.touch.TouchRecord;
import com.xiaojuchefu.prism.monitor.touch.TouchRecordManager;
import com.xiaojuchefu.prism.monitor.touch.TouchTracker;
import com.xiaojuchefu.prism.monitor.touch.WebviewEventHelper;

public class PrismMonitorWindowCallbacks extends WindowCallbacks {
    PrismMonitor mPrismMonitor;
    private Window window;

    public PrismMonitorWindowCallbacks(Window window) {
        super(window.getCallback());
        this.window = window;
        mPrismMonitor = PrismMonitor.getInstance();
    }

    @Override
    public boolean touchEvent(MotionEvent event) {
        if (mPrismMonitor.isMonitoring()) {
            TouchRecordManager.getInstance().touchEvent(event);
            int action = event.getActionMasked();
            if (action == MotionEvent.ACTION_UP) {
                TouchRecord touchRecord = TouchRecordManager.getInstance().getTouchRecord();
                if (touchRecord != null && (touchRecord.isClick || mPrismMonitor.isTest())) {
                    int[] location = new int[]{(int) touchRecord.mDownX, (int) touchRecord.mDownY};
                    long findTargetStartTime = System.currentTimeMillis();
                    View targetView = TouchTracker.findTargetView((ViewGroup) window.getDecorView(), touchRecord.isClick ? location : null);
                    WebviewEventHelper.collectWebView(targetView);
                    long fvd = System.currentTimeMillis() - findTargetStartTime;
                    if (targetView != null) {
                        long createEventStartTime = System.currentTimeMillis();
                        EventData eventData = TouchEventHelper.createEventData(window, targetView, touchRecord);
                        long avd = System.currentTimeMillis() - createEventStartTime;
                        if (eventData != null) {
                            eventData.mDownX = touchRecord.mDownX;
                            eventData.mDownY = touchRecord.mDownY;
                            eventData.fvd = fvd;
                            eventData.avd = avd;
                            mPrismMonitor.post(eventData);
                        }
                    }
                }
            }
        }
        return false;
    }

    @Override
    public boolean dispatchBackKeyEvent() {
        if (mPrismMonitor.isMonitoring()) {
            EventData eventData = new EventData(PrismConstants.Event.BACK);
            eventData.vr = "[text]返回键";
            eventData.mDownX = -1;
            eventData.mDownY = -1;
            mPrismMonitor.post(eventData);
        }
        return false;
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (mPrismMonitor.isMonitoring() && window.getAttributes().type == 2) {
            mPrismMonitor.post(PrismConstants.Event.DIALOG_SHOW);
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mPrismMonitor.isMonitoring() && window.getAttributes().type == 2) {
            mPrismMonitor.post(PrismConstants.Event.DIALOG_CLOSE);
        }
    }
}
