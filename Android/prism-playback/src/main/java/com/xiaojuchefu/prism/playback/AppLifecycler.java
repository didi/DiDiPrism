package com.xiaojuchefu.prism.playback;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

public class AppLifecycler {

    private static AppLifecycler sAppLifecycler;
    private boolean mInitialized;

    private ActivityLifecycleListener mActivityLifecycleListener;
    private WeakReference<Activity> mCurrentActivity;
    private List<ForegroundListener> mForegroundListeners;

    private AppLifecycleListener mAppLifecycleListener;

    private AppLifecycler() {
        mForegroundListeners = new ArrayList<>();
        mActivityLifecycleListener = new ActivityLifecycleListener();
        mAppLifecycleListener = new AppLifecycleListener();
    }

    public static AppLifecycler getInstance() {
        synchronized (AppLifecycler.class) {
            if (sAppLifecycler == null) {
                sAppLifecycler = new AppLifecycler();
            }
            return sAppLifecycler;
        }
    }

    public void init(Application application) {
        if (mInitialized) {
            return;
        }
        mInitialized = true;
        application.unregisterActivityLifecycleCallbacks(mActivityLifecycleListener);
        application.registerActivityLifecycleCallbacks(mActivityLifecycleListener);
        ProcessLifecycleOwner.get().getLifecycle().addObserver(mAppLifecycleListener);
    }

    public Activity getCurrentActivity() {
        if (mCurrentActivity != null) {
            Activity activity = mCurrentActivity.get();
            if (activity == null || activity.isFinishing()) {
                return null;
            } else {
                return activity;
            }
        }
        return null;
    }

    public void addForegroundListener(ForegroundListener listener) {
        if (listener != null) {
            mForegroundListeners.add(listener);
        }
    }

    public void removeForegroundListener(ForegroundListener listener) {
        mForegroundListeners.remove(listener);
    }

    public interface ForegroundListener {

        void onForegroundChanged(boolean foreground);

    }

    private class ActivityLifecycleListener implements Application.ActivityLifecycleCallbacks {

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

        }

        @Override
        public void onActivityStarted(Activity activity) {

        }

        @Override
        public void onActivityResumed(final Activity activity) {
            mCurrentActivity = new WeakReference<>(activity);
        }

        @Override
        public void onActivityPaused(Activity activity) {

        }

        @Override
        public void onActivityStopped(Activity activity) {

        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

        }

        @Override
        public void onActivityDestroyed(Activity activity) {

        }

    }

    private class AppLifecycleListener implements LifecycleObserver {

        @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
        private void onAppBackground() {
            for (int i = 0; i < mForegroundListeners.size(); i++) {
                mForegroundListeners.get(i).onForegroundChanged(false);
            }
        }

        @OnLifecycleEvent(Lifecycle.Event.ON_START)
        private void onAppForeground() {
            for (int i = 0; i < mForegroundListeners.size(); i++) {
                mForegroundListeners.get(i).onForegroundChanged(true);
            }
        }

    }

}
