package com.xiaojuchefu.prism.monitor.event;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;

public class AppLifecycleObserver implements LifecycleObserver {

    PrismMonitor mPrismMonitor;

    public AppLifecycleObserver() {
        mPrismMonitor = PrismMonitor.getInstance();
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    private void onAppBackground() {
        if (mPrismMonitor.isMonitoring()) {
            mPrismMonitor.post(PrismConstants.Event.BACKGROUND);
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    private void onAppForeground() {
        if (mPrismMonitor.isMonitoring()) {
            mPrismMonitor.post(PrismConstants.Event.FOREGROUND);
        }
    }

}
