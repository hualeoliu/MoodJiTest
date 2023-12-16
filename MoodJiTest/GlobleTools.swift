//
//  Tools.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import Foundation
import SwiftUI

class MainColorModel: ObservableObject {
    @Published var colorOption = 0//0auto  1dark 2light
    @Published var timeType = 0// sleep or work
}

let mainColorSet = "mainColorSet"
let sleepTimeArr = "sleepTimeArr"
let workTimeArr = "workTimeArr"
let firstOpen = "firstOpen"

var winBounds = UIScreen.main.bounds
var winSize = winBounds.size
var winW  = winSize.width
var winH = winSize.height
var winmin: CGFloat {
    min(winW, winH)
}
var winmax: CGFloat {
    max(winW, winH)
}
var isX: Bool {
    winmax >= 812
}

var __UserDefault = UserDefaults.standard
var __dateSir = DateFormatter()

func uiDo(_ doSome: @escaping (()->())) {
    DispatchQueue.main.async(execute: doSome)
}
func uiAfterDo(_ afterTime: Double, _ doSome: @escaping (()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + afterTime, execute: doSome)
}
func afterDo(_ afterTime: Double, _ doSome: @escaping (()->())) {
    DispatchQueue.global().asyncAfter(deadline: .now() + afterTime, execute: doSome)
}
