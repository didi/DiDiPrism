package com.xiaojuchefu.prism.monitor.event;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.model.EventData;

public class ActivityLifecycleCallbacks implements Application.ActivityLifecycleCallbacks {

    PrismMonitor mPrismMonitor;
    // 前台计数
    private static volatile int mFrontCount = 0;

    public ActivityLifecycleCallbacks() {
        mPrismMonitor = PrismMonitor.getInstance();
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        EventData eventData = new EventData(PrismConstants.Event.ACTIVITY_START);
        eventData.activity = activity;
        eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
        mPrismMonitor.post(eventData);
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (0 == mFrontCount++) {
            EventData eventData = new EventData(PrismConstants.Event.FOREGROUND);
            eventData.activity = activity;
            eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
            mPrismMonitor.post(eventData);
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        EventData eventData = new EventData(PrismConstants.Event.ACTIVITY_RESUME);
        eventData.activity = activity;
        eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
        mPrismMonitor.post(eventData);
    }

    @Override
    public void onActivityPaused(Activity activity) {
        EventData eventData = new EventData(PrismConstants.Event.ACTIVITY_PAUSE);
        eventData.activity = activity;
        eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
        mPrismMonitor.post(eventData);
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (1 == mFrontCount--) {
            EventData eventData = new EventData(PrismConstants.Event.BACKGROUND);
            eventData.activity = activity;
            eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
            mPrismMonitor.post(eventData);
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }

}
