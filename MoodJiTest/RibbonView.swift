//
//  RibbonView.swift
//  MoodJiTest
//
//  Created by flowz-leo on 2024/1/12.
//

import SwiftUI

struct ConfettiView: View {
    var body: some View {
        ConfettiEmitter()
            .offset(x: 50) // 调用粒子效果视图
            .background(Color.pink.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ConfettiEmitter: UIViewRepresentable {
    
    func cellSet(_ imgNames: [String]) -> [CAEmitterCell] {
        var arr = [CAEmitterCell]()

        for idx in 0..<7 {
            imgNames.forEach { t in
                let confettiCell = CAEmitterCell()
                arr += [confettiCell]
                confettiCell.birthRate = Float.random(in: 2...3)
                confettiCell.lifetime = 23
                confettiCell.velocity = 300
                confettiCell.velocityRange = 200
                confettiCell.emissionLongitude = 0
                confettiCell.emissionRange = .pi/8
                confettiCell.spin = 2 // 旋转
                confettiCell.spinRange = 8
                confettiCell.yAcceleration = Double.random(in: 200 ... 400)
                confettiCell.xAcceleration = Double.random(in: -100 ... 100)
                
                if t == "GoodM" {
                    let img = UIImage(named: t)!
                    if let resizedImage = img.resize(to: CGSize(width: 44, height: 44) ) {
                        confettiCell.contents = resizedImage.cgImage
                    }
                }else{
                    confettiCell.contents = UIImage(named: t)?.cgImage
                }
                confettiCell.scale = 0.3
                confettiCell.scaleRange = 1
            }
        }
                
        return arr
    }
    
    func makeUIView(context: Context) -> UIView {
        let confettiView = UIView()
//        confettiView.frame = UIScreen.main.bounds

        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: 100, y: 0)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: 150, height: 1)

        let imgs = ["tab2", "schedule_taped", "GoodM", "set_appearance"]
        emitterLayer.emitterCells = cellSet(imgs)
        confettiView.layer.addSublayer(emitterLayer)

        return confettiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

