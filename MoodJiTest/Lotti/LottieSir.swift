//
//  LottieSir.swift
//  LottieTutorialWatchOS-SwiftUI WatchKit Extension
//
//  Created by Leo 2024.
//

import SDWebImageLottieCoder
import SwiftUI

let isTestWatchLottie = true
class LottieSir: NSObject {
    static let frameInterval = 0.04
    static var lottiImgs = [String: [Int: UIImage]]()
    static var loadingArr = [String]()//加载中的json
    static var loadingBlocks = [String: ((UIImage) -> Void)?]()//缓存任务

    static func loadAnimation(_ name: String, complet: ((UIImage) -> Void)?) {
        func loopAnim(_ imgs: [Int: UIImage]) {
            var currentFrame = 0
            MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: name, timeInterval: frameInterval, queue: .main, repeats: true, atOnce: false) {
                if currentFrame >= imgs.count - 1 {
                    currentFrame = 0
                    MCGCDTimer.shared.cancleTimer(WithTimerName: name)
                }
                if let uiImage = imgs[currentFrame] {
                    complet?(uiImage)
                    currentFrame += 1
                }
            }
        }

        if let imgs = lottiImgs[name] {
            MCGCDTimer.shared.cancleTimer(WithTimerName: name + "big")
            MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: name + "big", timeInterval: 3 + Double(imgs.count) * frameInterval, queue: .main, repeats: true, atOnce: true) {
                loopAnim(imgs)
            }
        } else {
            if loadingArr.contains(name) { // fix
                loadingBlocks[name] = complet
                return
            }
            loadingArr += [name]
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let url = URL(filePath: Bundle.main.path(forResource: name, ofType: "json")!)
            let dataTask = session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let data = data, let coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!]) {
                    var imgs: [Int: UIImage] = [:]
                    for idx in 0 ..< coder.animatedImageFrameCount {
                        if let img = coder.animatedImageFrame(at: idx) {
                            imgs[Int(idx)] = img
                            
                            if let block = loadingBlocks[name] {
                                block?(imgs[0]!)//显示第一帧
                            }
                        }
                    }
                    loadingArr.remove(at: loadingArr.firstIndex(of: name)!)
                    lottiImgs[name] = imgs

                    if let block = loadingBlocks[name] {//缓存的任务
                        loadAnimation(name, complet: block)
                    } else {
                        loadAnimation(name, complet: complet)
                    }
                }
            }
            dataTask.resume()
        }
    }

    static func stopAnim(_ name: String) {
        MCGCDTimer.shared.cancleTimer(WithTimerName: name + "big")
        MCGCDTimer.shared.cancleTimer(WithTimerName: name)
    }
}
