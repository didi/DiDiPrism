package com.xiaojuchefu.prism.monitor.touch;

import android.view.MotionEvent;

import static com.xiaojuchefu.prism.monitor.PrismMonitor.sTouchSlop;

public class TouchRecord {

    public int mPointerId;

    public long mDownTime;
    public float mDownX;
    public float mDownY;

    public long mUpTime;
    public float mUpX;
    public float mUpY;

    public boolean isClick;

    public void onActionDown(MotionEvent ev) {
        int pointIndex = ev.getActionIndex();
        mPointerId = ev.getPointerId(pointIndex);
        mDownTime = ev.getDownTime();
        mDownX = ev.getX(pointIndex);
        mDownY = ev.getY(pointIndex);
    }

    public void onActionUp(MotionEvent ev) {
        mUpTime = ev.getEventTime();
        int pointIndex = ev.getActionIndex();
        mUpX = ev.getX(pointIndex);
        mUpY = ev.getY(pointIndex);

        isClick = Math.abs(mDownX - mUpX) < sTouchSlop && Math.abs(mDownY - mUpY) < sTouchSlop;
    }

    public class MoveTouch {
        public long mMoveTime;
        public float mMoveX;
        public float mMoveY;
    }

}
