
//
//  ColorStyles.swift
//
//
//  Created by 老游 on 2023/10/26.
//

import Foundation
import SwiftUI

public let accentWarning = Color.brown
public let accentNightScreen = Color(.displayP3, red: 0.373, green: 0.247, blue: 0.729, opacity: 1)
public let accentRunning = Color(.displayP3, red: 0.902, green: 0.553, blue: 0.035, opacity: 1)
public let accentScreenTime = Color(.displayP3, red: 0.635, green: 0.486, blue: 1.000, opacity: 1)
public let accentScreenTimeSecondary = Color(.displayP3, red: 0.710, green: 0.592, blue: 1.000, opacity: 0.5)
public let accentSleep = Color(.displayP3, red: 0.557, green: 0.925, blue: 0.929, opacity: 1)
public let accentSleepSecondary = Color(.displayP3, red: 0.557, green: 0.925, blue: 0.929, opacity: 0.5)
public let accentSteps = Color(.displayP3, red: 1.000, green: 0.820, blue: 0.353, opacity: 1)
public let accentStepsSecondary = Color(.displayP3, red: 1.000, green: 0.820, blue: 0.353, opacity: 0.5)

public let statusActivityBusy = Color(.displayP3, red: 1.000, green: 0.627, blue: 0.627, opacity: 1)
public let statusActivityBusyStroke = Color(.displayP3, red: 1.000, green: 0.902, blue: 0.902, opacity: 1)
public let statusActivityEnergy = Color(.displayP3, red: 0.643, green: 0.945, blue: 0.145, opacity: 1)
public let statusActivityEnergyStroke = Color(.displayP3, red: 0.929, green: 0.992, blue: 0.827, opacity: 1)
public let statusActivityFocus = Color(.displayP3, red: 0.459, green: 0.961, blue: 0.843, opacity: 1)
public let statusActivityFocusStroke = Color(.displayP3, red: 0.824, green: 0.996, blue: 0.957, opacity: 1)
public let statusActivityHeavyScreen = Color(.displayP3, red: 0.486, green: 0.353, blue: 0.773, opacity: 1)
public let statusActivityHeavyScreenStroke = Color(.displayP3, red: 0.875, green: 0.820, blue: 1.000, opacity: 1)
public let statusActivityHighHrv = Color(.displayP3, red: 0.859, green: 1.000, blue: 0.627, opacity: 1)
public let statusActivityLowHrv = Color(.displayP3, red: 1.000, green: 0.533, blue: 0.871, opacity: 1)
public let statusActivityScreenTime = Color(.displayP3, red: 0.749, green: 0.624, blue: 0.949, opacity: 1)
public let statusActivityScreenTimeStroke = Color(.displayP3, red: 0.902, green: 0.859, blue: 1.000, opacity: 1)
public let statusActivitySteps = Color(.displayP3, red: 1.000, green: 0.800, blue: 0.290, opacity: 1)
public let statusActivityStepsStroke = Color(.displayP3, red: 0.996, green: 0.953, blue: 0.843, opacity: 1)
public let statusActivitySunlight = Color(.displayP3, red: 1.000, green: 0.839, blue: 0.039, opacity: 1)
public let statusSleepActive = Color(.displayP3, red: 1.000, green: 0.729, blue: 0.039, opacity: 1)
public let statusSleepAwake = Color(.displayP3, red: 1.000, green: 0.455, blue: 0.349, opacity: 1)
public let statusSleepCore = Color(.displayP3, red: 0.227, green: 0.510, blue: 0.969, opacity: 1)
public let statusSleepDeep = Color(.displayP3, red: 0.251, green: 0.247, blue: 0.729, opacity: 1)
public let statusSleepRem = Color(.displayP3, red: 0.506, green: 0.812, blue: 0.980, opacity: 1)
public let statusSleepScreenTime = Color(.displayP3, red: 0.710, green: 0.592, blue: 1.000, opacity: 1)
public let statusSleepWindDown = Color(.displayP3, red: 0.459, green: 0.961, blue: 0.843, opacity: 1)

public var tabitemSelected = Color.pink//Color("#aa87ff".hexColor)
public var tabitemNormal = Color("#999999".hexColor).opacity(0.6)
public var mainBg = Color("#f2f2f7".hexColor)

extension String {
    
    var hexColor: UIColor {
        if self.isEmpty {
            return UIColor.clear
        }
        
        let set = CharacterSet.whitespacesAndNewlines
        var hHex = self.trimmingCharacters(in: set).uppercased()
        if hHex.count < 6 {
            return UIColor.clear
        }
        if hHex.hasPrefix("0X") {//开头是用0x开始的
            hHex = (hHex as NSString).substring(from: 2)
        }
        if hHex.hasPrefix("#") {//开头是以＃开头的
            hHex = (hHex as NSString).substring(from: 1)
        }
        if hHex.hasPrefix("##") {//开头是以＃＃开始的
            hHex = (hHex as NSString).substring(from: 2)
        }
        if hHex.count != 6 {// 截取出来的有效长度是6位， 所以不是6位的直接返回
            return UIColor.clear
        }
        
        var range = NSMakeRange(0, 2)
        let rHex = (hHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
}

