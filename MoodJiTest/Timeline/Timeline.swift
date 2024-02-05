//
//  Timeline.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/24.
//




import SwiftUI

class TimelineEnvBean: ObservableObject {
    @Published var times: [TimelineBean] = []
    var timeDatas: [TimelineDataBean] = []
    var isEditing = false

    func loadStart() {
        if let data = UserDefaults.standard.value(forKey: timeLinesUDName) as? String {
            let json = data.data(using: .utf8)!
            do {
                timeDatas = try JSONDecoder().decode([TimelineDataBean].self, from: json)
                timeDatas.forEach { t in
                    let line = TimelineBean()
                    line.name = t.name
                    line.weekIdxs = t.weekIdxs
                    line.cells = t.cells
                    line.isReal = true
                    times += [line]
                }
            } catch let ero {
                UserDefaults.standard.removeObject(forKey: timeLinesUDName)
                print("nnd 时间线数据读取出错\(ero.localizedDescription)")
            }
        } else {
            let line = TimelineBean()
            line.isReal = true
            line.name = "One day"
            line.weekIdxs = [0, 1, 2, 3, 4, 5, 6]
            times += [line]

            toJsonAndUDSave()
        }

        times.forEach { t in
            t.weekIdxs = t.weekIdxs.sorted()
            t.weekIdxsLast = t.weekIdxs
        }
        times = times.sorted(by: { $0.weekIdxs.first ?? 7 < $1.weekIdxs.first ?? 7 })

    }

    func getBlankString(_ all: [Int]) -> String {
        var str = ""
        for idx in 0 ..< all.count {
            if idx == 0 {
                str = weeksShort[all[idx]]
            } else {
                str += ",\(weeksShort[all[idx]])"
            }
        }
        return str
    }

    func isChangedWeekidx() -> Bool {
        var isChange = false
        times.forEach { t in
            if t.weekIdxs != t.weekIdxsLast {
                isChange = true
            }
        }
        return isChange
    }

    func findBalnkWeekidx() -> [Int] {
        var all = [Int]()
        for idx in 0 ..< 7 {
            var isHas = false
            times.forEach { t in
                if t.weekIdxs.contains(idx) {
                    isHas = true
                }
            }
            if !isHas {
                all += [idx]
            }
        }
        return all
    }

    func refreshList() {
        times.append(TimelineBean())
        times.removeAll { t in
            !t.isReal
        }
    }

    func toJsonAndUDSave() {

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            timeDatas.removeAll()
            times.forEach { t in
                if t.isReal {
                    var bean = TimelineDataBean()
                    bean.cells = t.cells
                    bean.name = t.name
                    bean.weekIdxs = t.weekIdxs
                    timeDatas += [bean]
                }
            }
            let jsonData = try encoder.encode(timeDatas)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                UserDefaults.standard.setValue(jsonString, forKey: timeLinesUDName)
                UserDefaults.standard.synchronize()
            }

            var weekDic = [Int: [TimeCellBean]]()
            for idx in 0 ..< 7 {
                var timeArr = [TimeCellBean]()
                times.forEach { t in
                    if t.isReal {
                        if t.weekIdxs.contains(idx) {
                            t.cells.forEach { bean in
                                var newBean = bean
                                newBean.typeName = newBean.type.name
                                timeArr += [newBean]
                            }
                        }
                    }
                }

                weekDic[idx] = timeArr
            }
            let json1Data = try encoder.encode(weekDic)
            if let jsonString = String(data: json1Data, encoding: .utf8) {
                UserDefaults.standard.setValue(jsonString, forKey: timeLinesWeekUDName)
                UserDefaults.standard.synchronize()
            }

        } catch let ero {
            print("nnd 保存时间线数据ud出错\(ero.localizedDescription)")
        }
    }
    
}

class TimelineBean: ObservableObject, Identifiable, Equatable {
    var id: UUID = .init()
    var isReal = false
    @Published var name: String = ""
    var cells: [TimeCellBean] = [TimeCellBean()]
    @Published var weekIdxs: [Int] = []
    @Published var weekIdxsLast: [Int] = []

    static func == (lhs: TimelineBean, rhs: TimelineBean) -> Bool {
        return lhs.id == rhs.id
    }

