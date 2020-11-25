package com.xiaojuchefu.prism.playback;

import android.app.Activity;
import android.view.Window;

import java.util.ArrayList;
import java.util.List;

public class PrismWindowManager {

    private static PrismWindowManager sPrismWindowManager;
    private List<PrismWindow> mPrismWindows = new ArrayList<>();

    public static PrismWindowManager getInstance() {
        if (sPrismWindowManager == null) {
            sPrismWindowManager = new PrismWindowManager();
        }
        return sPrismWindowManager;
    }

    public void addPrismWindow(PrismWindow prismWindow) {
        mPrismWindows.add(prismWindow);
    }

    public void removePrismWindow(Window window) {
        for (int i = 0; i < mPrismWindows.size(); i++) {
            PrismWindow prismWindow = mPrismWindows.get(i);
            if (prismWindow.getWindow() == window) {
                mPrismWindows.remove(i);
                break;
            }
        }
    }

    public PrismWindow getTopWindow() {
        if (mPrismWindows.size() == 0) return null;

        Activity activity = AppLifecycler.getInstance().getCurrentActivity();
        if (activity == null) return null;

        for (int i = mPrismWindows.size() - 1; i >= 0; i--) {
            PrismWindow prismWindow = mPrismWindows.get(i);
            Window window = prismWindow.getWindow();
            if (window.getAttributes().type == 1) {
                if (window == activity.getWindow()) {
                    return prismWindow;
                }
            } else if (window.getAttributes().type == 2) {
                if (window.getAttributes().getTitle().equals(activity.getWindow().getAttributes().getTitle())) {
                    return prismWindow;
                }
            }
        }
        return null;
    }

}
