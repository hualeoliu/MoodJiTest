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
    @State var img = UIImage()

    var body: some View {
        Image(uiImage: img)
            .resizable()
            .scaledToFit()
            .background(.pink.opacity(0.2))
            .onAppear {
                print("paf ")
                LottieSir.loadAnimation("fsc") { img in
                    self.img = img
                }
            }
            .onDisappear(perform: {
                LottieSir.stopAnim("fsc")
            })
        .allowsHitTesting(false)

    }
}
