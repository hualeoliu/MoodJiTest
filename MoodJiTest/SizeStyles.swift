//
//  SizeStyle.swift
//  Flowzland
//
//  Created by 老游 on 2023/10/26.
//

import Foundation
import SwiftUI

public protocol SizeStylesProtocal {
    var name: String { get }
    var cornerRadiusL: Double { get }
    var cornerRadiusM: Double { get }
    var cornerRadiusS: Double { get }
    var cornerRadiusXl: Double { get }
    var cornerRadiusXs: Double { get }
    var cornerRadiusXxl: Double { get }
    var paddingL: Double { get }
    var paddingM: Double { get }
    var paddingS: Double { get }
    var paddingXl: Double { get }
    var paddingXs: Double { get }
    var paddingXxl: Double { get }
    var paddingXxs: Double { get }
    var scenePaddingBottom: Double { get }
    var scenePaddingHorizontal: Double { get }
    var scenePaddingTop: Double { get }
    var spacingL: Double { get }
    var spacingM: Double { get }
    var spacingS: Double { get }
    var spacingXl: Double { get }
    var spacingXs: Double { get }
    var spacingXxl: CGFloat { get }
    var spacingXxs: Double { get }
    var spacingXxxs: Double { get }
    
}

public class SizeStylesPro: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesPro"
    public let cornerRadiusL = 16.0
    public let cornerRadiusM = 12.0
    public let cornerRadiusS = 6.0
    public let cornerRadiusXl = 20.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 200.0
    public let paddingL = 20.0
    public let paddingM = 16.0
    public let paddingS = 12.0
    public let paddingXl = 24.0
    public let paddingXs = 8.0
    public let paddingXxl = 32.0
    public let paddingXxs = 4.0
    public let scenePaddingBottom = 48.0
    public let scenePaddingHorizontal = 16.0
    public let scenePaddingTop = 16.0
    public let spacingL = 20.0
    public let spacingM = 16.0
    public let spacingS = 12.0
    public let spacingXl = 24.0
    public let spacingXs = 8.0
    public var spacingXxl: CGFloat {//根据机型写死宽度
        if winW == 393 || winW == 390 {//12 12p
            return CGFloat(32)//设计图基准屏幕
        }
        if winW == 430 || winW == 428 {//12pm
            return 36
        }
        if winW == 414 {//6sp xsm 11pm
            return 36//未定义
        }
        if winW == 375 {//6s x 12mini
            return 28
        }
        return 32
    }
    public let spacingXxs = 4.0
    public let spacingXxxs = 2.0
    
    
    
}

public class SizeStylesProMax: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesProMax"
    public let cornerRadiusL = 20.0
    public let cornerRadiusM = 14.0
    public let cornerRadiusS = 6.0
    public let cornerRadiusXl = 24.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 200.0
    public let paddingL = 22.0
    public let paddingM = 18.0
    public let paddingS = 14.0
    public let paddingXl = 28.0
    public let paddingXs = 10.0
    public let paddingXxl = 36.0
    public let paddingXxs = 6.0
    public let scenePaddingBottom = 56.0
    public let scenePaddingHorizontal = 20.0
    public let scenePaddingTop = 20.0
    public let spacingL = 22.0
    public let spacingM = 18.0
    public let spacingS = 14.0
    public let spacingXl = 28.0
    public let spacingXs = 10.0
    public let spacingXxl:CGFloat = 36.0
    public let spacingXxs = 6.0
    public let spacingXxxs = 2.0
    
    
}

public class SizeStylesMini: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesMini"
    public let cornerRadiusL = 12.0
    public let cornerRadiusM = 10.0
    public let cornerRadiusS = 6.0
    public let cornerRadiusXl = 16.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 200.0
    public let paddingL = 18.0
    public let paddingM = 14.0
    public let paddingS = 10.0
    public let paddingXl = 20.0
    public let paddingXs = 6.0
    public let paddingXxl = 24.0
    public let paddingXxs = 2.0
    public let scenePaddingBottom = 40.0
    public let scenePaddingHorizontal = 12.0
    public let scenePaddingTop = 12.0
    public let spacingL = 18.0
    public let spacingM = 14.0
    public let spacingS = 10.0
    public let spacingXl = 20.0
    public let spacingXs = 6.0
    public let spacingXxl:CGFloat = 28.0
    public let spacingXxs = 3.0
    public let spacingXxxs = 2.0
    
    
}

