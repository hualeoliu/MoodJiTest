//
//  ScheduleBean.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/15.
//

import Foundation

struct ScheduleBean: Hashable, Codable {
    var days: [Int]?
    var start: Date?
    var end: Date?
}
extension ScheduleBean {
    init?(by dic: NSDictionary) {
        let days = dic["days"] as? [Int]
        let start = dic["start"] as? Date
        let end = dic["end"] as? Date
        print(dic["days"] as? [Int], dic["start"] as? Date, dic["end"] as? Date)
        
        self.days = days
        self.start = start
        self.end = end
    }
}


