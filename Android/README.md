# 小桔棱镜 Android SDK

* prism-monitor模块负责收集用户操作行为
* prism-playback模块负责用户操作行为回放
* prism-behavior模块负责用户操作行为检测

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

//通过PrismMonitor监听获取数据
List<EventData> mPlaybackEvents = ...;
//开启回放
PrismPlayback.getInstance().playback(mPlaybackEvents);
```

## prism-behavior使用说明

```
// 在Application创建时期初始化
PrismBehavior.getInstance().init(this);

// 设置行为规则
// 当用户操作符合某行为规则的时候，会发送action为prism_behavior_detect_rule_hit的广播。
PrismBehavior.getInstance().setRules(...);
// 开启检测
PrismBehavior.getInstance().start();
// 关闭检测
PrismBehavior.getInstance().stop();

```