extension Int {
    func byScaleWidth() -> CGFloat {//根据屏幕宽度适配
        return CGFloat(self)/393*winW
    }

}
extension Double {
    func byScaleWidth() -> CGFloat {//根据屏幕宽度适配
        return CGFloat(self)/393*winW
    }
}

extension UIDevice {//根据设备类型
    static func isX() -> Bool {
        if winmax >= 812 {
            return true
        }
        return false
    }
    
    static func isiPad() -> Bool {
        if UIDevice.current.model == "iPad" {
            return true
        }
        return false
    }
    
    static func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
}

public class SizeStylesWatch45: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesWatch45"
    public let cornerRadiusL = 12.0
    public let cornerRadiusM = 10.0
    public let cornerRadiusS = 6.0
    public let cornerRadiusXl = 16.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 100.0
    public let paddingL = 8.0
    public let paddingM = 6.0
    public let paddingS = 4.0
    public let paddingXl = 12.0
    public let paddingXs = 2.0
    public let paddingXxl = 16.0
    public let paddingXxs = 1.0
    public let scenePaddingBottom = 12.0
    public let scenePaddingHorizontal = 12.0
    public let scenePaddingTop = 8.0
    public let spacingL = 8.0
    public let spacingM = 6.0
    public let spacingS = 4.0
    public let spacingXl = 12.0
    public let spacingXs = 2.0
    public let spacingXxl:CGFloat = 16.0
    public let spacingXxs = 2.0
    public let spacingXxxs = 2.0
    
    
}

public class SizeStylesWatch49: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesWatch49"
    public let cornerRadiusL = 16.0
    public let cornerRadiusM = 12.0
    public let cornerRadiusS = 8.0
    public let cornerRadiusXl = 20.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 100.0
    public let paddingL = 12.0
    public let paddingM = 8.0
    public let paddingS = 6.0
    public let paddingXl = 16.0
    public let paddingXs = 4.0
    public let paddingXxl = 20.0
    public let paddingXxs = 2.0
    public let scenePaddingBottom = 16.0
    public let scenePaddingHorizontal = 16.0
    public let scenePaddingTop = 10.0
    public let spacingL = 12.0
    public let spacingM = 8.0
    public let spacingS = 6.0
    public let spacingXl = 16.0
    public let spacingXs = 4.0
    public let spacingXxl:CGFloat = 20.0
    public let spacingXxs = 2.0
    public let spacingXxxs = 2.0
    
    
}

public class SizeStylesWatch41: SizeStylesProtocal {
    public init() {}
    public let name: String = "SizeStylesWatch41"
    public let cornerRadiusL = 10.0
    public let cornerRadiusM = 8.0
    public let cornerRadiusS = 4.0
    public let cornerRadiusXl = 12.0
    public let cornerRadiusXs = 4.0
    public let cornerRadiusXxl = 100.0
    public let paddingL = 6.0
    public let paddingM = 4.0
    public let paddingS = 2.0
    public let paddingXl = 8.0
    public let paddingXs = 0.0
    public let paddingXxl = 12.0
    public let paddingXxs = 0.0
    public let scenePaddingBottom = 10.0
    public let scenePaddingHorizontal = 10.0
    public let scenePaddingTop = 6.0
    public let spacingL = 6.0
    public let spacingM = 4.0
    public let spacingS = 2.0
    public let spacingXl = 8.0
    public let spacingXs = 1.0
    public let spacingXxl:CGFloat = 12.0
    public let spacingXxs = 2.0
    public let spacingXxxs = 2.0
    
    
}



