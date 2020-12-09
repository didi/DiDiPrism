# 小桔棱镜 Android SDK

* prism-monitor模块负责采集操作行为
* prism-playback模块负责操作行为回放
* prism-behavior模块负责操作行为检测

## prism-monitor使用说明

```
// 在Application创建时期初始化
PrismMonitor.getInstance().init(application);
// 开始并设置监听事件
PrismMonitor.getInstance().start();
PrismMonitor.getInstance().addOnPrismMonitorListener(new PrismMonitor.OnPrismMonitorListener() {
    @Override
    public void onEvent(EventData eventData) {
        // 可以通过此方法获取事件信息，比如文字回放等，具体使用请查看demo。
        EventInfo eventInfo = PlaybackHelper.convertEventInfo(eventData);
    }
});
```

## prism-playback使用说明

```
// 在Application创建时期初始化
PrismPlayback.getInstance().init(this);

//通过PrismMonitor监听采集操作数据
List<EventData> mPlaybackEvents = ...;
//开启回放
PrismPlayback.getInstance().playback(mPlaybackEvents);
```

## prism-behavior使用说明

```
// 在Application创建时期初始化
PrismBehavior.getInstance().init(this);

// 设置行为规则
// 当操作行为符合某行为规则的时候，会发送action为prism_behavior_detect_rule_hit的广播。
PrismBehavior.getInstance().setRules(...);
// 开启检测
PrismBehavior.getInstance().start();
// 关闭检测
PrismBehavior.getInstance().stop();

```

# 原理介绍。

Android端主要采集用户的点击操作，以及与App界面变化相关的事件（前后台切换、页面进出、弹框等），这里不包括滑动等其他一些比较复杂的手势（因为目前能挖掘的业务价值较小）。

比较有挑战的是点击操作的采集，因为我们需要：

 1. 获取被点击的view
 2. 根据view生成唯一标识


## 1. 获取被点击的view

简单列一下目前一些主流方案：
	
* 遍历Activity视图中所有的view，给View设置AccessibilityDelegate
* 通过ASM给click等事件插入代码
* 通过继承baseActivity或baseDialog的方式，在dispatchTouchEvent ACTION_DOWN时，结合TouchTarget获取

这里不分析各主流方案的利弊，只介绍小桔棱镜的所采用的方式。

小桔棱镜采用的方案和最后一种方案类似，但不是通过baseActivity或baseDialog的方式，而是通过监听Window。Window.Callback可能大家不是特别熟悉，通过给Window setCallback可以拿到`dispatchTouchEvent`和`dispatchKeyEvent`两个回调事件。

* `dispatchTouchEvent`   在ACTION_DOWN时，结合TouchTarget可以获取到被点击的view。
* `dispatchKeyEvent`  可以获取到返回键等事件。

接下里的问题就在于 **如何监听Window？** 

关于Window，可以与`WindowManagerImpl`联系起来，因为它管理着App所有的Window实例，Window实例的实体其实就是View类型。可以看下`WindowManagerImpl`的源码：

```
public final class WindowManagerImpl implements WindowManager {
    ...
    private final WindowManagerGlobal mGlobal = WindowManagerGlobal.getInstance();
    ...
    @Override
    public void addView(@NonNull View view, @NonNull ViewGroup.LayoutParams params) {
        applyDefaultToken(params);
        mGlobal.addView(view, params, mContext.getDisplay(), mParentWindow);
    }
    ...
}
```

通过源码发现，Window实例的实体view被添加进`mGlobal`，继续看`WindowManagerGlobal`的源码：

```
public final class WindowManagerGlobal {
	...
	private final ArrayList<View> mViews = new ArrayList<View>();
	...
	public void addView(View view, ViewGroup.LayoutParams params, Display display, Window parentWindow) {
		...
		mViews.add(view);
		...
    }
    ...
}
```

发现实体view最终被添加进`mViews`，接下来，我们可以反射这个`mViews`，将其改造为可监听的对象，比如：

```
public class WindowObserver extends ArrayList<View> {
    @Override
    public boolean add(View view) {
        // ...
        return super.add(view);
    }
    
    @Override
    public View remove(int index) {
        // ...
        return super.remove(index);
    }
}
```

这样一来，App每个Window展示的时候，我们就能第一时间获取到该Window实例的实体view。
接下来，我们再通过实体view反向拿到Window实例。通过断点，会发现这个view当为Activity或Dialog的window实例时，它就是`DecorView`。对于它应该相当的熟悉！看下它的源码：

```
public class DecorView extends FrameLayout implements RootViewSurfaceTaker, WindowCallbacks {
    ...
    private PhoneWindow mWindow;
    ...
}
```

看到没，它直接持有window实例！我们反射直接去拿！

如此这般操作后，我们拿到了window实例，就可以setCallback，获取到所有用户操作的dispatchTouchEvent和dispatchKeyEvent回调事件，进而获取被点击的view，顺便也获取到了返回键等事件。

## 2. 根据view生成唯一标识
目前一些主流方案会将一些关键信息按约定的格式组合而成，作为唯一标识。这些关键信息有：Activity类名、View Id或Resource Id名称、View Class名称、View Path等。不同方案有不同的考量，优化的方式也不同。
下面就从三个维度，介绍下小桔棱镜的做法：

**2.1 被点击view所在窗口信息**
我们并没有直接使用Activity类名，因为被点击的view除了发生在Activity中，还有发生在Dialog，所以我们加了一层窗口的逻辑，也就是窗口的类型，使用`w`表示窗口信息，格式如下：
`w_&_{窗口名称}_&_{窗口类型}`，窗口名称其实也就是Activity类名，窗口类型有0或1，表示Activity或Dialog，由`_&_`连接，比如 `w_&_com.prism.MainActivity_&_0`。

**2.2 被点击view在ViewTree上的路径信息**
我们不记录每个view层级上的View Class名称或者index，只会记录关键层级，使用`vp`表示View Path信息。举几个例子：

* 当层级上的view能获取到view id时，比如：
`vp_&_titlebar_item_left_back/thanos_title_bar/content[01]/`，其中`content[01]`表示系统自带的那个`android.R.id.content`，通过`[01]`区别。

* 当层级上的view类型有`AbsListView`或`RecyclerView`时，比如：
`vp_&_*/listView/navigation_drawer/drawer_layout/content[01]/_^_vl_&_l:4,10`，其中`*`表示被点击的那个ListView item层级，另外使用`vl`来描述可复用容器item的信息，`l:4,10`表示AbsListView容器中第4位，在数据源中第10位。

**2.3 被点击view自身可提取的信息**
* 当view存在id时，使用`vi`表示id信息，比如：`vi_&_titlebar_item_left_back`
* 当view存在drawable等资源时，使用`vr`表示资源信息，比如：`vr_&_selector_btn_confirm`
* 当view存在可提取文本信息时，使用`vc`表示文本信息，比如：`vc_&_确定`

最后，将以上三个维度提取的信息通过`_^_`连接起来，作为被点击view唯一标识，比如`w_&_com.prism.MainActivity_&_0_^_vp_&_titlebar_item_left_back/thanos_title_bar/content[01]/_^_vi_&_titlebar_item_left_back_^_vc_&_确定`。
