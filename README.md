![Preview](https://cdn.lookin.work/public/style/images/independent/homepage/preview_en_2x.jpg "Preview")

## 中文说明请滑到底部

## Lookin
You can inspect and modify views in iOS app via Lookin, just like UI Inspector in Xcode, or another app called Reveal. 

And you can do more with features like Console or Method Trace. 

Moreover, Lookin can run on your iPhone or iPad without connecting to a Mac.  

And one more thing, Lookin is free.

Download: https://lookin.work/get/

## Use Lookin on Your iPhone
Tutorial: https://lookin.work/faq/lookin-ios/
![Lookin iOS](https://cdn.lookin.work/public/style/images/independent/sec6_2x.png "Lookin iOS")

## LookinServer
You must embed LookinServer.framework into your iOS App before using Lookin.
- Embed by CocoaPods: https://lookin.work/faq/integration-cocoapods/
- Embed Manually：https://lookin.work/faq/integration-manual/

## Source Code
The source code of Lookin in iOS is open-sourced: https://github.com/QMUI/LookinServer/tree/master/SourceCode

Download and open "Lookin.xcodeproj", you will see two targets named "LookinServer" and "LookinServer-Universal". After compiling and running "LookinServer-Universal", a file named "LookinServer.framework" will be displayed in a Finder window.

## Push Request
Feel free to push requests. For example, there're some issues that we don't know how to deal with. 
- Some users got issues below while archiving:
> error: exportArchive: Failed to verify bitcode in LookinServer.framework/LookinServer:
error: Linker option verification failed for bundle /var/folders/d6/bjdx752s38n57nz1s0lz31yh0000gq/T/LookinServerar_KLA/LookinServer.armv7.xar (unrecognized arguments: -platform_version iOS 8.0.0 13.0.0)

- Because we're not good at Swift, unexpected problems may happen when using Lookin in Swift project. For example, a Swift prefix may be displayed unexpectedly before class name.

## Lookin
Lookin 是一款 macOS 软件，它可以查看与修改 iOS App 里的 UI 对象，类似于 Xcode 自带的 UI Inspector 工具，或另一款叫做 Reveal 的软件。 

但借助于“控制台”和“方法监听”功能，Lookin 还可以进行 UI 之外的调试。 

此外，它还可以嵌入你的 iOS App 而单独运行在 iPhone 或 iPad 上。 

最后，Lookin 完全免费。

下载：https://lookin.work/get/

## 在手机上使用 Lookin
相关教程：https://lookin.work/faq/lookin-ios/
![Lookin iOS](https://cdn.lookin.work/public/style/images/independent/sec6_2x.png "Lookin iOS")


## LookinServer
在使用 Lookin 前，必须先把 LookinServer.framework 嵌入到你的 iOS App 里，下面是相关教程。
- 通过 CocoaPods 嵌入：https://lookin.work/faq/integration-cocoapods/
- 手动嵌入：https://lookin.work/faq/integration-manual/

## 源代码
Lookin 在 macOS 端的代码未开源，但在 iOS 端的代码已经全部开源，它包含了数据拉取、通讯、图像渲染等完整的相关代码：https://github.com/QMUI/LookinServer/tree/master/SourceCode

下载并打开 “Lookin.xcodeproj” 后，你会看到 “LookinServer” 和 “LookinServer-Universal” 两个 target，选择 “LookinServer-Universal” 并编译，编译完成后项目文件夹会被自动打开，然后你就会看到新生成的 “LookinServer.framework” 文件。