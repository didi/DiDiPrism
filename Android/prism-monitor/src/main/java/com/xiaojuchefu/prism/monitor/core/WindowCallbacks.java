package com.xiaojuchefu.prism.monitor.core;

import android.os.Build;
import android.view.ActionMode;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SearchEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;

import androidx.annotation.RequiresApi;

public class WindowCallbacks implements Window.Callback {

    private Window.Callback mCallBack;

    public WindowCallbacks(Window.Callback callback) {
        this.mCallBack = callback;
    }

    public Window.Callback getCallBack() {
        return this.mCallBack;
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
            if (event.getAction() == KeyEvent.ACTION_UP) {
                boolean result = dispatchBackKeyEvent();
                if (result) {
                    return true;
                } else {
                    return mCallBack != null && mCallBack.dispatchKeyEvent(event);
                }
            }
        }
        return mCallBack != null && mCallBack.dispatchKeyEvent(event);
    }

    @Override
    public boolean dispatchKeyShortcutEvent(KeyEvent event) {
        return mCallBack != null && mCallBack.dispatchKeyShortcutEvent(event);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        return mCallBack != null && (touchEvent(event) || mCallBack.dispatchTouchEvent(event));
    }

    public boolean touchEvent(MotionEvent event) {
        return false;
    }

    @Override
    public boolean dispatchTrackballEvent(MotionEvent event) {
        return mCallBack != null && mCallBack.dispatchTrackballEvent(event);
    }

    @Override
    public boolean dispatchGenericMotionEvent(MotionEvent event) {
        return mCallBack != null && mCallBack.dispatchGenericMotionEvent(event);
    }

    @Override
    public boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent event) {
        return mCallBack != null && mCallBack.dispatchPopulateAccessibilityEvent(event);
    }

    @Override
    public View onCreatePanelView(int featureId) {
        if (mCallBack == null) return null;
        return mCallBack.onCreatePanelView(featureId);
    }

    @Override
    public boolean onCreatePanelMenu(int featureId, Menu menu) {
        return mCallBack != null && mCallBack.onCreatePanelMenu(featureId, menu);
    }

    @Override
    public boolean onPreparePanel(int featureId, View view, Menu menu) {
        return mCallBack != null && mCallBack.onPreparePanel(featureId, view, menu);
    }

    @Override
    public boolean onMenuOpened(int featureId, Menu menu) {
        return mCallBack != null && mCallBack.onMenuOpened(featureId, menu);
    }

    @Override
    public boolean onMenuItemSelected(int featureId, MenuItem item) {
        return mCallBack != null && mCallBack.onMenuItemSelected(featureId, item);
    }

    @Override
    public void onWindowAttributesChanged(WindowManager.LayoutParams attrs) {
        if (mCallBack != null) {
            mCallBack.onWindowAttributesChanged(attrs);
        }
    }

    @Override
    public void onContentChanged() {
        if (mCallBack != null) {
            mCallBack.onContentChanged();
        }
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        if (mCallBack != null) {
            mCallBack.onWindowFocusChanged(hasFocus);
        }
    }

    @Override
    public void onAttachedToWindow() {
        if (mCallBack != null) {
            mCallBack.onAttachedToWindow();
        }
    }

    @Override
    public void onDetachedFromWindow() {
        if (mCallBack != null) {
            mCallBack.onDetachedFromWindow();
        }
    }

    @Override
    public void onPanelClosed(int featureId, Menu menu) {
        if (mCallBack != null) {
            mCallBack.onPanelClosed(featureId, menu);
        }
    }

    @Override
    public boolean onSearchRequested() {
        return mCallBack != null && mCallBack.onSearchRequested();
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public boolean onSearchRequested(SearchEvent searchEvent) {
        return mCallBack != null && mCallBack.onSearchRequested(searchEvent);
    }

    @Override
    public ActionMode onWindowStartingActionMode(ActionMode.Callback callback) {
        if (mCallBack == null) return null;
        return mCallBack.onWindowStartingActionMode(callback);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public ActionMode onWindowStartingActionMode(ActionMode.Callback callback, int type) {
        if (mCallBack == null) return null;
        return mCallBack.onWindowStartingActionMode(callback, type);
    }

    @Override
    public void onActionModeStarted(ActionMode mode) {
        if (mCallBack != null) {
            mCallBack.onActionModeStarted(mode);
        }
    }

    @Override
    public void onActionModeFinished(ActionMode mode) {
        if (mCallBack != null) {
            mCallBack.onActionModeFinished(mode);
        }
    }

    public boolean dispatchBackKeyEvent() {
        return false;
    }

}