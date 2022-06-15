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

**中文版本**请参看[这里](README_cn.md)

**DiDiPrism** is a tool that focuses on mobile operation behavior, covering APP `Operation Playback`, `Operation Detection`, and `Data Visualization` capabilities. We have precipitated a set of technical frameworks during the implementation of the entire program, and hope that we can gradually open source it to help more people. At the same time, we also hope that Prism can grow faster with the joint efforts of everyone.


## Features
- [x] **No intrusion**

The business code does not need any adaptation.

- [x] **High availability**

The capabilities have been running smoothly in the production environment for more than two years.

- [x] **Self-developed operation behavior identification instructions**

In addition to the existing function of supporting the Prism, there may be a larger stage.

- [x] **Rich and flexible operation behavior policy support**

Based on DSL, it implements rich operation behavior policy support, which can meet the usual detection requirements.

- [x] **Full-featured**

All-round capability coverage around mobile operation behavior provides more possibilities.

## What can I do with it?
### 1. Operation Playback
The most innovative function in the DiDiPrism is also the foundation of the entire prism platform. We realize the operation playback (Video Playback / Text Playback) on the APP side based on the `self-developed operation behavior identification instruction`. Compared with the traditional static buried point data, it provides dynamic operation behavior, which can help you better locate problems, optimize products, and create value for users.

Of course, it can also have many application scenarios, such as **automatic testing without handwritten script** scenarios, and only simple operation behavior identification instructions can be applied to many scenarios that we have not thought of but have received demands, so we Choose to open source it to benefit more people.

#### [Demo Show]
<p align="center">
  <img src="https://view.didistatic.com/static/dcms/3pwfx749nki143sb6_872x1753_compress.png" width="218" hegiht="438" alt="Playback Show" />
  
  <img src="https://view.didistatic.com/static/dcms/1jt5q4ncski14uosf_879x1762_compress.png" width="218" hegiht="438" alt="Video Playback" />

  <img src="https://view.didistatic.com/static/dcms/7qcc06d21rl4fb4os3_890x1758_compress.png" width="218" hegiht="438" alt="Text Playback" />
</p>

### 2. Operation Detection
The device-side real-time operation behavior detection function is also based on the `self-developed operation behavior identification instruction` and the `semantic operation behavior policy description scheme (DSL)`, which supports rich semantics and flexible policy configuration. It can help us realize the needs of client-side scenarios. In the future, we hope to use it in customer service scenarios to improve user experience and create more user value.

Of course, we believe that it also has untapped application potential, and it is also open sourced to brainstorm ideas.

#### [Demo Show]
<p align="center">
  <img src="https://view.didistatic.com/static/dcms/3pwfx5hv3ki144283_880x1763_compress.png" width="218" hegiht="438" alt="操作检测" />
</p>

### 3. Data Visualization (in progress.)
Mobile solutions covering the whole process of tracking, including `multi-dimensional PV/UV`, `heat map`, `conversion rate funnel`, `page dwell time` and other functions in the field of tracking data visualization, as well as the auxiliary field of tracking The `test` tool. Its significance is to change the way people look at data on a daily basis, **so that students who are good at using data can use data more conveniently, and students who are not good at using data start to like to use data**.

## User Manual
- [iOS code documentation](iOS/README.md)
- [Android code documentation](Android/README.md)
- [Description of Self-developed operation behavior identification instruction](Doc/操作行为指令/操作行为指令格式说明.md)
- [Description of Operation detection strategy](Doc/操作检测/操作检测配置文件说明.md)

## Series of articles
- [DiDiPrism - A powerful tool that focuses on mobile operation behavior](Doc/系列文章/小桔棱镜-专注移动端操作行为的利器.md)
- [DiDiPrism - Discussion on the mobile terminal operation behavior identification instructions and introduction of the final solution of the prism](Doc/系列文章/小桔棱镜-针对移动端操作行为标识指令的探讨及棱镜最终方案介绍.md)

## WeChat
Since the validity period of the group QR code is only 7 days, you can search for `HulkRong` and add me to WeChat to join the group, and you can remark: DiDiPrism community users.

## TODO
[TODO List](https://github.com/didi/DiDiPrism/wiki)

## Project member
[Hulk(荣浩)](https://github.com/ronghaopger)、
[梅平](https://github.com/mpmpmp3332003)、
[EastWoodYang](https://github.com/EastWoodYang)、
[张华](https://github.com/zollero)、
[戴立慧](https://github.com/blankdlh)

## License

<img alt="Apache-2.0 license" src="https://www.apache.org/img/ASF20thAnniversary.jpg" width="128">

DiDiPrism is published under the Apache-2.0 license，For details check out the [LICENSE.TXT](LICENSE)。
