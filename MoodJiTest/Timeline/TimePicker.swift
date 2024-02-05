//
//  NewTimePicker.swift
//  MoodJiTest
//
//  Created by flowz-leo on 2024/1/8.
//

import SwiftUI

struct TimePicker: View {
    @Binding var resultTimestamp: Double
    @State private var selectedHour = 0
    @State private var selectedMin = 0
    private let loopNum = 30
    private let minInterval = 5
    private let horizontalPadding = 44

    var body: some View {
        HStack(spacing: 0) {
            Picker("Hour", selection: $selectedHour) {
                ForEach(0 ..< 24 * loopNum, id: \.self) { t in
                    Text((t % 24).twoString)
                }
            }
            .pickerStyle(WheelPickerStyle())

            Picker("Min", selection: $selectedMin) {
                ForEach(0 ..< 12, id: \.self) { t in
                    Text((t * minInterval).twoString).tag(t)
                }
            }
            .pickerStyle(.wheel)
        }
//        .padding(.horizontal, horizontalPadding.scaleLength)
        .onChange(of: selectedHour) { t in
            resultTimestamp = Double(((selectedHour % 24) * 60 + selectedMin * minInterval) * 60)
        }
        .onChange(of: selectedMin) { t in
            resultTimestamp = Double(((selectedHour % 24) * 60 + selectedMin * minInterval) * 60)
        }
        .onAppear {
            let hour = resultTimestamp.hourNum
            let minute = resultTimestamp.minuteNum
            selectedHour = 24 * loopNum / 2 + hour
            selectedMin = minute / minInterval
        }
    }
}

var everyDayStamp: Double {
    24 * everyHourStamp
}

var everyHourStamp: Double {
    60 * 60
}

extension Double {
    var twoString: String {
        return Int(self).twoString
    }

    var hourNum: Int {
        return Int(self).hourNum
    }

    var minuteNum: Int {
        return Int(self).minuteNum
    }
}

extension Int {
    var twoString: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }

    var hourNum: Int {
        return self / 60 / 60
    }

    var minuteNum: Int {
        return self / 60 % 60
    }
}
