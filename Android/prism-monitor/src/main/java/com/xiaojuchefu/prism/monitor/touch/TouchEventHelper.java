package com.xiaojuchefu.prism.monitor.touch;

import android.content.Context;
import android.graphics.Point;
import android.net.Uri;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.AbsListView;
import android.widget.HorizontalScrollView;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.monitor.model.ViewContainer;
import com.xiaojuchefu.prism.monitor.model.ViewContent;
import com.xiaojuchefu.prism.monitor.model.ViewPath;

import java.util.ArrayList;
import java.util.List;

public class TouchEventHelper {

    private static int mWindowWidth = -1;
    private static int mWindowHeight = -1;

    public static EventData createEventData(Window window, View touchView, TouchRecord touchRecord) {
        if (touchView == null) {
            return null;
        }
        StringBuilder eventId = new StringBuilder();
        getWindowInfo(window, eventId);
        ViewPath viewPath = getViewPathInfo(touchView, touchRecord, eventId);
        if (viewPath.viewContainer != null) { // containerView
            ViewContainer viewContainer = viewPath.viewContainer;
            eventId.append(PrismConstants.Symbol.DIVIDER).append(viewContainer.symbol).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewContainer.url);
        } else if (!TextUtils.isEmpty(viewPath.webUrl)) { // webview
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.WEB_URL).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.webUrl);
        } else { // native
            getViewId(touchView, eventId);
        }

        eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_PATH).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.path);
        if (!TextUtils.isEmpty(viewPath.listInfo)) { // in list container view
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_LIST).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.listInfo);
        }

        // view content
        if (touchRecord.isClick && TextUtils.isEmpty(viewPath.webUrl)) {
            getViewContent(touchView, eventId);
        }
        // quadrant
        if (!viewPath.inScrollableContainer) {
            getQuadrant(touchView.getContext(), touchRecord, eventId);
        }

        EventData eventData = new EventData(PrismConstants.Event.TOUCH);
        eventData.eventId = eventId.toString();
        return eventData;
    }

    private static void getWindowInfo(Window window, StringBuilder eventId) {
        eventId.append(PrismConstants.Symbol.WINDOW);
        eventId.append(PrismConstants.Symbol.DIVIDER_INNER);
        // window title
        String title = window.getAttributes().getTitle().toString().trim();
        eventId.append(title.substring(title.indexOf("/") + 1));
        eventId.append(PrismConstants.Symbol.DIVIDER_INNER);
        // window type
        eventId.append(window.getAttributes().type);
    }

    private static void getViewId(View touchView, StringBuilder eventId) {
        String viewIdName = getResourceName(touchView.getContext(), touchView.getId());
        if (viewIdName != null) {
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_ID).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewIdName);
        }
    }

    public static String getResourceName(Context context, int resourceId) {
        if (resourceId == View.NO_ID || resourceId == 0) {
            return null;
        } else {
            try {
                // [package]:id/[xml-id]
                String resourceName = context.getResources().getResourceName(resourceId);
                resourceName = resourceName.substring(resourceName.lastIndexOf("/") + 1);
                String hex = Integer.toHexString(resourceId);
                if (!hex.startsWith("7f")) {
                    return resourceName + "[01]";
                } else {
                    return resourceName;
                }
            } catch (Exception e) {
                return null;
            }
        }
    }

    private static ViewPath getViewPathInfo(View touchView, TouchRecord touchRecord, StringBuilder eventId) {
        ViewPath viewPath = new ViewPath();
        if (touchView instanceof WebView) {
            WebView webView = (WebView) touchView;
            String webUrl = webView.getUrl();
            if (!TextUtils.isEmpty(webUrl)) {
                Uri uri = Uri.parse(webUrl);
                viewPath.webUrl = uri.getScheme() + "://" + uri.getHost() + uri.getPath();
            }
            viewPath.inScrollableContainer = true;
        }

        boolean hasLastViewId = false;
        String listInfo = null;
        StringBuilder viewPathBuilder = new StringBuilder();
        do {
            ViewParent viewParent = touchView.getParent();
            if (viewParent instanceof ViewGroup) {
                ViewGroup viewGroup = (ViewGroup) viewParent;
                int index = viewGroup.indexOfChild(touchView);
                boolean isList = false;
                String positionInfo = null;
                if (touchRecord.isClick && viewParent instanceof AbsListView) {
                    viewPath.inScrollableContainer = true;
                    AbsListView listView = (AbsListView) viewParent;
                    int[] location = new int[2];
                    listView.getLocationOnScreen(location);
                    positionInfo = "l:" + listView.pointToPosition((int) touchRecord.mDownX - location[0], (int) touchRecord.mDownY - location[1]) + "," + index;
                    isList = true;
                    if (listInfo == null) {
                        listInfo = positionInfo;
                    } else {
                        listInfo += "," + positionInfo;
                    }
                } else if (touchRecord.isClick && viewParent instanceof RecyclerView) {
                    viewPath.inScrollableContainer = true;
                    RecyclerView recyclerView = (RecyclerView) viewParent;
                    positionInfo = "r:" + recyclerView.getChildAdapterPosition(touchView) + "," + index;
                    isList = true;
                    if (listInfo == null) {
                        listInfo = positionInfo;
                    } else {
                        listInfo += "," + positionInfo;
                    }
                } else if(touchRecord.isClick && viewParent instanceof ViewPager) {
                    viewPath.inScrollableContainer = true;
                    ViewPager viewPager = (ViewPager) viewParent;
                    positionInfo = "v:" + viewPager.getCurrentItem() + "," + index;
                    isList = true;
                    if (listInfo == null) {
                        listInfo = positionInfo;
                    } else {
                        listInfo += "," + positionInfo;
                    }
                } else if (viewParent instanceof ScrollView || viewParent instanceof HorizontalScrollView) {
                    viewPath.inScrollableContainer = true;
                }

                String resourceName = getResourceName(touchView.getContext(), touchView.getId());
                if (resourceName != null) {
                    viewPathBuilder.append(resourceName).append("/");
                    hasLastViewId = true;
                } else if (isList) {
                    viewPathBuilder.append("*").append("/"); // 替换符，保持vp一致，去vl取
                } else {
                    if (!hasLastViewId) {
                        viewPathBuilder.append(index).append("/");
                    }
                }
                touchView = viewGroup;
            } else {
                break;
            }
        } while (true);
        if (listInfo != null) {
            viewPath.listInfo = listInfo;
        }
        viewPath.path = viewPathBuilder.toString();
        return viewPath;
    }

    private static void getViewContent(View view, StringBuilder eventId) {
        List<ViewContent> viewInfoList = new ArrayList<>(10);
        getViewContent(view, viewInfoList, 10);
        if (viewInfoList.size() == 0) {
            return;
        }
        boolean hasText = false;
        boolean hasImage = false;
        for (ViewContent contentInfo : viewInfoList) {
            if (contentInfo.type == 1) {
                hasText = true;
                break;
            } else if (contentInfo.type == 2 || contentInfo.type == 3) {
                hasImage = true;
            }
        }

        if (hasText) {
            ViewContent maxContentInfo = null;
            ViewContent topLeftContentInfo = null;
            for (int i = 0; i < viewInfoList.size(); i++) {
                ViewContent contentInfo = viewInfoList.get(i);
                if (contentInfo.type == 1) {
                    if (maxContentInfo == null) {
                        maxContentInfo = contentInfo;
                        topLeftContentInfo = contentInfo;
                        continue;
                    }

                    if (contentInfo.fontSize > maxContentInfo.fontSize) {
                        maxContentInfo = contentInfo;
                    }

                    if ((contentInfo.location[0] * contentInfo.location[0] + contentInfo.location[1] * contentInfo.location[1]) <
                            (topLeftContentInfo.location[0] * topLeftContentInfo.location[0] + topLeftContentInfo.location[1] * topLeftContentInfo.location[1])) {
                        topLeftContentInfo = contentInfo;
                    }
                }
            }

            if (maxContentInfo == topLeftContentInfo) {
                eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_REFERENCE)
                        .append(PrismConstants.Symbol.DIVIDER_INNER).append(maxContentInfo.content);
            } else {
                eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_REFERENCE)
                        .append(PrismConstants.Symbol.DIVIDER_INNER).append(topLeftContentInfo.content)
                        .append(PrismConstants.Symbol.DIVIDER_INNER).append(maxContentInfo.content);
            }
        } else if (hasImage) {
            for (ViewContent contentInfo : viewInfoList) {
                if (contentInfo.type == 2 || contentInfo.type == 3) {
                    eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_REFERENCE)
                            .append(PrismConstants.Symbol.DIVIDER_INNER).append(contentInfo.content);
                    break;
                }
            }
        }
    }

    private static int getViewContent(View view, List<ViewContent> contentList, int count) {
        if (view.getVisibility() != View.VISIBLE) {
            return count;
        }

        if (view instanceof ViewGroup) {
            ViewGroup viewGroup = (ViewGroup) view;
            for (int i = 0; i < viewGroup.getChildCount(); i++) {
                View childView = viewGroup.getChildAt(i);
                count = getViewContent(childView, contentList, count);
                if (count == 0) {
                    return count;
                }
            }
        } else {
            if (view instanceof TextView) {
                TextView textView = (TextView) view;
                if (textView.getText() != null) {
                    String content = textView.getText().toString().trim();
                    if (!TextUtils.isEmpty(content)) {
                        ViewContent contentInfo = new ViewContent();
                        contentInfo.type = 1;
                        contentInfo.content = content;
                        contentInfo.fontSize = textView.getTextSize();
                        int[] location = new int[2];
                        textView.getLocationOnScreen(location);
                        contentInfo.location = location;
                        contentList.add(contentInfo);
                        count--;
                    }
                }
            }
        }
        return count;
    }

    private static void getQuadrant(Context context, TouchRecord touchRecord, StringBuilder eventId) {
        int centreX = getWindowWidth(context) / 2;
        int centreY = getWindowHeight(context) / 2;

        float x = touchRecord.mDownX;
        float y = touchRecord.mDownY;
        eventId.append(PrismConstants.Symbol.DIVIDER);
        if (x > centreX && y <= centreY) {
            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("1");
        } else if (x >= centreX && y > centreY) {
            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("2");
        } else if (x < centreX && y >= centreY) {
            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("3");
        } else if (x <= centreX && y < centreY) {
            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("4");
        }
    }

    public static int getWindowWidth(Context context) {
        if (mWindowWidth == -1) {
            initWindowDisplay(context);
        }
        return mWindowWidth;
    }

    public static int getWindowHeight(Context context) {
        if (mWindowHeight == -1) {
            initWindowDisplay(context);
        }
        return mWindowHeight;
    }

    private static void initWindowDisplay(Context context) {
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Point outSize = new Point();
        windowManager.getDefaultDisplay().getSize(outSize);
        mWindowWidth = outSize.x;
        mWindowHeight = outSize.y;
    }

}