    func isContentEquleTo(_ bean: TimelineBean) -> Bool {
        return cells == bean.cells
    }
}

struct TimelineDataBean: Codable, Identifiable {
    var id: UUID = .init()
    var isReal = true
    var name: String = ""
    var cells: [TimeCellBean] = []
    var weekIdxs: [Int] = []
}

struct TimeCellBean: Codable, Identifiable, Equatable {
    var id: UUID = .init()
    var isReal = true // 数据刷新需要
    var isFirst = true // 数据需要
    var type: Timeline = .Sleep //
    var typeName: String = "" //
    var firstStamp: Double = 7.5 * everyHourStamp // 时间戳 每天共24*60*60=86400
    var secStamp: Double = 23 * everyHourStamp
    var duration: Double = 7.5 * 60 // 分钟数 在睡眠和工作中为目标

    static func == (lhs: TimeCellBean, rhs: TimeCellBean) -> Bool {
        return lhs.type == rhs.type && lhs.firstStamp == rhs.firstStamp && lhs.secStamp == rhs.secStamp && lhs.duration == rhs.duration
    }
}

enum Timeline: Codable {
    case Sleep, Study, Work, Nap

    var name: String {
        switch self {
            case .Sleep: return NSLocalizedString("SLEEP", comment: "")
            case .Study: return NSLocalizedString("STUDY", comment: "")
            case .Work: return NSLocalizedString("WORK", comment: "")
            case .Nap: return NSLocalizedString("NAP", comment: "")
        }
    }

    var firstIcon: String {
        switch self {
            case .Sleep: return "sun.max.fill"
            case .Study: return "book.fill"
            case .Work: return "laptopcomputer"
            case .Nap: return "zzz"
        }
    }

    var secIcon: String {
        switch self {
            case .Sleep: return "bed.double.fill"
            case .Study: return "book.fill"
            case .Work: return "house.fill"
            case .Nap: return "zzz"
        }
    }

    var firstName: String {
        switch self {
            case .Sleep: return NSLocalizedString("Wake Up", comment: "")
            case .Study: return NSLocalizedString("Start", comment: "")
            case .Work: return NSLocalizedString("Start", comment: "")
            case .Nap: return NSLocalizedString("Start", comment: "")
        }
    }

    var secName: String {
        switch self {
            case .Sleep: return NSLocalizedString("Bedtime", comment: "")
            case .Study: return NSLocalizedString("End", comment: "")
            case .Work: return NSLocalizedString("End", comment: "")
            case .Nap: return NSLocalizedString("End", comment: "")
        }
    }

    func mainColor() -> Color {
        switch self {
            case .Sleep: return Color.indigo
            case .Study: return Color.brown
            case .Work: return Color.indigo
            case .Nap: return Color.green
        }
    }

    func secColor() -> Color {
        switch self {
            case .Sleep: return Color.blue
            case .Study: return Color.brown
            case .Work: return Color.purple
            case .Nap: return Color.green
        }
    }

    var mainBgColor: Color {
        switch self {
            case .Sleep: return Color(red: 0.35, green: 0.67, blue: 0.88, opacity: 0.20)
            case .Study: return Color(red: 0.64, green: 0.52, blue: 0.37, opacity: 0.20)
            case .Work: return Color(red: 0.35, green: 0.34, blue: 0.84, opacity: 0.20)
            case .Nap: return Color(red: 0.20, green: 0.78, blue: 0.35, opacity: 0.20)
        }
    }
}

let timeLinesUDName = "TimelinesBeans"
let timeLinesWeekUDName = "TimelinesWeekBeans"
let timeLineIntroDone = "TimelineIntroduceDone"

let weeksShort = [
    NSLocalizedString("Weekday.Monday.short", comment: ""),
    NSLocalizedString("Weekday.Tuesday.short", comment: ""),
    NSLocalizedString("Weekday.Wensday.short", comment: ""),
    NSLocalizedString("Weekday.Thursday.short", comment: ""),
    NSLocalizedString("Weekday.Friday.short", comment: ""),
    NSLocalizedString("Weekday.Satauday.short", comment: ""),
    NSLocalizedString("Weekday.Sunday.short", comment: ""),
]

