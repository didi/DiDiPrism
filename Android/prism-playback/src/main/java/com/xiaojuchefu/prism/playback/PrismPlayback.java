package com.xiaojuchefu.prism.playback;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.app.Application;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.core.GlobalWindowManager;
import com.xiaojuchefu.prism.monitor.core.WindowObserver;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.playback.model.EventInfo;

import java.util.ArrayList;
import java.util.List;

public class PrismPlayback {

    private static PrismPlayback sPrismPlayback;

    private Context mContext;

    private int mCurrentIndex;
    private List<EventInfo> mEventInfoList;
    private boolean playing;
    private Handler mHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (!playing) return;

            switch (msg.what) {
                case 1:
                    mCurrentIndex++;
                    postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            next(0);
                        }
                    }, 1000);
                    break;
                case 2:
                    next(msg.arg1);
                    break;
                case 3:
                    break;
            }
        }
    };

    public static PrismPlayback getInstance() {
        synchronized (PrismPlayback.class) {
            if (sPrismPlayback == null) {
                sPrismPlayback = new PrismPlayback();
            }
            return sPrismPlayback;
        }
    }

    public void init(Application application) {
        mContext = application;
        AppLifecycler.getInstance().init(application);
        GlobalWindowManager.getInstance().getWindowObserver().addWindowObserverListener(new WindowObserver.WindowObserverListener() {
            @Override
            public void add(Window window) {
                final PrismWindow prismWindow = new PrismWindow(window);
                PrismWindowManager.getInstance().addPrismWindow(prismWindow);
            }

            @Override
            public void remove(Window window) {
                PrismWindowManager.getInstance().removePrismWindow(window);
            }
        });
    }

    public void playback(List<EventData> eventDataList) {
        List<EventInfo> eventInfoList = new ArrayList<>();
        for (int i = 0; i < eventDataList.size(); i++) {
            EventData eventData = eventDataList.get(i);
            EventInfo eventInfo = PlaybackHelper.convertEventInfo(eventData);
            if (eventInfo != null) {
                eventInfoList.add(eventInfo);
            }
        }
        mCurrentIndex = 0;
        mEventInfoList = eventInfoList;
        startPlayback();
    }

    private void startPlayback() {
        playing = true;
        next(0);
    }

    private void next(final int retryTimes) {
        if (mCurrentIndex + 1 > mEventInfoList.size()) {
            Toast.makeText(mContext, "回放结束", Toast.LENGTH_LONG).show();
            mHandler.sendEmptyMessageDelayed(3, 1000);
            return;
        }

        EventInfo eventInfo = mEventInfoList.get(mCurrentIndex);
        if (eventInfo.eventType == PrismConstants.Event.TOUCH) {
            if (eventInfo.eventData.containsKey(PrismConstants.Symbol.WEB_URL)) {
                Toast.makeText(mContext, "暂不支持web点击", Toast.LENGTH_LONG).show();
                mHandler.sendEmptyMessage(1);
            } else {
                PrismWindow prismWindow = PrismWindowManager.getInstance().getTopWindow();
                View targetView = PlaybackHelper.findTargetView(prismWindow, eventInfo);
                if (targetView == null) {
                    if (retryTimes == 3) {
                        Toast.makeText(mContext, "回放失败", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(mContext, "正在重试(" + (retryTimes + 1) + ")", Toast.LENGTH_SHORT).show();
                        Message message = mHandler.obtainMessage(2);
                        message.arg1 = retryTimes + 1;
                        mHandler.sendMessageDelayed(message, 1500);
                    }
                    return;
                }
                if (!targetView.isClickable()) {
                    targetView = PlaybackHelper.getClickableView(targetView);
                }
                final View tempView = targetView;
                mHandler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        highLightTriggerView(tempView, new OnAnimatorListener() {
                            @Override
                            public void onAnimationEnd() {
                                MotionHelper.simulateClick(tempView);
                                mHandler.sendEmptyMessage(1);
                            }
                        });
                    }
                }, 100);
            }
        } else if (eventInfo.eventType == PrismConstants.Event.ACTIVITY_START) {
            Toast.makeText(mContext, "页面跳转", Toast.LENGTH_SHORT).show();
            mHandler.sendEmptyMessage(1);
        } else if (eventInfo.eventType == PrismConstants.Event.BACK) {
            Toast.makeText(mContext, "返回", Toast.LENGTH_SHORT).show();
            MotionHelper.simulateBack();
            mHandler.sendEmptyMessage(1);
        } else if (eventInfo.eventType == PrismConstants.Event.DIALOG_SHOW) {
            mHandler.sendEmptyMessage(1);
        } else if (eventInfo.eventType == PrismConstants.Event.DIALOG_CLOSE) {
            mHandler.sendEmptyMessage(1);
        } else if (eventInfo.eventType == PrismConstants.Event.BACKGROUND) {
            Toast.makeText(mContext, "App退至后台", Toast.LENGTH_SHORT).show();
            mHandler.sendEmptyMessage(1);
        } else if (eventInfo.eventType == PrismConstants.Event.FOREGROUND) {
            Toast.makeText(mContext, "App进入前台", Toast.LENGTH_SHORT).show();
            mHandler.sendEmptyMessage(1);
        }
    }

    private void highLightTriggerView(final View view, final OnAnimatorListener listener) {
        final Drawable drawable = new Drawable() {
            @Override
            public void draw(Canvas canvas) {
                int backgroundColor = 0x99FF0000;
                RectF rect = new RectF(0, 0, view.getWidth(), view.getHeight());
                Paint mPaint = new Paint();
                mPaint.setColor(backgroundColor);
                mPaint.setStyle(Paint.Style.FILL);
                canvas.drawRoundRect(rect, 8, 8, mPaint);

            }

            @Override
            public void setAlpha(int alpha) {

            }

            @Override
            public void setColorFilter(@Nullable ColorFilter colorFilter) {

            }

            @Override
            public int getOpacity() {
                return PixelFormat.TRANSLUCENT;
            }
        };
        view.getOverlay().add(drawable);
        ObjectAnimator animator = ObjectAnimator.ofFloat(view, "alpha", 1f, 0.5f, 1f);
        animator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation, boolean isReverse) {
                view.getOverlay().remove(drawable);
                if (listener != null) {
                    listener.onAnimationEnd();
                }
            }
        });
        animator.setDuration(1200);
        animator.setRepeatCount(1);
        animator.start();
    }

    public interface OnAnimatorListener {

        void onAnimationEnd();

    }
}
