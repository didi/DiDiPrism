<p align="center">
<img src="https://view.didistatic.com/static/dcms/1jt5q12q9lkgrtelg2_180x180.png" alt="小桔棱镜" title="小桔棱镜" width="180"/>
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

**DiDiPrism**，中文名：**小桔棱镜**，是一款专注于移动端操作行为的工具，涵盖APP`操作回放`、`操作检测`、以及`数据可视化`能力。我们在整个方案的实现过程中沉淀出了一套技术框架，希望可以逐步开源出来帮助更多人，同时也希望棱镜在大家的合力下能够更快的成长。


## 它有哪些亮点？
- [x] **零入侵**

业务代码无需任何适配。

- [x] **高可用**

各项能力已在生产环境平稳运行一年以上。

- [x] **自研操作行为标识指令**

在支撑棱镜已有的功能外，或许可以有更大的舞台。

- [x] **丰富灵活的操作行为策略支持**

基于DSL实现丰富的操作行为策略支持，可满足通常的检测需求。

- [x] **功能全面**

围绕移动端操作行为全方位能力覆盖，提供更多可能。

## 用它能做什么？
### 一、操作回放（已开源）
小桔棱镜中最具创新性的功能，也是整个棱镜平台的基础，我们基于`自研的操作行为标识指令`实现了在APP端的操作回放（视频回放 / 文字回放）。相比于传统的静态埋点数据它提供了动态的操作行为，可以帮助大家更好的定位问题、优化产品，为用户创造价值。

当然它还可以有很多应用场景，比如**无需手写脚本的自动化测试**场景，仅单纯的操作行为标识指令就可以被应用到很多我们还没有想到但已经收到诉求的场景中，因此我们选择把它开源出来造福更多人。

#### [Demo展示]
<p align="center">
  <img src="https://view.didistatic.com/static/dcms/3pwfx749nki143sb6_872x1753_compress.png" width="218" hegiht="438" alt="回放演示" />
  
  <img src="https://view.didistatic.com/static/dcms/1jt5q4ncski14uosf_879x1762_compress.png" width="218" hegiht="438" alt="视频回放" />

  <img src="https://view.didistatic.com/static/dcms/olv82khg4ki143yz2_876x1763_compress.png" width="218" hegiht="438" alt="文字回放" />
</p>

### 二、操作检测（已开源）
端侧实时操作行为检测功能，同样基于`自研的操作行为标识指令`以及`语义化的操作行为策略描述方案（DSL）`，支持丰富的语义和灵活的策略配置。它可以帮助我们实现端侧场景化需求，未来还希望用在客服场景中来提升用户体验，创造更多用户价值。

当然我们相信它也有未被发掘的应用潜力，同样开源出来集思广益。

#### [Demo展示]
<p align="center">
  <img src="https://view.didistatic.com/static/dcms/3pwfx5hv3ki144283_880x1763_compress.png" width="218" hegiht="438" alt="操作检测" />
</p>

### 三、数据可视化（开源筹备中..）
覆盖埋点全流程的移动端解决方案，包括埋点数据可视化范畴的`多维度PV/UV`、`热力图`、`转化率漏斗`、`页面停留时长`等功能，以及埋点辅助范畴的`测试`工具。它的意义在于改变了大家日常看数据的方式，**让原本就擅长使用数据的同学可以更便捷的用数据，让原本不擅长使用数据的同学开始喜欢用数据**。

## 使用手册
- [iOS 代码说明文档](iOS/README.md)
- [Android 代码说明文档](Android/README.md)
- [操作行为指令 格式说明](Doc/操作行为指令/操作行为指令格式说明.md)
- [操作检测 策略配置说明](Doc/操作检测/操作检测配置文件说明.md)

## 系列文章
- [小桔棱镜-移动端操作行为工具](Doc/系列文章/小桔棱镜-移动端操作行为利器.md)
- [小桔棱镜-针对移动端操作行为标识指令的探讨及棱镜最终方案介绍](Doc/系列文章/小桔棱镜-针对移动端操作行为标识指令的探讨及棱镜最终方案介绍.md)

## 微信交流群
由于群二维码的有效期仅为7天，故可搜索 HulkRong 加我微信入群，可备注：小桔棱镜社区用户。

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