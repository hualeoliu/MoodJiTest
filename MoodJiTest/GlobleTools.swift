//
//  Tools.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import Foundation
import SwiftUI

class MainColorModel: ObservableObject {
    @Published var colorOption = 0
    @Published var timeType = 0
}

let mainColorSet = "mainColorSet"
let sleepTimeArr = "sleepTimeArr"
let workTimeArr = "workTimeArr"
let firstOpen = "firstOpen"

var winBounds = UIScreen.main.bounds
var winSize = winBounds.size
var winW  = winSize.width
var winH = winSize.height

var __UserDefault = UserDefaults.standard
func __CurVc() -> UIViewController {
    if let viewController = UIApplication.shared.windows.first?.rootViewController {
        // 在此处使用 viewController
        // viewController 即为当前控制器
        print("当前控制器: \(viewController)")
        return viewController
    }
    return UIViewController()
}


struct CurrentViewControllerGetter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 获取当前控制器
        
    }
}
