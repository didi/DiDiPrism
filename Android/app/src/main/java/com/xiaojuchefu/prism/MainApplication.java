package com.xiaojuchefu.prism;

import android.app.Application;

import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.playback.PrismPlayback;

public class MainApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        PrismMonitor.getInstance().init(this);
        PrismPlayback.getInstance().init(this);
    }
}
