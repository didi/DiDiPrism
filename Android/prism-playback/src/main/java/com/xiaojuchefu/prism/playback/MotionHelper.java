package com.xiaojuchefu.prism.playback;

import android.app.Instrumentation;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MotionHelper {

    private final static ExecutorService DEFAULT_EXECUTOR_SERVICE = Executors.newCachedThreadPool();

    public static void simulateClick(View view) {
        int[] outLocation = new int[2];
        view.getLocationOnScreen(outLocation);
        float x = outLocation[0] + view.getWidth() / 2;
        float y = outLocation[1] + view.getHeight() / 2;
        long downTime = SystemClock.uptimeMillis();
        final MotionEvent downEvent = MotionEvent.obtain(downTime, downTime, MotionEvent.ACTION_DOWN, x, y, 0);
        final MotionEvent upEvent = MotionEvent.obtain(downTime + 100, downTime + 100, MotionEvent.ACTION_UP, x, y, 0);
        view.onTouchEvent(downEvent);
        view.onTouchEvent(upEvent);
        downEvent.recycle();
        upEvent.recycle();
    }

    public static void simulateBack() {
        execute(new Runnable() {
            @Override
            public void run() {
                try {
                    Instrumentation inst = new Instrumentation();
                    inst.sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });
    }

    private static void execute(Runnable runnable) {
        DEFAULT_EXECUTOR_SERVICE.execute(runnable);
    }

}
