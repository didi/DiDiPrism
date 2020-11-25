package com.xiaojuchefu.prism.monitor.touch;

import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.HorizontalScrollView;
import android.widget.ScrollView;

import androidx.recyclerview.widget.RecyclerView;

import java.lang.reflect.Field;

public class TouchTracker {

    private static Field sTouchTargetField;
    private static Field sTouchTargetChildField;

    public static View findTargetView(ViewGroup rootView, int[] location) {
        View nextTarget, target = null;
        if (ensureTargetField() && rootView != null) {
            nextTarget = getTargetView(rootView);
            do {
                target = nextTarget;
                nextTarget = null;
                if (target instanceof ViewGroup) {
                    nextTarget = getTargetView((ViewGroup) target);
                }
            } while (nextTarget != null);
        }
        return location != null ? filterView(target, location) : target;
    }

    private static boolean ensureTargetField() {
        if (sTouchTargetField == null) {
            try {
                Class viewClass = Class.forName("android.view.ViewGroup");
                if (viewClass != null) {
                    sTouchTargetField = viewClass.getDeclaredField("mFirstTouchTarget");
                    sTouchTargetField.setAccessible(true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (sTouchTargetField != null) {
                    sTouchTargetChildField = sTouchTargetField.getType().getDeclaredField("child");
                    sTouchTargetChildField.setAccessible(true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return sTouchTargetField != null && sTouchTargetChildField != null;
    }

    private static View getTargetView(ViewGroup parent) {
        try {
            Object target = sTouchTargetField.get(parent);
            if (target != null) {
                Object view = sTouchTargetChildField.get(target);
                if (view instanceof View) {
                    return (View) view;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static View filterView(View view, int[] location) {
        if (view instanceof AbsListView || view instanceof RecyclerView) {
            ViewGroup viewGroup = (ViewGroup) view;
            for (int i = 0; i < viewGroup.getChildCount(); i++) {
                View childView = viewGroup.getChildAt(i);
                Rect globalRect = new Rect();
                childView.getGlobalVisibleRect(globalRect);
                if (globalRect.contains(location[0], location[1])) {
                    return childView;
                }
            }
        } else if (view instanceof ScrollView || view instanceof HorizontalScrollView) {
            return null;
        }
        return view;
    }

}
