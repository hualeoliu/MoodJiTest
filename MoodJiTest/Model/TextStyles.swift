//
//  TextStyles.swift
//  Flowzland
//
//  Created by 老游 on 2023/09/04.
//

import Foundation
import SwiftUI

public enum TextStyles {
    public static let largeTitle = Font.system(.largeTitle, design: .rounded)//34
    public static let title = Font.system(.title, design: .rounded)//28
    public static let title2 = Font.system(.title2, design: .rounded)//22
    public static let title3 = Font.system(.title3, design: .rounded)//20
    public static let title3Heavy = Font.system(.title3, design: .rounded).weight(.heavy)
    public static let title3Bold = Font.system(.title3, design: .rounded).weight(.bold)
    
    public static let headline = Font.system(.headline, design: .rounded)//18
    public static let headlineHeavy = Font.system(.headline, design: .rounded).weight(.heavy)
    
    public static let body = Font.system(.body, design: .rounded)//17
    public static let bodySemibold = Font.system(.body, design: .rounded).weight(.semibold)//17 600
    public static let bodyBold = Font.system(.body, design: .rounded).weight(.bold)//17 700
    public static let callout = Font.system(.callout, design: .rounded)//16
    public static let subHeadline = Font.system(.subheadline, design: .rounded)//15
    public static let subHeadlineRegular = Font.system(.subheadline, design: .rounded).weight(.regular)//15 400
    public static let subHeadlineSemibold = Font.system(.subheadline, design: .rounded).weight(.semibold)//600
    public static let footnote = Font.system(.footnote, design: .rounded)//13
    public static let footnoteSemibold = Font.system(.footnote, design: .rounded).weight(.semibold)
    public static let caption1 = Font.system(.caption, design: .rounded)//12
    public static let caption2 = Font.system(.caption2, design: .rounded)//11
    public static let smallNote = Font.system(size: 12, design: .rounded)
}


enum SFSymbol: String {
    case arrowUpRight = "arrow.up.right"
    case chevronForward = "chevron.forward"
    case heartTextSquareFill = "heart.text.square.fill"
    case gearshapeFill = "gearshape.fill"
    case applewatchWatchface = "applewatch.watchface"
    case questionmarkCircleFill = "questionmark.circle.fill"
    case paperplane
    case moonphaseWaningGibbousInverse = "moonphase.waning.gibbous.inverse"
    case textformat
    case infoCircleFill = "info.circle.fill"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case ellipsisBubbleFill = "ellipsis.bubble.fill"
    case exclamationmarkCircle = "exclamationmark.circle"
    case hourglass
    case bedDoubleFill = "bed.double.fill"
    case paintPaletteFill = "paintpalette.fill"
    case calendar
    case calendarClock = "calendar.badge.clock"
}
