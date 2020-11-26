<p align="center">
<img src="https://view.didistatic.com/static/dcms/3pwfxb14rkgrmu55g_288x288.png" alt="小桔棱镜" title="小桔棱镜" width="288"/>
</p>

<p align="center">
  <a href="https://github.com/didichuxing/DiDiPrism/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-Apache-blue.svg" />
  </a>
  
  <a href="">
    <img src="https://img.shields.io/badge/platform-ios%20%7C%20android-lightgray.svg" />
  </a>

  <a href="">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome!" />
  </a>
</p>

**DiDiPrism**，中文名：**小桔棱镜**，是一款专注于移动端用户行为分析的工具，涵盖移动端用户`行为回放`、`行为检测`、`数据可视化`，以及PC端的`用户行为分析平台`，意在最大限度的挖掘移动端用户行为数据的价值。

## 方案亮点
- [x] **零入侵**

业务代码无需任何适配。

- [x] **高可用**

已在各种生产环境平稳运行一年以上。

- [x] **自研行为标识指令**

支撑棱镜已有功能外，或许可以有更大的舞台。

- [x] **功能丰富**

针对移动端用户行为全方位能力覆盖，期望最大限度挖掘行为数据价值。

## 为何诞生？
刷过《神探夏洛克》的同学都会惊叹于Sherlock从对方的一举一动中提取关键信息的画面：

<img src="https://view.didistatic.com/static/dcms/1jt5qoatskemik6cu_558x312.jpeg" width="372" hegiht="208" align=center />

而移动端作为我们与用户交流的几乎唯一载体，其上也承载着很多我们未发觉但很有价值的信息，小到用户一次细微操作暴露出的体验问题，大到对用户的产品偏好、使用习惯、消费意愿的感知，都是值得我们去深度挖掘的，那我们如何才能拥有这样的能力呢？仿佛是有千万个Sherlock在时刻帮我们贴身观察千万个用户一样，**小桔棱镜就为此而生**。

## 用它能做什么？
### 一、行为回放（已开源）
小桔棱镜中最具创新性的功能，也是整个棱镜平台的基础，我们基于`自研的用户操作行为标识指令`实现了在APP端的用户行为回放（视频回放 / 文字回放）。相比于传统的静态埋点数据，它**提供了用户的动态行为并赋予大家用上帝视角观察这些行为的能力**，给大家带来了全新视角。

当然它还可以有很多应用场景，比如**无需手写脚本的自动化测试**场景，仅单纯的行为标识指令就可以被应用到很多我们还没有想到但已经收到诉求的场景中，因此需要把它开源出来造福更多人。

### 二、行为检测（已开源）
端侧实时行为检测功能，同样基于`自研的用户操作行为标识指令`以及`语义化的行为策略描述方案（DSL）`，支持丰富的语义和灵活的策略配置。我们用它来实现**端侧场景化需求**，未来还希望用在**客服场景**中来提升用户体验，它在赋予大家观察用户的动态行为之上提供了实时运用行为的能力，同样给大家带来新视角。

当然我们相信它也有未被发掘的应用潜力，同样开源出来集思广益。

### 三、数据可视化（筹备开源中..）
覆盖埋点全流程的移动端解决方案，包括埋点数据可视化范畴的`多维度PV/UV`、`热力图`、`转化率漏斗`、`页面停留时长`等功能，以及埋点辅助范畴的`测试`工具。它的意义在于改变了大家日常看数据的方式，**让原本就擅长使用数据的同学可以更便捷的用数据，让原本不擅长使用数据的同学开始喜欢用数据**。

### 四、行为分析平台（筹备开源中..）
汇总用户行为数据并分析计算的平台，包含`用户行为标签系统`、`用户分群`、`高价值行为分析`以及`行为路径`等功能。它的意义在于尝试去**最大限度的挖掘用户行为数据的价值**。

## 更多详细介绍
- [小桔棱镜-用户行为分析工具](Doc/系列文章/小桔棱镜-用户行为分析利器.md)
- [小桔棱镜-针对移动端操作行为标识指令的探讨及棱镜最终方案介绍](Doc/系列文章/小桔棱镜-针对移动端操作行为标识指令的探讨及棱镜最终方案介绍.md)

## 使用手册
- [iOS集成文档](iOS/README.md)
- [Android集成文档](Android/README.md)

## 微信交流群
由于群二维码的有效期是7天，故可搜索 HulkRong 加我微信入群，可备注：小桔棱镜社区用户。

## 项目成员

**负责人**
[Hulk(荣浩)](https://github.com/ronghaopger)

**内部核心成员**
[Hulk(荣浩)](https://github.com/ronghaopger)、
[EastWoodYang](https://github.com/EastWoodYang)、
[pengpeng(赵磊鹏)](https://github.com/zhaoleipeng)、
[Kain(孙冬冬)](https://github.com/SunDDong)、
[张华](https://github.com/zollero)、
[朱少颖](https://github.com/zsynuting)、
[苍老师(张熠萌)](https://github.com/zymxxxs)、
[戴立慧](https://github.com/blankdlh)

## 协议

<img alt="Apache-2.0 license" src="https://www.apache.org/img/ASF20thAnniversary.jpg" width="128">

小桔棱镜 基于 Apache-2.0 协议进行分发和使用，更多信息参见 [协议文件](LICENSE)。