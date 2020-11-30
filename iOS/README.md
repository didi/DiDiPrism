# iOS 使用手册
## 安装说明
```
pod 'DiDiPrism'
```

## 代码目录说明
- Ability （功能区）
    - BehaviorDetect （操作检测模块）
    - BehaviorReplay （操作回放模块）
- Category （分类区）
- Core （核心区）
    - Instruction （指令模块，含指令定义、生成、解析等）
    - Intercept （拦截模块，含触控拦截、请求拦截、事件监听等）
- Util （工具区）

## 代码使用说明
### 操作回放
```
// No.1 监听NSNotification获取操作行为指令，构造 PrismBehaviorListModel 实例。
// name: @"prism_new_instruction_notification" , userInfo: @{@"instruction": @"指令内容", @"params": @"参数"}

// No.2-1 通过 PrismBehaviorReplayManager 单例进行视频回放的开始、继续、暂停、结束操作。

// No.2-2 通过 PrismBehaviorListModel 实例的 instructionTextArray 属性获取文字回放的具体内容。
```

### 操作检测
```
// No.1 通过 PrismBehaviorDetectManager 单例的 setupWithConfigModel: 方法加载策略配置，进入检测模式。

// No.2 监听NSNotification获取操作行为指令。
// name: @"prism_new_instruction_notification" , userInfo: @{@"instruction": @"指令内容", @"params": @"参数"}

// No.3 通过 PrismBehaviorDetectManager 单例的 addInstruction:withParams: 方法传入指令，进行实时行为检测。
```
