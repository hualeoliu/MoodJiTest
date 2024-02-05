//
//  ShiningView.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func shining(_ lightKey: String, _ isOne: Bool = false, _ duration: Double = 5, _ lightDuration: Double = 1.8, _ lightWidthScale: CGFloat = 0.4, _ rotation: CGFloat = 14) -> some View {
        self.overlay {
            ShineView(lightKey: lightKey, isOne: isOne, duration: duration, lightDuration: lightDuration, lightWidthScale: lightWidthScale, rotation: rotation)
                .mask(self)
        }
    }
}

private struct ShineView: View { // 闪光效果
    let lightKey: String
    let isOne: Bool
    var duration: Double = 1.8
    var lightDuration: Double = 1.8
    var lightWidthScale: CGFloat = 0.4
    var rotation: CGFloat = 14
    let colors: [Color] = [
        .clear,
        .clear,
        .clear,
        .white.opacity(0.1),
        .white.opacity(0.5),
        .white.opacity(1.9),
        .white.opacity(0.5),
        .white.opacity(0.1),
        .clear,
        .clear,
        .clear,
    ]

    @State var offsetx: CGFloat = -1
    @State var allWidth: CGFloat = -1
    @State var lightWidth: CGFloat = 150

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(.clear).frame(height: 1).readSize { size in
                allWidth = size.width
                lightWidth = allWidth * lightWidthScale
            }

            Rectangle()
                .fill(.linearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                .frame(width: lightWidth)
                .scaleEffect(y: 6)
                .rotationEffect(.init(degrees: rotation))
                .offset(x: offsetx)
                .onAppear(perform: {
                    offsetx = -lightWidth * 2

                    MCGCDTimer.shared.cancleTimer(WithTimerName: lightKey)
                    MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: lightKey, timeInterval: duration / 2, queue: .main, repeats: true, atOnce: true) {
                        if offsetx > 0 {
                            offsetx = -lightWidth * 2
                        } else {
                            uiAfterDo(0.3) {
                                let lightDuration = Double.random(in: (lightDuration * 0.9) ... (lightDuration * 1.1))
                                withAnimation(.spring(duration: lightDuration)) {
                                    offsetx = allWidth
                                }
                            }
                        }
                        
                        if isOne {
                            MCGCDTimer.shared.cancleTimer(WithTimerName: lightKey)
                        }
                    }
                })
        }

        .allowsHitTesting(false)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        return background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
