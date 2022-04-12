package com.xiaojuchefu.prism.monitor.event;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.model.BundleTypeAdapterFactory;
import com.xiaojuchefu.prism.monitor.model.EventData;

import java.util.HashMap;

public class ActivityLifecycleCallbacks implements Application.ActivityLifecycleCallbacks {

    PrismMonitor mPrismMonitor;
    private Gson sGson;
	// 前台计数
    private static volatile int mFrontCount = 0;

    public ActivityLifecycleCallbacks() {
        mPrismMonitor = PrismMonitor.getInstance();
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        String data = null;
        if (mPrismMonitor.isTest()) {
            Bundle bundle = activity.getIntent().getExtras();
            if (bundle != null) {
                try {
                    if (sGson == null) {
                        sGson = new GsonBuilder()
                                .registerTypeAdapterFactory(new BundleTypeAdapterFactory())
                                .create();
                    }
                    data = sGson.toJson(bundle);
                } catch (Exception e) {
                }
            }
        }

        EventData eventData = new EventData(PrismConstants.Event.ACTIVITY_START);
		eventData.activity = activity;
        eventData.eventId = PrismConstants.Symbol.ACTIVITY_NAME + PrismConstants.Symbol.DIVIDER_INNER + activity.getClass().getName();
        if (data != null) {
            eventData.data = new HashMap<>(1);
            eventData.data.put("bundle", data);
        }
        mPrismMonitor.post(eventData);

        Intent intent = activity.getIntent();
        if (intent != null) {
            if (Intent.ACTION_VIEW.equals(intent.getAction())) {
                Uri uri = intent.getData();
                if (uri != null) {
                    EventData schemeEventData = new EventData(PrismConstants.Event.SCHEME_OPEN);
                    schemeEventData.eventId = PrismConstants.Symbol.SCHEME + PrismConstants.Symbol.DIVIDER_INNER + uri.toString();
                    mPrismMonitor.post(schemeEventData);
                }
            }
        }
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
