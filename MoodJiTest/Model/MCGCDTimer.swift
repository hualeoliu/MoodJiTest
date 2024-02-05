//
//  SwiftUIView.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/5.
//

import Foundation
import UIKit

class MCGCDTimer {//计时器工具
    
    func scheduledDispatchTimer(WithTimerName name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, atOnce: Bool, action: @escaping()->()) {
        if name == nil {
            return
        }
        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        
        timer?.schedule(deadline: .now()+(atOnce ? 0: timeInterval), repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))//精度0.1秒
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }
    
    func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }
    
    func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
    
    static let shared = MCGCDTimer()
    lazy var timerContainer = [String: DispatchSourceTimer]()
    
}

func rigidDo() {
    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
}
