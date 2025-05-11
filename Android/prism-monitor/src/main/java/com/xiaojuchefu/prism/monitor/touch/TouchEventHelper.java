package com.xiaojuchefu.prism.monitor.touch;

import android.content.Context;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.AbsListView;
import android.widget.EditText;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.handler.IViewContainerHandler;
import com.xiaojuchefu.prism.monitor.handler.IViewContentHandler;
import com.xiaojuchefu.prism.monitor.handler.IViewTagHandler;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.monitor.model.ViewContainer;
import com.xiaojuchefu.prism.monitor.model.ViewContent;
import com.xiaojuchefu.prism.monitor.model.ViewPath;
import com.xiaojuchefu.prism.monitor.model.ViewTag;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class TouchEventHelper {

    private static final int PRISM_INSTRUCTION_AREA_UNKNOWN = 0;
    private static final int PRISM_INSTRUCTION_AREA_CENTER = 1;
    private static final int PRISM_INSTRUCTION_AREA_UP = 2;
    private static final int PRISM_INSTRUCTION_AREA_BOTTOM = 3;
    private static final int PRISM_INSTRUCTION_AREA_LEFT = 4;
    private static final int PRISM_INSTRUCTION_AREA_RIGHT = 5;
    //    private static final int PRISM_INSTRUCTION_AREA_UPLEFT = 8;
//    private static final int PRISM_INSTRUCTION_AREA_UPRIGHT = 10;
//    private static final int PRISM_INSTRUCTION_AREA_BOTTOMLEFT = 12;
//    private static final int PRISM_INSTRUCTION_AREA_BOTTOMRIGHT = 15;
    private static final int PRISM_INSTRUCTION_AREA_CANSCROLL = 100;

    private static int mWindowWidth = -1;
    private static int mWindowHeight = -1;

    public static EventData createEventData(Window window, View touchView, TouchRecord touchRecord) {
        if (touchView == null) {
            return null;
        }

        EventData eventData = new EventData(PrismConstants.Event.TOUCH);
        eventData.view = touchView;

        StringBuilder eventId = new StringBuilder();
        getWindowInfo(window, eventData, eventId);
        ViewPath viewPath = getViewPathInfo(touchView, touchRecord, eventData);
        if (viewPath.viewContainer != null) { // containerView
            ViewContainer viewContainer = viewPath.viewContainer;
            eventId.append(PrismConstants.Symbol.DIVIDER).append(viewContainer.symbol).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewContainer.url);
        } else if (!TextUtils.isEmpty(viewPath.webUrl)) { // webview
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.WEB_URL).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.webUrl);
            eventData.wu = viewPath.webUrl;
        } else { // native
            getViewId(touchView, eventId, eventData);
        }

        getViewTag(touchView, eventData, eventId);

        eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_PATH).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.path);
        eventData.vp = viewPath.path;
        if (!TextUtils.isEmpty(viewPath.listInfo)) { // in list container view
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_LIST).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewPath.listInfo);
            eventData.vl = viewPath.listInfo;
        }

        // view content
        if (touchRecord.isClick && TextUtils.isEmpty(viewPath.webUrl)) {
            getViewContent(touchView, eventId,eventData);
        }
        // quadrant

        try {
            getQuadrant(touchView.getContext(), touchView, viewPath.inScrollableContainer, touchRecord, eventId, eventData);
        } catch (Throwable e) {
        }

        eventData.eventId = eventId.toString();
        if (PrismMonitor.getInstance().isTest()) {
            if (eventData.data == null) {
                eventData.data = new HashMap<>();
            }
            eventData.data.put("motion", getMotion(touchRecord));
            eventData.data.put("block", getBlock(window, touchView));
        }
        return eventData;
    }

    private static void getWindowInfo(Window window, EventData eventData, StringBuilder eventId) {
        try {
            StringBuilder w = new StringBuilder();
            eventId.append(PrismConstants.Symbol.WINDOW);
            eventId.append(PrismConstants.Symbol.DIVIDER_INNER);
            // window title
            String title = window.getAttributes().getTitle().toString().trim();
            String pageName = title.substring(title.indexOf("/") + 1);
            w.append(pageName);
            w.append(PrismConstants.Symbol.DIVIDER_INNER);
            // window type
            w.append(window.getAttributes().type);
            String ws = w.toString();
            eventId.append(ws);
            eventData.w = ws;

            if (eventData.data == null) {
                eventData.data = new HashMap<>();
            }
            eventData.data.put("pageName", "native" + PrismConstants.Symbol.DIVIDER_INNER + pageName);
        } catch (Throwable e) {
        }
    }

    private static void getViewId(View touchView, StringBuilder eventId, EventData eventData) {
        String viewIdName = getResourceName(touchView.getContext(), touchView.getId());
        if (viewIdName != null) {
            eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_ID).append(PrismConstants.Symbol.DIVIDER_INNER).append(viewIdName);
            eventData.vi = viewIdName;
        }
    }

    private static void getViewTag(View touchView, EventData eventData, StringBuilder eventId) {
        IViewTagHandler viewTagHandler = PrismMonitor.getInstance().getViewTagHandler();
        if (viewTagHandler != null) {
            ViewTag[] viewTags = viewTagHandler.getViewTags();
            if (viewTags != null && viewTags.length > 0) {
                StringBuilder tagInfo = new StringBuilder();
                for (ViewTag viewTag : viewTags) {
                    Object object = touchView.getTag(viewTag.tagId);
                    if (object != null) {
                        if (viewTag.append) {
                            tagInfo.append(PrismConstants.Symbol.DIVIDER_INNER);
                            tagInfo.append(viewTag.tagSymbol);
                            tagInfo.append(PrismConstants.Symbol.DIVIDER_INNER);
                            tagInfo.append(object);
                        } else {
                            if (eventData.data == null) {
                                eventData.data = new HashMap<>();
                            }
                            eventData.data.put(viewTag.tagSymbol, object);
                        }
                    }
                }
                if (tagInfo.length() > 0) {
                    eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_TAG).append(tagInfo);
                    eventData.vf = tagInfo.toString();
                }
            }
        } else {
            StringBuilder vfBuilder = new StringBuilder(touchView.getClass().getSimpleName());
            do {
                ViewParent viewParent = touchView.getParent();
                if (viewParent instanceof ViewGroup) {
                    ViewGroup viewGroup = (ViewGroup) viewParent;
                    vfBuilder.insert(0,PrismConstants.Symbol.DIVIDER_INNER);
                    vfBuilder.insert(0,viewGroup.getClass().getSimpleName());
                    touchView = viewGroup;
                } else {
                    break;
                }
            } while (true);
            if (vfBuilder.length() > 0) {
                eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_TAG).append(PrismConstants.Symbol.DIVIDER_INNER).append(vfBuilder);
                eventData.vf = vfBuilder.toString();
            }
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

    private static ViewPath getViewPathInfo(View touchView, TouchRecord touchRecord, EventData eventData) {
        ViewPath viewPath = new ViewPath();
        try {
            if (touchView instanceof WebView) {
                WebView webView = (WebView) touchView;
                String webUrl = webView.getUrl();
                if (!TextUtils.isEmpty(webUrl)) {
                    Uri uri = Uri.parse(webUrl);
                    viewPath.webUrl = uri.getScheme() + "://" + uri.getHost() + uri.getPath();

                    if (eventData.data == null) {
                        eventData.data = new HashMap<>();
                    }
                    eventData.data.put("pageName", "h5" + PrismConstants.Symbol.DIVIDER_INNER + webUrl);
                }
                viewPath.inScrollableContainer = true;
            }

            boolean hasLastViewId = false;
            String listInfo = null;
            StringBuilder viewPathBuilder = new StringBuilder();
            IViewContainerHandler viewContainerHandler = PrismMonitor.getInstance().getViewContainerHandler();
            do {
                ViewParent viewParent = touchView.getParent();
                if (viewParent instanceof ViewGroup) {
                    ViewGroup viewGroup = (ViewGroup) viewParent;
                    int index = viewGroup.indexOfChild(touchView);
                    boolean isList = false;
                    String positionInfo = null;
                    if (viewContainerHandler != null && viewContainerHandler.handleContainer(viewGroup)) {
                        ViewContainer viewContainer = new ViewContainer();
                        String url = viewContainerHandler.getContainerUrl(viewGroup);
                        viewContainer.url = Uri.parse(url).getPath();
                        viewContainer.symbol = viewContainerHandler.getContainerSymbol(viewGroup);
                        viewPath.viewContainer = viewContainer;
                        String resourceName = getResourceName(touchView.getContext(), touchView.getId());
                        viewPathBuilder.append(resourceName != null ? resourceName : index).append("/");
                        if (eventData.data == null) {
                            eventData.data = new HashMap<>();
                        }
                        if ("tp".equals(viewContainer.symbol)) {
                            eventData.data.put("pageName", "thanos" + PrismConstants.Symbol.DIVIDER_INNER + url);
                        } else {
                            eventData.data.put("pageName", viewContainer.symbol + PrismConstants.Symbol.DIVIDER_INNER + url);
                        }
                        break;
                    } else if (touchRecord.isClick && viewParent instanceof AbsListView) {
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
                        viewPathBuilder.append(index).append("/");
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
        } catch (Throwable e) {
        }
        return viewPath;
    }

    private static void getViewContent(View view, StringBuilder eventId, EventData eventData) {
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
                eventData.vr = maxContentInfo.content;
            } else {
                StringBuilder vr = new StringBuilder();
                vr.append(topLeftContentInfo.content).append(PrismConstants.Symbol.DIVIDER_INNER).append(maxContentInfo.content);

                eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_REFERENCE)
                        .append(PrismConstants.Symbol.DIVIDER_INNER).append(vr.toString());
                eventData.vr = vr.toString();
            }
        } else if (hasImage) {
            for (ViewContent contentInfo : viewInfoList) {
                if (contentInfo.type == 2 || contentInfo.type == 3) {
                    eventId.append(PrismConstants.Symbol.DIVIDER).append(PrismConstants.Symbol.VIEW_REFERENCE)
                            .append(PrismConstants.Symbol.DIVIDER_INNER).append(contentInfo.content);
                    eventData.vr = contentInfo.content;
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
                String content = "";

                if(view instanceof EditText) {
                    EditText editText = (EditText) view;
                    if (editText.getHint() != null) {
                        content = editText.getHint().toString().trim();
                    }
                } else {
                    if (textView.getText() != null) {
                        content = textView.getText().toString().trim();
                    } else if (textView.getHint() != null) {
                        content = textView.getHint().toString().trim();
                    }
                }

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
            } else if (view instanceof ImageView) {
                ImageView imageView = (ImageView) view;
                String content = parseImageView(imageView);
                if (!TextUtils.isEmpty(content)) {
                    ViewContent contentInfo = new ViewContent();
                    contentInfo.type = 2;
                    contentInfo.content = content;
                    int[] location = new int[2];
                    imageView.getLocationOnScreen(location);
                    contentInfo.location = location;
                    contentList.add(contentInfo);
                    count--;
                }
            } else {
                IViewContentHandler viewContentHandler = PrismMonitor.getInstance().getViewContentHandler();
                if (viewContentHandler != null) {
                    ViewContent viewContent = viewContentHandler.getContent(view);
                    if (viewContent != null) {
                        contentList.add(viewContent);
                        count--;
                    }
                }
            }
        }
        return count;
    }

    private static String parseImageView(ImageView imageView) {
        StringBuilder content = new StringBuilder("[ly_image]");
        // 无法通过getChangingConfigurations方式拿到资源id反而会因为catch异常降低性能，反射方案尝试失败，并没有相关的变量帮助缓存资源id
        // todo 后续尝试插桩方案
//        if (imageView.getDrawable() != null && imageView.getDrawable().getConstantState() != null) {
//            try {
//                // 资源id
//                Drawable.ConstantState constantState = imageView.getDrawable().getConstantState();
//                int resId = constantState.getChangingConfigurations();
//                String resName = imageView.getResources().getResourceEntryName(resId);
//                if (!TextUtils.isEmpty(resName)) {
//                    content = content.append(resName);
//                    return content.toString();
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
        try {
            // 控件id
            int layoutId = imageView.getId();
            String idName = imageView.getResources().getResourceEntryName(layoutId);
            if (!TextUtils.isEmpty(idName)) {
                content = content.append(idName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return content.toString();
    }

    private static void getQuadrant(Context context,  View touchView, boolean inScrollableContainer,TouchRecord touchRecord, StringBuilder eventId, EventData eventData) {
        int centreX = getWindowWidth(context) / 2;
        int centreY = getWindowHeight(context) / 2;

        eventId.append(PrismConstants.Symbol.DIVIDER);
        if(!inScrollableContainer) {
            int[] location = new int[2];
            touchView.getLocationInWindow(location);
            int vx = location[0];
            int vy = location[1];
            int vw = touchView.getWidth();
            int vh = touchView.getHeight();
            int vCentreX = vx + vw / 2;
            int vCentreY = vy + vh / 2;

            int horizontalValue = PRISM_INSTRUCTION_AREA_UNKNOWN;
            if (vCentreX == centreX) {
                horizontalValue = PRISM_INSTRUCTION_AREA_CENTER;
            }
            else if (vCentreX < centreX) {
                horizontalValue = PRISM_INSTRUCTION_AREA_LEFT;
            }
            else {
                horizontalValue = PRISM_INSTRUCTION_AREA_RIGHT;
            }
            int verticalValue = PRISM_INSTRUCTION_AREA_UNKNOWN;
            if (vCentreY == centreY) {
                verticalValue = PRISM_INSTRUCTION_AREA_CENTER;
            }
            else if (vCentreY < centreY) {
                verticalValue = PRISM_INSTRUCTION_AREA_UP;
            }
            else {
                verticalValue = PRISM_INSTRUCTION_AREA_BOTTOM;
            }

            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append(horizontalValue * verticalValue);
            eventData.vq = String.valueOf(horizontalValue * verticalValue);
//            float x = touchRecord.mDownX;
//            float y = touchRecord.mDownY;
//            if (x > centreX && y <= centreY) {
//                eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("1");
//            } else if (x >= centreX && y > centreY) {
//                eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("2");
//            } else if (x < centreX && y >= centreY) {
//                eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("3");
//            } else if (x <= centreX && y < centreY) {
//                eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append("4");
//            }
        } else {
            eventId.append(PrismConstants.Symbol.VIEW_QUADRANT).append(PrismConstants.Symbol.DIVIDER_INNER).append(PRISM_INSTRUCTION_AREA_CANSCROLL);
            eventData.vq = String.valueOf(PRISM_INSTRUCTION_AREA_CANSCROLL);
        }
    }

    private static String getMotion(TouchRecord touchRecord) {
        StringBuilder motion = new StringBuilder();
        motion.append(String.format("%.1f", touchRecord.mDownX)).append(",").append(String.format("%.1f", touchRecord.mDownY));
        if (!touchRecord.isClick) {
            for (int i = 0; i < touchRecord.mMoveTouch.size(); i++) {
                TouchRecord.MoveTouch moveTouch = touchRecord.mMoveTouch.get(i);
                motion.append(",").append(String.format("%.1f", moveTouch.mMoveX))
                        .append(",").append(String.format("%.1f", moveTouch.mMoveY))
                        .append(",").append(moveTouch.mMoveTime);
            }
            motion.append(",").append(String.format("%.1f", touchRecord.mUpX))
                    .append(",").append(String.format("%.1f", touchRecord.mUpY))
                    .append(",").append(touchRecord.mUpTime);
        }
        return motion.toString();
    }

    private static String getBlock(Window window, View touchView) {
        try {
            StringBuilder block = new StringBuilder();
            // window width
            block.append(window.getDecorView().getWidth());
            block.append(",");
            // window height
            block.append(window.getDecorView().getHeight());
            block.append(PrismConstants.Symbol.DIVIDER_INNER);
            // window location
            int[] outLocation = new int[2];
            window.getDecorView().getLocationOnScreen(outLocation);
            block.append(outLocation[0]);
            block.append(",");
            block.append(outLocation[1]);
            block.append(PrismConstants.Symbol.DIVIDER);

            // touchView width
            block.append(touchView.getWidth());
            block.append(",");
            // touchView height
            block.append(touchView.getHeight());
            block.append(PrismConstants.Symbol.DIVIDER_INNER);
            // touchView location
            touchView.getLocationOnScreen(outLocation);
            block.append(outLocation[0]);
            block.append(",");
            block.append(outLocation[1]);
            block.append(PrismConstants.Symbol.DIVIDER);
            return block.toString();
        } catch (Throwable e) {
            return "";
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

    private static Object getImageViewFieldValue(ImageView imageView, String fName) {
        Class imageViewClass = imageView.getClass();

        Field field = null;
        while (imageViewClass != null) {
            try {
                field = imageViewClass.getDeclaredField(fName);
                field.setAccessible(true);
            } catch (NoSuchFieldException e) {
//                e.printStackTrace();
            }
            if(null != field) break;
            imageViewClass = imageViewClass.getSuperclass();
        }

        if(null != field) {
            try {
                Object fObject = field.get(imageView);
                return fObject;
            } catch (IllegalAccessException e) {
            }
        }
        return null;
    }
}
