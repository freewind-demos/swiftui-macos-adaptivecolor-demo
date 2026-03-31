import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var previewScheme: ColorScheme? = nil

    /// 浅色 / 深色各用一色（macOS 上可直接读 colorScheme；iOS 也可用 `Color(light:dark:)`）。
    private var adaptiveBrand: Color {
        colorScheme == .dark ? .cyan : .orange
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("系统外观：\(colorScheme == .dark ? "深色" : "浅色")")
                    .font(.headline)

                GroupBox("系统语义色（随浅色 / 深色自动变）") {
                    VStack(alignment: .leading, spacing: 12) {
                        colorRow("primary", .primary)
                        colorRow("secondary", .secondary)
                        colorRow("accentColor", Color.accentColor)
                    }
                }

                GroupBox("随外观切换的自定义色（示例：浅橙 / 深青）") {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(adaptiveBrand)
                            .frame(width: 80, height: 48)
                        Text("浅色时偏橙，深色时偏青")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                GroupBox("从 AppKit 取系统色（示例：窗口背景）") {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(nsColor: .windowBackgroundColor))
                            .frame(height: 40)
                        Text("NSColor.windowBackgroundColor")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                GroupBox("预览：强制浅色 / 深色（仅本窗口）") {
                    Picker("外观预览", selection: Binding(
                        get: {
                            switch previewScheme {
                            case .some(.light): return 0
                            case .some(.dark): return 1
                            default: return 2
                            }
                        },
                        set: {
                            switch $0 {
                            case 0: previewScheme = .light
                            case 1: previewScheme = .dark
                            default: previewScheme = nil
                            }
                        }
                    )) {
                        Text("跟随系统").tag(2)
                        Text("浅色").tag(0)
                        Text("深色").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding()
        }
        .preferredColorScheme(previewScheme)
    }

    private func colorRow(_ name: String, _ color: Color) -> some View {
        HStack {
            Text(name)
                .font(.body.monospaced())
            Spacer()
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 100, height: 28)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                )
        }
    }
}
