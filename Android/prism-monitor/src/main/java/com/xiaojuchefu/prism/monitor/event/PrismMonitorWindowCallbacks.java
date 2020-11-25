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
                if (touchRecord != null && touchRecord.isClick) {
                    int[] location = new int[]{(int) touchRecord.mDownX, (int) touchRecord.mDownY};
                    View targetView = TouchTracker.findTargetView((ViewGroup) window.getDecorView(), touchRecord.isClick ? location : null);
                    if (targetView != null) {
                        EventData eventData = TouchEventHelper.createEventData(window, targetView, touchRecord);
                        if (eventData != null) {
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
            mPrismMonitor.post(PrismConstants.Event.BACK);
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
