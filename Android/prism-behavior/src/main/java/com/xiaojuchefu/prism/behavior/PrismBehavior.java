package com.xiaojuchefu.prism.behavior;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Message;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.model.EventData;

import java.util.List;

public class PrismBehavior {

    public static final String PRISM_BEHAVIOR_HIT_ACTION = "prism_behavior_detect_rule_hit";

    private static PrismBehavior sPrismBehavior;

    private boolean isInitialized;
    private boolean isStart;

    private Context mContext;
    private HandlerThread mHandlerThread;
    private Handler mEventHandler;

    private PrismMonitor.OnPrismMonitorListener mOnPrismMonitorListener = new PrismMonitor.OnPrismMonitorListener() {
        @Override
        public void onEvent(EventData eventData) {
            Message message = Message.obtain();
            message.obj = eventData;
            mEventHandler.sendMessage(message);
        }
    };

    private Handler.Callback mEventHandlerCallback = new Handler.Callback() {
        @Override
        public boolean handleMessage(@NonNull Message message) {
            if (message.what == 0) {
                EventData eventData = (EventData) message.obj;
                BehaviorData behaviorData = new BehaviorData(eventData);
                EventDataManager.getInstance().onEvent(behaviorData);
                BehaviorRuleManager.getInstance().onEvent(behaviorData);
            } else if (message.what == 3) {
                Rule rule = (Rule) message.obj;
                Intent intent = new Intent(PRISM_BEHAVIOR_HIT_ACTION);
                intent.putExtra("ruleId", String.valueOf(rule.ruleId));
                LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
            } else if (message.what == 4) {
                EventDataManager.getInstance().saveData();
            }
            return false;
        }
    };

    private PrismBehavior() {
    }

    public static PrismBehavior getInstance() {
        if (sPrismBehavior == null) {
            synchronized (PrismBehavior.class) {
                if (sPrismBehavior == null) {
                    sPrismBehavior = new PrismBehavior();
                }
            }
        }
        return sPrismBehavior;
    }

    public void init(Context context) {
        if (isInitialized) {
            return;
        }
        isInitialized = true;
        mContext = context;
        EventDataManager.getInstance().init(context);
    }

    public void setRules(List<Rule> rules) {
        BehaviorRuleManager.getInstance().setRules(rules);
    }

    public void start() {
        if (!isInitialized || isStart) {
            return;
        }
        isStart = true;

        mHandlerThread = new HandlerThread("prism-behavior");
        mHandlerThread.start();
        mEventHandler = new Handler(mHandlerThread.getLooper(), mEventHandlerCallback);

        PrismMonitor.getInstance().addOnPrismMonitorListener(mOnPrismMonitorListener);
    }

    public void stop() {
        if (!isInitialized || !isStart) {
            return;
        }
        isStart = false;

        PrismMonitor.getInstance().removeOnPrismMonitorListener(mOnPrismMonitorListener);

        Message message = Message.obtain();
        message.what = 4;
        mEventHandler.sendMessage(message);
        mHandlerThread.quitSafely();
    }

    public void onBehaviorHit(final Rule rule) {
        Message message = Message.obtain();
        message.what = 3;
        message.obj = rule;
        if (rule.triggerDelay == 0) {
            mEventHandler.sendMessage(message);
        } else {
            mEventHandler.sendMessageDelayed(message, rule.triggerDelay * 1000);
        }
    }

}
