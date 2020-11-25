package com.xiaojuchefu.prism.monitor.core;

import android.view.View;
import android.view.Window;

import com.xiaojuchefu.prism.monitor.R;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class WindowObserver extends ArrayList<View> {

    private Class mDecorClass;
    private Field sWindowField;

    private List<WindowObserverListener> mListeners = new ArrayList<>();

    WindowObserver() {
        try {
            mDecorClass = Class.forName("com.android.internal.policy.DecorView");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean add(View view) {
        if (mDecorClass == null) {
            mDecorClass = view.getRootView().getClass();
        }

        if (view.getClass() != mDecorClass) {
            return super.add(view);
        }

        Window window = getWindow(view);
        if (window == null) {
            return super.add(view);
        }

        view.setTag(R.id.prism_window, window);
        for (int i = 0; i < mListeners.size(); i++) {
            WindowObserverListener listener = mListeners.get(i);
            if (listener != null) {
                listener.add(window);
            }
        }
        return super.add(view);
    }

    @Override
    public View remove(int index) {
        View view = get(index);
        Window window = (Window) view.getTag(R.id.prism_window);
        if (window != null) {
            for (int i = 0; i < mListeners.size(); i++) {
                WindowObserverListener listener = mListeners.get(i);
                if (listener != null) {
                    listener.remove(window);
                }
            }
        }
        return super.remove(index);
    }

    public void bindWindow(View decorView) {
        if (mDecorClass == null) {
            mDecorClass = decorView.getClass();
        }

        if (decorView.getClass() != mDecorClass) {
            return;
        }

        Window window = getWindow(decorView);
        if (window != null) {
            decorView.setTag(R.id.prism_window, window);
        }
    }

    public Window getWindow(View decorView) {
        if (sWindowField == null) {
            try {
                sWindowField = decorView.getClass().getDeclaredField("mWindow");
                sWindowField.setAccessible(true);
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            }
        }

        Window window = null;
        if (sWindowField != null) {
            try {
                window = (Window) sWindowField.get(decorView);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return window;
    }

    public void addWindowObserverListener(WindowObserverListener listener) {
        if (listener != null) {
            mListeners.add(listener);
        }
    }

    public void removeWindowObserverListener(WindowObserverListener listener) {
        mListeners.remove(listener);
    }

    public interface WindowObserverListener {
        void add(Window window);
        void remove(Window window);
    }

}
