//
//  Tools.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import Foundation
import SwiftUI

let mainColorSet = "mainColorSet"
let sleepTimeArr = "sleepTimeArr"
let workTimeArr = "workTimeArr"
let firstOpen = "firstOpen"

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


