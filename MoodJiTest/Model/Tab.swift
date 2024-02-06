//
//  SwiftUIView.swift
//  MoodJiTest
//
//  Created by flowz-leo on 2024/1/8.
//

import SwiftUI

extension Date {
    var sunday: Date {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date)
        let startOfWeek = calendar.date(from: components)!.prevDay(-7)
        return startOfWeek
    }
    
    func prevDay(_ num: Int = 1) -> Date {
        NSCalendar.current.date(byAdding: .day, value: -num, to: self)!
    }
    
    var weekdayIdx: Int {
        let endDate = self.sunday
        let calendar = Calendar.current
        let num = calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: endDate).day ?? 0
        return 6 - num
    }
    
    var weekIdx: Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfYear, from: self)
    }
    
    func numToDate(_ hour: Int = 0, _ minutes: Int = 0, _ sec: Int = 0) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let comp = DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: sec)
        return calendar.date(from: comp) ?? Date()
    }
    
    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    var endOfDay: Date {
        return self.numToDate(23, 59, 59)
    }
    
    var dayZero: Int {
        let calendar = Calendar.current
        return Int(calendar.startOfDay(for: self).timeIntervalSince1970)
    }
    
    var locatStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.locale = Locale.current
        let localizedDateString = dateFormatter.string(from: self)
//        print("本地化日期: \(localizedDateString)")
        return localizedDateString
    }
}
