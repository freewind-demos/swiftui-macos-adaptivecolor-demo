# SwiftUI macOS 自适应颜色（Adaptive Color）

## 简介

这个 Demo 演示在 macOS 上如何让颜色随**系统浅色 / 深色外观**变化：语义色、`ColorScheme`、用 `Color(nsColor:)` 桥接 AppKit 系统色，以及用 `preferredColorScheme` 做单窗口预览。

## 快速开始

### 环境要求

macOS 14 及以上，本机安装 **Xcode**（命令行需能跑 `xcodebuild`）和 **XcodeGen**（`brew install xcodegen`）。若默认选中的是 Command Line Tools，请执行：

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

或在构建前设置：

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

### 运行

在项目根目录执行：

```bash
xcodegen generate
open SwiftUIAdaptiveColorDemo.xcodeproj
```

命令行构建（Debug）：

```bash
./scripts/build.sh
```

打 Release 并复制到 `dist/`：

```bash
./scripts/build.sh release
```

## 概念讲解

### 第一部分：语义色

`Color.primary`、`Color.secondary`、`Color.accentColor` 会随当前外观自动调整对比度，适合做正文、辅助说明和高亮，而不是写死 `Color.black` / `Color.white`。

```swift
Text("标题").foregroundColor(.primary)
```

### 第二部分：读取当前外观

`@Environment(\.colorScheme)` 可取当前是 `.light` 还是 `.dark`，据此切换自定义颜色（本 Demo 里用「浅橙 / 深青」举例）。

```swift
@Environment(\.colorScheme) private var colorScheme

private var brand: Color {
    colorScheme == .dark ? .cyan : .orange
}
```

在 Apple 平台也可用 `Color(light:dark:)` 在声明时绑死浅色与深色各用什么色；当前工程为兼容本机 Xcode/SDK 组合，在界面代码里采用了 `colorScheme` 分支写法，效果等价。

### 第三部分：AppKit 系统色

需要和系统窗口、控件保持一致时，可用 `NSColor` 再桥成 SwiftUI `Color`：

```swift
Color(nsColor: .windowBackgroundColor)
```

### 第四部分：单窗口外观预览

`.preferredColorScheme(.light)` / `.dark` 可强制子树使用某种外观；传 `nil` 表示跟系统。Demo 里用分段控件切换「跟随系统 / 浅色 / 深色」，仅影响本窗口内容。

## 完整示例

入口与窗口：

```swift
import SwiftUI

@main
struct AdaptiveColorApp: App {
    var body: some Scene {
        Window("Adaptive Color 自适应颜色", id: "main") {
            ContentView()
        }
        .defaultSize(width: 520, height: 560)
    }
}
```

内容区要点：`GroupBox` 分块展示语义色、自定义双色、`NSColor` 与 `preferredColorScheme` 控制条，完整代码见仓库内 `Sources/ContentView.swift`。

## 注意事项

若命令行构建报找不到 SwiftUI 或 SDK，多半是 `xcode-select` 未指向完整 Xcode，先按上文设置 `DEVELOPER_DIR` 或切换 `xcode-select`。

## 完整讲解（中文）

做 macOS 主题时，核心是**少写死绝对颜色，多用系统语义和系统画板**。用户开深色模式时，系统已经帮 `primary`、`secondary` 配好对比度；若你仍用大灰底加纯黑字，在深色下会刺眼或看不清。自定义品牌色若只有一种，在某一模式下可能发灰或糊在一起，所以常见做法是：`colorScheme` 分支或 `Color(light:dark:)` 给两套仍属同一风格的色值。

和 AppKit 混用时，`NSColor` 里大量标签色本身就会随深浅变化，桥到 SwiftUI 后能保持和系统窗口一致。最后，`preferredColorScheme` 适合做「预览」或局部强制外观，不要滥用去整 app 硬掰主题，除非产品明确要求与系统设置脱钩。
