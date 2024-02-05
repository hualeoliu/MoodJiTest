//
//  LottView.swift
//  FlowzWatch Watch App
//
//  Created by flowz-leo on 2024/1/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func shining(_ pathKey: String) -> some View {
        self.overlay {
            LottView(path: pathKey)
//                .mask(self)
        }
    }
}

private struct LottView: View { // 闪光效果
    let path: String
    @ObservedObject var lott: LottieViewModel = .init()

    var body: some View {
        Image(uiImage: lott.image)
            .resizable()
            .scaledToFit()
            .background(.pink.opacity(0.2))
            .onAppear {
                print("paf ")
                self.lott.loadAnimation(url: URL(fileURLWithPath: spath))
            }
        .allowsHitTesting(false)

    }
}
