package com.xiaojuchefu.prism.playback;

import android.content.Context;
import android.graphics.Rect;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.collection.ArrayMap;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.playback.model.EventInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PlaybackHelper {

    public static boolean validateWindow(PrismWindow prismWindow, String windowData) {
        WindowManager.LayoutParams layoutParams = prismWindow.getWindow().getAttributes();
        String title = layoutParams.getTitle().toString().trim();
        String windowTitle = title.substring(title.indexOf("/") + 1);
        int windowType = layoutParams.type;

        String[] windowInfo = windowData.split(PrismConstants.Symbol.DIVIDER_INNER);
        return windowInfo[0].equals(windowTitle) && Integer.parseInt(windowInfo[1]) == windowType;
    }

    public static View findTargetView(PrismWindow prismWindow, EventInfo eventInfo) {
        HashMap<String, String> eventData = eventInfo.eventData;
        View targetView = null;
        String windowData = eventData.get(PrismConstants.Symbol.WINDOW);
        String viewId = eventData.get(PrismConstants.Symbol.VIEW_ID);
        String viewPath = eventData.get(PrismConstants.Symbol.VIEW_PATH);
        String viewList = eventData.get(PrismConstants.Symbol.VIEW_LIST);
        String viewReference = eventData.get(PrismConstants.Symbol.VIEW_REFERENCE);

        if (validateWindow(prismWindow, windowData)) {
            if (viewPath != null) {
                if (viewList != null) {
                    ViewGroup container = findTargetViewContainer(prismWindow.getDecorView(), viewPath, viewList);
                    if (container != null) {
                        String listData = viewList.split(",")[0];
                        String relativePath = viewPath.substring(0, viewPath.indexOf("*"));
                        int realItemPosition = Integer.parseInt(listData.split(":")[1]);
                        // 是否需要滚动
                        if (needScroll(container, realItemPosition)) {
                            smoothScrollToPosition(container, realItemPosition);
                            return null;
                        } else {
                            // 是否存在viewId
                            if (viewId != null) {
                                View itemView = findItemViewByPosition(container, realItemPosition);
                                if (itemView != null) {
                                    targetView = findTargetViewById(itemView, viewId, relativePath, viewReference);
                                    if (targetView != null) {
                                        smoothScrollToVisible(container, targetView);
                                        return targetView;
                                    }
                                }

                                for (int i = 0; i < container.getChildCount(); i++) {
                                    itemView = container.getChildAt(i);
                                    targetView = findTargetViewById(itemView, viewId, relativePath, viewReference);
                                    if (targetView != null) {
                                        smoothScrollToVisible(container, targetView);
                                        return targetView;
                                    }
                                }

                                return null; // 无法通过viewId查找到view，退出
                            }

                            // 通过相对path查找
                            targetView = findTargetViewByPath(container, relativePath);
                            if (targetView != null) {
                                smoothScrollToVisible(container, targetView);
                                return targetView;
                            } else {
                                return null; // 无法通过viewPath查找到view，退出
                            }
                        }
                    } else {
                        return null; // 无法查找到container，退出
                    }
                }

                if (viewId != null) { // 存在viewId
                    targetView = findTargetViewById(prismWindow.getDecorView(), viewId, viewPath, viewReference);
                    if (targetView != null) {
                        return needScrollOrNot(targetView);
                    }
                }

                targetView = findTargetViewByPath(prismWindow.getDecorView(), viewPath);
                if (targetView != null) {
                    return needScrollOrNot(targetView);
                }

                if (!TextUtils.isEmpty(viewReference)) {
                    targetView = findTargetViewByReference(prismWindow.getDecorView(), viewReference);
                    if (targetView != null) {
                        return needScrollOrNot(targetView);
                    }
                }

            }

        }
        return targetView;
    }

    private static View needScrollOrNot(View targetView) {
        View scrollableView = findScrollableView(targetView);
        if (scrollableView != null) {
            if (needScroll(scrollableView, targetView)) {
                smoothScrollToVisible(scrollableView, targetView);
                return null;
            }
        }
        return targetView;
    }

    private static View findTargetViewById(View view, String viewIdName, String viewPath, String viewReference) {
        Context context = view.getContext();
        int viewId = getResourceId(context, viewIdName, "id");
        if (viewId != 0) {
            ArrayMap<Integer, List<View>> allView = new ArrayMap<>();
            findAllViewById(view, viewId, 0, allView);
            if (allView.isEmpty()) {
                return null;
            }
            int minDep = Integer.MAX_VALUE;
            for (Integer dep : allView.keySet()) {
                if (dep < minDep) {
                    minDep = dep;
                }
            }
            List<View> possibleTargetViews = allView.get(minDep);
            return filterPossibleTargetView(possibleTargetViews, viewReference, viewPath, minDep);
        } else {
            return null;
        }
    }

    private static void findAllViewById(View view, int viewId, int dep, ArrayMap<Integer, List<View>> allView) {
        if (view.getId() == viewId) {
            List<View> views = allView.get(dep);
            if (views == null) {
                views = new ArrayList<>();
                allView.put(dep, views);
            }
            views.add(view);
            return;
        }

        if (view instanceof ViewGroup) {
            ViewGroup viewGroup = (ViewGroup) view;
            for (int i = 0; i < viewGroup.getChildCount(); i++) {
                View childView = viewGroup.getChildAt(i);
                if (childView.getVisibility() == View.VISIBLE) {
                    findAllViewById(childView, viewId, dep + 1, allView);
                    if (allView.containsKey(dep + 1)) {
                        break;
                    }
                }
            }
        }
    }

    private static View findTargetViewByPath(View view, String path) {
        String[] viewPath = path.split("/");
        int index = viewPath.length - 1;
        View targetView = view;
        while (index >= 0 && targetView instanceof ViewGroup) {
            ViewGroup parentView = (ViewGroup) targetView;
            String node = viewPath[index];
            String[] nodeInfo = node.split(",");
            if (nodeInfo.length == 2) {
                int position = Integer.parseInt(nodeInfo[0]);
                if (position < parentView.getChildCount()) {
                    targetView = parentView.getChildAt(position);
                } else {
                    return null;
                }
            } else {
                try {
                    int position = Integer.parseInt(node);
                    if (position < parentView.getChildCount()) {
                        targetView = parentView.getChildAt(position);
                    } else {
                        return null;
                    }
                } catch (Exception e) {
                    targetView = findTargetViewById(parentView, node, null, null);
                }
            }
            index--;
        }
        return targetView;
    }

    private static ViewGroup findTargetViewContainer(ViewGroup viewGroup, String viewPath, String viewList) {
        String[] viewPaths = viewPath.split("/");
        String[] viewLists = viewList.split(",");
        int listIndex = viewLists.length / 2;
        int pathIndex = viewPaths.length - 1;
        ViewGroup container = viewGroup;
        while (pathIndex >= 0) {
            String node = viewPaths[pathIndex];
            if (node.equals("*")) {
                listIndex--;
                if (listIndex == 0) {
                    break;
                } else {
                    node = viewLists[listIndex * 2 + 1];
                }
            }
            try {
                int position = Integer.parseInt(node);
                if (position < container.getChildCount()) {
                    View childView = container.getChildAt(position);
                    if (childView instanceof ViewGroup) {
                        container = (ViewGroup) childView;
                    } else {
                        return findPossibleContainerView(viewGroup);
                    }
                } else {
                    return findPossibleContainerView(viewGroup);
                }
            } catch (Exception e) {
                View view = findTargetViewById(container, node, null, null);
                if (view == null) {
                    return findPossibleContainerView(viewGroup);
                } else {
                    if (view instanceof ViewGroup) {
                        container = (ViewGroup) view;
                    } else {
                        return findPossibleContainerView(viewGroup);
                    }
                }
            }
            pathIndex--;
        }
        if (container instanceof RecyclerView || container instanceof AbsListView || container instanceof ViewPager) {
            return container;
        } else {
            return findPossibleContainerView(viewGroup);
        }
    }

    private static ViewGroup findPossibleContainerView(ViewGroup view) {
        if (view instanceof RecyclerView || view instanceof AbsListView || view instanceof ViewPager) {
            return view;
        }

        for (int i = 0; i < view.getChildCount(); i++) {
            View childView = view.getChildAt(i);
            if (childView instanceof ViewGroup && childView.getVisibility() == View.VISIBLE) {
                ViewGroup result = findPossibleContainerView((ViewGroup) childView);
                if (result != null) return result;
            }
        }
        return null;
    }

    private static View findItemViewByPosition(ViewGroup viewGroup, int position) {
        if (viewGroup instanceof RecyclerView) {
            RecyclerView recyclerView = (RecyclerView) viewGroup;
            for (int i = 0; i < recyclerView.getChildCount(); i++) {
                View itemView = recyclerView.getChildAt(i);
                if (position == recyclerView.getChildAdapterPosition(itemView)) {
                    return itemView;
                }
            }
        } else if (viewGroup instanceof ListView) {
            ListView listView = (ListView) viewGroup;
            for (int i = 0; i < listView.getChildCount(); i++) {
                View itemView = listView.getChildAt(i);
                Rect itemViewRect = new Rect();
                itemView.getLocalVisibleRect(itemViewRect);
                int itemViewPosition = listView.pointToPosition(itemViewRect.centerX(), itemViewRect.centerY());
                if (position == itemViewPosition) {
                    return itemView;
                }
            }
        } else if (viewGroup instanceof ViewPager) {
            ViewPager viewPager = (ViewPager) viewGroup;
            viewPager.setCurrentItem(position);
            if(position < viewPager.getChildCount() / 2) {
                return viewPager.getChildAt(position);
            } else {
                return viewPager.getChildAt(viewPager.getChildCount() / 2);
            }
        }
        return null;
    }

    private static boolean hasViewReference(View view, String viewReference) {
        String[] viewReferences = viewReference.split(PrismConstants.Symbol.DIVIDER_INNER);
        viewReference = viewReferences[viewReferences.length - 1]; //  存在多个时，默认取字体最大
        if (viewReference.startsWith("[r_image]") || viewReference.startsWith("[l_image]")) {
            return false;
        }

        View targetView = findTargetViewByReference(view, viewReference);
        return targetView != null;
    }

    private static View findTargetViewByReference(View view, String viewReference) {
        if (view instanceof ViewGroup) {
            ViewGroup viewGroup = (ViewGroup) view;
            for (int i = 0; i < viewGroup.getChildCount(); i++) {
                View childView = viewGroup.getChildAt(i);
                if (childView.getVisibility() == View.VISIBLE) {
                    View targetView = findTargetViewByReference(childView, viewReference);
                    if (targetView != null) return targetView;
                }
            }
        } else {
            if (view instanceof TextView) {
                TextView textView = (TextView) view;
                if (textView.getText() != null && viewReference.equals(textView.getText().toString().trim())) {
                    return view;
                }
            }
        }
        return null;
    }

    private static View filterPossibleTargetView(List<View> possibleTargetViews, String viewReference, String viewPath, int minDep) {
        if (possibleTargetViews != null) {
            if (possibleTargetViews.size() == 1) {
                return possibleTargetViews.get(0);
            } else {
                if (viewReference != null) {
                    int hasReferenceViewCount = 0;
                    View targetView = null;
                    for (int i = 0; i < possibleTargetViews.size(); i++) {
                        View possibleTargetView = possibleTargetViews.get(i);
                        boolean hasReference = hasViewReference(possibleTargetView, viewReference);
                        if (hasReference) {
                            hasReferenceViewCount++;
                            targetView = possibleTargetView;
                        }
                    }
                    if (hasReferenceViewCount == 1) {
                        return targetView;
                    }
                }

                if (viewPath != null) {
                    String[] viewPaths = viewPath.split("/");
                    if (minDep < viewPaths.length) {
                        String index = viewPaths[viewPaths.length - minDep - 1];
                        return possibleTargetViews.get(Integer.parseInt(index));
                    }
                }
            }
        }
        return null;
    }

    public static EventInfo convertEventInfo(EventData eventData) {
        EventInfo eventInfo = new EventInfo();
        String unionId = eventData.getUnionId();
        eventInfo.originData = unionId;
        String[] result = unionId.split("_\\^_");
        HashMap<String, String> keysMap = new HashMap<>(result.length);
        for (int i = 0; i < result.length; i++) {
            if (TextUtils.isEmpty(result[i])) {
                continue;
            }
            int index = result[i].indexOf(PrismConstants.Symbol.DIVIDER_INNER);
            if (index == -1) {
                continue;
            }
            String key = result[i].substring(0, index);
            String value = result[i].substring(index + 3);
            keysMap.put(key, value);
        }

        if (keysMap.containsKey(PrismConstants.Symbol.WINDOW)) {
            String windowData = keysMap.get(PrismConstants.Symbol.WINDOW);
            String[] windowInfo = windowData.split(PrismConstants.Symbol.DIVIDER_INNER);
            if (windowInfo.length > 1) {
                eventInfo.windowType = Integer.parseInt(windowInfo[1]);
            } else {
                eventInfo.windowType = 1;
            }
        } else {
            eventInfo.windowType = 1;
        }

        if (!keysMap.containsKey("e")) {
            return null;
        }

        eventInfo.eventData = keysMap;
        eventInfo.eventType = Integer.parseInt(keysMap.get("e"));
        switch (eventInfo.eventType) {
            case 0:
                eventInfo.eventDesc = "点击";
                break;
            case 1:
                eventInfo.eventDesc = "返回";
                break;
            case 2:
                eventInfo.eventDesc = "退至后台";
                break;
            case 3:
                eventInfo.eventDesc = "进入前台";
                break;
            case 4:
                eventInfo.eventDesc = "弹出弹窗";
                break;
            case 5:
                eventInfo.eventDesc = "弹窗关闭";
                break;
            case 6:
                eventInfo.eventDesc = "页面跳转";
                break;
        }
        return eventInfo;
    }

    public static int getResourceId(Context context, String resourceName, String resourceType) {
        if (resourceName.endsWith("[01]")) {
            return context.getResources().getIdentifier(resourceName.replace("[01]", ""), resourceType, "android");
        } else {
            return context.getResources().getIdentifier(resourceName, resourceType, context.getPackageName());
        }
    }

    public static boolean needScroll(View container, int realItemPosition) {
        if (container instanceof RecyclerView) {
            RecyclerView recyclerView = (RecyclerView) container;
            View firstItemView = recyclerView.getChildAt(0);
            int firstItemPosition = recyclerView.getChildLayoutPosition(firstItemView);
            View lastItemView = recyclerView.getChildAt(recyclerView.getChildCount() - 1);
            int lastItemPosition = recyclerView.getChildLayoutPosition(lastItemView);
            return realItemPosition < firstItemPosition || realItemPosition > lastItemPosition;
        } else if (container instanceof AbsListView) {
            AbsListView listView = (AbsListView) container;
            int firstItemPosition = listView.getFirstVisiblePosition();
            int lastItemPosition = listView.getLastVisiblePosition();
            return realItemPosition < firstItemPosition || realItemPosition > lastItemPosition;
        } else if (container instanceof ViewPager) {
            ViewPager viewPager = (ViewPager) container;
            return realItemPosition != viewPager.getCurrentItem();
        }
        return false;
    }

    public static boolean needScroll(View scrollableView, View targetView) {
        int[] targetViewLocation = new int[2];
        targetView.getLocationOnScreen(targetViewLocation);
        Rect targetViewRect = new Rect(targetViewLocation[0], targetViewLocation[1], targetViewLocation[0] + targetView.getWidth(), targetViewLocation[1] + targetView.getHeight());

        int[] scrollableViewLocation = new int[2];
        scrollableView.getLocationOnScreen(scrollableViewLocation);
        Rect scrollableViewRect = new Rect(scrollableViewLocation[0], scrollableViewLocation[1], scrollableViewLocation[0] + scrollableView.getWidth(), scrollableViewLocation[1] + scrollableView.getHeight());
        return !scrollableViewRect.contains(targetViewRect);
    }

    private static View findScrollableView(View targetView) {
        ViewGroup parentGroup = (ViewGroup) targetView.getParent();
        do {
            if (parentGroup.canScrollHorizontally(1) || parentGroup.canScrollHorizontally(-1)
                    || parentGroup.canScrollVertically(1) || parentGroup.canScrollVertically(-1)) {
                return parentGroup;
            } else {
                ViewParent viewParent = parentGroup.getParent();
                if (viewParent instanceof ViewGroup) {
                    parentGroup = (ViewGroup) viewParent;
                } else {
                    parentGroup = null;
                }
            }
        } while (parentGroup != null);
        return parentGroup;
    }

    public static void smoothScrollToPosition(View container, int position) {
        if (container instanceof RecyclerView) {
            RecyclerView recyclerView = (RecyclerView) container;
            recyclerView.smoothScrollToPosition(position);
        } else if (container instanceof AbsListView) {
            AbsListView listView = (AbsListView) container;
            listView.smoothScrollToPosition(position);
        } else if (container instanceof ViewPager) {
            ViewPager viewPager = (ViewPager) container;
            viewPager.setCurrentItem(position);
        }
    }

    public static void smoothScrollToVisible(View container, View targetView) {
        if (container instanceof ViewPager) {
            return;
        }

        int[] targetViewLocation = new int[2];
        targetView.getLocationOnScreen(targetViewLocation);
        int[] containerLocation = new int[2];
        container.getLocationOnScreen(containerLocation);

        Rect targetRect = new Rect(targetViewLocation[0], targetViewLocation[1], targetViewLocation[0] + targetView.getWidth(), targetViewLocation[1] + targetView.getHeight());
        Rect containerRect = new Rect(containerLocation[0], containerLocation[1], containerLocation[0] + container.getWidth(), containerLocation[1] + container.getHeight());
        int dx = 0;
        int dy = 0;
        if (containerRect.contains(targetRect)) { // 在内部
            if ((targetViewLocation[0] - containerLocation[0]) < container.getWidth() / 5) { // 在左边内
                dx = container.getWidth() / 5;
                dx = -dx;
            } else if ((targetViewLocation[0] - containerLocation[0]) > container.getWidth() * 4 / 5) { // 在右边内
                dx = container.getWidth() / 5;
            }
            if ((targetViewLocation[1] - containerLocation[1]) < container.getHeight() / 5) { // 在顶边内
                dy = container.getHeight() / 5;
                dy = -dy;
            } else if ((targetViewLocation[1] - containerLocation[1]) > container.getHeight() * 4 / 5) { // 在底边内
                dy = container.getHeight() / 5;
            }
        } else if (containerRect.intersect(targetRect)) { // 交叉
            if ((targetViewLocation[0] - containerLocation[0]) < container.getWidth() / 5) { // 在左边上
                dx = containerLocation[0] - targetViewLocation[0] + container.getWidth() / 5;
                dx = -dx;
            } else if ((targetViewLocation[0] - containerLocation[0]) > container.getWidth() * 4 / 5) { // 在左边上
                dx = targetViewLocation[0] - containerLocation[0] - container.getWidth() + container.getWidth() / 5 + targetView.getWidth();
            }
            if (targetViewLocation[1] <= containerLocation[1]) { // 在顶边上
                dy = containerLocation[1] - targetViewLocation[1] + container.getHeight() / 5;
                dy = -dy;
            } else if (targetViewLocation[1] > containerLocation[1]) { // 在底边上
                dy = targetViewLocation[1] - containerLocation[1] - container.getHeight() + container.getHeight() / 5 + targetView.getHeight();
            }
        } else { // 在外部
            if ((targetViewLocation[0] - containerLocation[0]) < 0) { // 在左边外
                dx = targetViewLocation[0] - containerLocation[0] + container.getWidth() / 5 + targetView.getWidth();
                dx = -dx;
            } else if ((targetViewLocation[0] - containerLocation[0]) > container.getWidth()) { // 在右边外
                dx = targetViewLocation[0] - (containerLocation[0] + targetView.getWidth()) + container.getWidth() / 5 + targetView.getWidth();
            }

            if (targetViewLocation[1] + targetView.getHeight() < containerLocation[1]) { // 在顶边外
                dy = containerLocation[1] - targetViewLocation[1] + container.getWidth() / 5 + targetView.getHeight();
                dy = -dy;
            } else if (targetViewLocation[1] > containerLocation[1] + container.getHeight()) { // 在底边外
                dy = targetViewLocation[1] - (containerLocation[1] + container.getHeight()) + container.getWidth() / 5 + targetView.getHeight();
            }
        }
        smoothScrollBy(container, dx, dy);
    }

    private static void smoothScrollBy(View container, int dx, int dy) {
        if (container instanceof RecyclerView) {
            RecyclerView recyclerView = (RecyclerView) container;
            recyclerView.smoothScrollBy(dx, dy);
        } else if (container instanceof AbsListView) {
            AbsListView listView = (AbsListView) container;
            listView.smoothScrollBy(dy, 100);
        } else if (container instanceof ScrollView) {
            ScrollView scrollView = (ScrollView) container;
            scrollView.smoothScrollBy(dx, dy);
        } else {
            container.scrollBy(dx, dy);
        }
    }

    public static View getClickableView(View view) {
        ViewGroup parentGroup = (ViewGroup) view.getParent();
        do {
            if (parentGroup.isClickable()) {
                return parentGroup;
            } else {
                ViewParent viewParent = parentGroup.getParent();
                if (viewParent instanceof ViewGroup) {
                    parentGroup = (ViewGroup) viewParent;
                } else {
                    break;
                }
            }
        } while (true);
        return view;
    }

    public static String getClickInfo(EventInfo eventInfo) {
        String contentData = eventInfo.eventData.get(PrismConstants.Symbol.VIEW_REFERENCE);
        if (TextUtils.isEmpty(contentData)) {
            contentData = eventInfo.eventData.get("vc");
            if (TextUtils.isEmpty(contentData)) {
                return getClickInfoPossible(eventInfo);
            }
        }
        String[] contents = contentData.split(PrismConstants.Symbol.DIVIDER_INNER);
        for (int i = 0; i < contents.length; i++) {
            String content = contents[i];
            if (content.startsWith("[l_image]")) {
                return content.replace("[l_image]", "");
            } else if (content.startsWith("[r_image]")) {
                return content.replace("[r_image]", "");
            } else {
                return content;
            }
        }
        return "";
    }

    private static String getClickInfoPossible(EventInfo eventInfo) {
        HashMap<String, String> keyValues = eventInfo.eventData;
        if (keyValues.containsKey(PrismConstants.Symbol.VIEW_ID) && keyValues.containsKey(PrismConstants.Symbol.VIEW_QUADRANT)) {
            int quadrant = Integer.parseInt(keyValues.get(PrismConstants.Symbol.VIEW_QUADRANT));
            String viewId = keyValues.get("vi");
            if (quadrant == 4) {
                if (viewId.contains("_back")) {
                    return "(左上角 返回)";
                } else if (viewId.contains("_close")) {
                    return "(左上角 关闭)";
                }
            }
        }

        if (keyValues.containsKey(PrismConstants.Symbol.VIEW_LIST)) {
            String listInfo = keyValues.get(PrismConstants.Symbol.VIEW_LIST);
            String positionInfo = listInfo.split(":")[1];
            String position = positionInfo.split(",")[0];
            return "(点击列表第 " + (Integer.parseInt(position) + 1) + " 位)";
        }

        return "(无法识别)";
    }
}
