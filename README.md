![Preview](https://cdn.lookin.work/public/style/images/independent/homepage/preview_en_1x.jpg "Preview")

# Introduction
You can inspect and modify views in iOS app via Lookin, just like UI Inspector in Xcode, or another app called Reveal.

Official Website：https://lookin.work/

# Integration Guide
To use Lookin macOS app, you need to integrate LookinServer (iOS Framework of Lookin) into your iOS project.

> **Warning**
Never integrate LookinServer in Release building configuration.

## via CocoaPods:
### Swift Project
`pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']`
### Objective-C Project
`pod 'LookinServer', :configurations => ['Debug']`
## via Swift Package Manager:
`https://github.com/QMUI/LookinServer/`

> **Warning**
Lookin will not display property name of a Swift class via SPM. Because the implementation of the feature needs to mix Objective-C and Swift files which is not supported by SPM. If you know how to deal with it, please contact me or create pull request. 

# Repository
LookinServer: https://github.com/QMUI/LookinServer

macOS app: https://github.com/hughkli/Lookin/

# Development
It's hard for me to spend much time on this free open-source side project. The feature developlment or bugfix may be really slow.

---
# 简介
Lookin 可以查看与修改 iOS App 里的 UI 对象，类似于 Xcode 自带的 UI Inspector 工具，或另一款叫做 Reveal 的软件。

官网：https://lookin.work/

# 安装 LookinServer Framework
如果这是你的 iOS 项目第一次使用 Lookin，则需要先把 LookinServer 这款 iOS Framework 集成到你的 iOS 项目中。

> **Warning**
记得不要在 AppStore 模式下集成 LookinServer。

## 通过 CocoaPods：

### Swift 项目
`pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']`
### Objective-C 项目
`pod 'LookinServer', :configurations => ['Debug']`

## 通过 Swift Package Manager:
`https://github.com/QMUI/LookinServer/`
> **Warning**
通过 SPM 方式集成时，Lookin 将无法显示 Swift 成员属性的变量名。因为实现这个 Feature 需要在 LookinServer 中引入 Swift 文件，但 SPM 似乎不支持 OC 和 Swift 文件混在一起（如果你知道如何解决，可以联系我，或者直接提 Pull Request）。

# 源代码仓库

iOS 端 LookinServer：https://github.com/QMUI/LookinServer

macOS 端软件：https://github.com/hughkli/Lookin/

# 开发节奏
由于在公司里的正职实在是太忙了，导致我很难在这个开源免费项目上花费太多时间和精力，所以新功能开发和 Bugfix 可能都比较慢，请见谅。
