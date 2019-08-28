![Preview](https://cdn.lookin.work/public/style/images/independent/homepage/preview_en_2x.jpg "Preview")

##Lookin
Lookin 是一款 macOS 软件，它可以查看与修改 iOS App 里的 UI 对象，类似于 Xcode 自带的 UI Inspector 工具，或另一款叫做 Reveal 的软件。
但借助于“控制台”和“方法监听”功能，Lookin 还可以进行 UI 之外的调试。
此外，它还可以嵌入你的 iOS App 而单独运行在 iPhone 或 iPad 上。
最后，Lookin 完全免费。

下载：https://lookin.work/get/

##在手机上使用 Lookin
相关教程：https://lookin.work/faq/lookin-ios/
![Lookin iOS](https://cdn.lookin.work/public/style/images/independent/sec6_2x.png "Lookin iOS")


##LookinServer
在使用 Lookin 前，必须先把 LookinServer.framework 嵌入到你的 iOS App 里，下面是相关教程。
- 通过 CocoaPods 嵌入：https://lookin.work/faq/integration-cocoapods/
- 手动嵌入：https://lookin.work/faq/integration-manual/

##源代码
Lookin 在 macOS 端的代码未开源，但在 iOS 端的代码已经全部开源，它包含了数据拉取、通讯、图像渲染等完整的相关代码：https://github.com/QMUI/LookinServer/tree/master/SourceCode

下载并打开 “Lookin.xcodeproj” 后，你会看到 “LookinServer” 和 “LookinServer-Universal” 两个 target，选择 “LookinServer-Universal” 并编译，编译完成后项目文件夹会被自动打开，然后你就会看到新生成的 “LookinServer.framework” 文件。

##加入该项目
你可以自行探索并向该项目提交代码，我们也已经有了一些已知但不知道如何解决的问题，比如
- 有的用户在打包时，会报告以下错误，我们尚不知道如何解决：
> error: exportArchive: Failed to verify bitcode in LookinServer.framework/LookinServer:
error: Linker option verification failed for bundle /var/folders/d6/bjdx752s38n57nz1s0lz31yh0000gq/T/LookinServerar_KLA/LookinServer.armv7.xar (unrecognized arguments: -platform_version iOS 8.0.0 13.0.0)

- 由于我们团队自身使用 Objective-C 而非 Swift，因此该项目在 Swift 项目中可能遇到一些问题我们难以解决，比如无法正常显示类名（类名前会有难看的 Swift 前缀）、iVar 名称等
