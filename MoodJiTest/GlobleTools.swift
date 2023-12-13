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
}

let mainColorSet = "mainColorSet"

var winBounds = UIScreen.main.bounds
var winSize = winBounds.size
var winW  = winSize.width
var winH = winSize.height

var __UserDefault = UserDefaults.standard
