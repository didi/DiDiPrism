# iOS 使用手册
## 安装说明
```
pod 'DiDiPrism', :subspecs => ['Core', 'WithBehaviorRecord', 'WithBehaviorReplay', 'WithBehaviorDetect', 'WithDataVisualization']

// 其中：
// WithBehaviorRecord 为操作采集模块。
// WithBehaviorReplay 为操作回放模块。
// WithBehaviorDetect 为操作检测模块。
// WithDataVisualization 为数据可视化模块。
```

## 代码目录说明
- Ability （功能区）
    - BehaviorRecord （操作采集）
    - BehaviorReplay （操作回放）
    - BehaviorDetect （操作检测）
    - DataVisualization （数据可视化）
- Core （核心区）
    - Instruction （指令模块，含指令定义、生成、解析等）
    - Intercept （拦截模块，含触控拦截、请求拦截、事件监听等）
    - EventDispatcher （事件分发）
- Protocol （协议层）
- Adapter （适配层）
- Category （分类区）
- Util （工具区）

## 代码使用说明
### 初始化
```
// 定制需要关注的事件类型。
[PrismEngine startEngineWithEventCategorys:];
```

### 操作采集
```
// No.1 通过 PrismBehaviorRecordManager 单例进行模块的初始化。

// No.2 监听NSNotification获取操作行为指令。
// name: @"prism_new_instruction_notification" , userInfo: @{@"instruction": @"指令内容", @"params": @"参数"}
```
### 操作回放
```
// No.1 通过 PrismBehaviorReplayManager 单例进行模块的初始化，以及视频回放的开始、继续、暂停、结束操作。

// No.2 可通过 PrismBehaviorListModel 实例的 instructionTextArray 属性获取文字回放的具体内容。
```

### 操作检测
```
// No.1 通过 PrismBehaviorDetectManager 单例的 setupWithConfigModel: 方法加载策略配置，进入检测模式。

// No.2 监听NSNotification获取操作行为指令。
// name: @"prism_new_instruction_notification" , userInfo: @{@"instruction": @"指令内容", @"params": @"参数"}

// No.3 通过 PrismBehaviorDetectManager 单例的 addInstruction:withParams: 方法传入指令，进行实时行为检测。
```

### 数据可视化
```
// No.1 通过 PrismDataVisualizationManager 单例进行模块的初始化，以及可视化组件的注册与卸载。

// No.2 通过 PrismAdapter 封装的宏定义来管理界面元素与埋点的绑定关系。
```
