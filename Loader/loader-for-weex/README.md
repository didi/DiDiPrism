
# Weex Loader For DiDiPrism

A webpack loader for Weex project with DiDiPrism.

![npm](https://img.shields.io/npm/v/weex-loader-for-didiprism)
![npm](https://img.shields.io/npm/dw/weex-loader-for-didiprism)

这是一个`Webpack Loader`，它用在基于`Vue`的`Weex`项目中，通过该`Loader`生成在`小桔棱镜`中使用的属性，辅助小桔棱镜做标签元素的唯一ID校验。

## 快速上手

### 安装

该 `Loader` 已上传到 `npm` 仓库，使用下面的命令安装：

```bash
npm i --save weex-loader-for-didiprism
```

### 使用

安装之后，就可以在`Webpack`配置中使用它了，针对`.vue`做语法转换及解析。配置文件示例代码如下：

```javascript
const webpackConfig = {
  entry: {
    index: './example/main.js'
  },
  mode: 'production', // 'development',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: options.dev ? '[name].js' : '[name].js?[chunkhash]',
    chunkFilename: '[id].js?[chunkhash]',
    publicPath: options.dev ? '/assets/' : publicPath
  },
  module: {
    rules: [{
      test: /\.vue$/,
      use: [
        'vue-loader',
        // 注意：需要将 weex-loader-for-prism 放到数组的靠后位置，因为Webpack是按照从后往前的顺序执行loader
        'weex-loader-for-didiprism'
      ]
    },
    {
      test: /\.js$/,
      use: ['babel-loader'],
      exclude: /node_modules/
    }]
  }
}
```

## 协议

<img alt="Apache-2.0 license" src="https://www.apache.org/img/ASF20thAnniversary.jpg" width="128">
