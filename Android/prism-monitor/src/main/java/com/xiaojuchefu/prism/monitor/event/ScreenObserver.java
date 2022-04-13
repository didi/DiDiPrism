package com.xiaojuchefu.prism.monitor.event;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;

public class ScreenObserver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
            PrismMonitor.getInstance().post(PrismConstants.Event.SCREEN_ON);
        } else if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
            PrismMonitor.getInstance().post(PrismConstants.Event.SCREEN_OFF);
        }
    }

}
