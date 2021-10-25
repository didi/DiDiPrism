package com.xiaojuchefu.prism.monitor.touch;

import android.view.MotionEvent;

import java.util.ArrayList;
import java.util.List;

import static com.xiaojuchefu.prism.monitor.PrismMonitor.sTouchSlop;

public class TouchRecord {

    public int mPointerId;

    public long mDownTime;
    public float mDownX;
    public float mDownY;

    public long mUpTime;
    public float mUpX;
    public float mUpY;

    public List<MoveTouch> mMoveTouch;

    public boolean isClick;

    private long mLastTime;
    private float mLastMoveX;
    private float mLastMoveY;

    public void onActionDown(MotionEvent ev) {
        int pointIndex = ev.getActionIndex();
        mPointerId = ev.getPointerId(pointIndex);
        mDownTime = mLastTime = ev.getDownTime();
        mDownX = mLastMoveX = ev.getX(pointIndex);
        mDownY = mLastMoveY = ev.getY(pointIndex);
    }

    public void onActionMove(MotionEvent ev) {
        if (mMoveTouch == null) {
            mMoveTouch = new ArrayList<>();
        }
        MoveTouch moveTouch = new MoveTouch();
        moveTouch.mMoveTime = ev.getEventTime() - mLastTime;
        mLastTime = moveTouch.mMoveTime + mLastTime;
        int pointIndex = ev.getActionIndex();

        moveTouch.mMoveX = ev.getX(pointIndex) - mLastMoveX;
        moveTouch.mMoveY = ev.getY(pointIndex) - mLastMoveY;
        mLastMoveX = moveTouch.mMoveX + mLastMoveX;
        mLastMoveY = moveTouch.mMoveY + mLastMoveY;

        mMoveTouch.add(moveTouch);
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
