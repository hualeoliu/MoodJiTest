//
//  LottieView.swift
//  LottieTutorialWatchOS-SwiftUI WatchKit Extension
//
//  Created by Evandro Harrison Hoffmann on 13/09/2021.
//

import SwiftUI
import UIKit
import SDWebImageLottieCoder

let spath = Bundle.main.path(forResource: "fsz", ofType: "json")!
let xpath = Bundle.main.path(forResource: "fsx", ofType: "json")!
let cpath = Bundle.main.path(forResource: "fsc", ofType: "json")!
let vpath = Bundle.main.path(forResource: "fsv", ofType: "json")!
class LottieViewModel: ObservableObject {
//    @Published var image = UIImage(named: "AppIcon")!
    @Published var image = UIImage()

    private var coder: SDImageLottieCoder?
    private var animationTimer: Timer?
    private var currentFrame: UInt = 0
    private var playing: Bool = false
    private var speed: Double = 1.0
    
    func loadAnimation(url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                print("paf1 ")
                self.setupAnimation(with: data)
            }
        }
        dataTask.resume()
    }

    private func setupAnimation(with data: Data) {
        coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!])
        
        // resets to first frame
        currentFrame = 0
        setImage(frame: currentFrame)
        
        play()
    }
    
    /// Set current animation
    private func setImage(frame: UInt) {
        if let coder = coder, let uiImage = coder.animatedImageFrame(at: frame) {
//            print("paf2 ", uiImage)
            self.image = uiImage
        }
    }
    
    /// Replace current frame with next one
    private func nextFrame() {
        guard let coder = coder else { return }

        currentFrame += 1
        // make sure that current frame is within frame count
        // if reaches the end, we set it back to 0 so it loops
        if currentFrame >= coder.animatedImageFrameCount {
            currentFrame = 0
        }
        
        setImage(frame: currentFrame)
    }
    
    /// Start playing animation
    private func play() {
        playing = true

        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05/speed, repeats: true, block: { (timer) in
            guard self.playing else {
                timer.invalidate()
                return
            }
            self.nextFrame()
        })
    }
    
    /// Pauses animation
    private func pause() {
        playing = false
        animationTimer?.invalidate()
    }
}
