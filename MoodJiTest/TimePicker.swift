//
//  NewTimePicker.swift
//  MoodJiTest
//
//  Created by flowz-leo on 2024/1/8.
//

import SwiftUI

struct TimePicker: View {
    @Binding var resultDate: Date
    @State private var selectedHour = 24 * 25 + 10
    @State private var selectedMin = 0

    private func numToDate(hour: Int = 0, minutes: Int = 0) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: 0)) ?? Date()
    }

    var body: some View {
        VStack {
            Text("Interactive ")
                .foregroundColor(.yellow)
                .fontWeight(.heavy)
                + Text("tutorials ")
                .foregroundColor(.orange)
                .strikethrough()
                + Text("for ")
                .foregroundColor(.red)
                .italic()
                + Text("SwiftUI")
                .foregroundColor(.purple)
                .underline()

            HStack(spacing: 0) {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(0 ..< 24 * 50, id: \.self) { t in
                        Text((t % 24).hourString)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                Picker("Min", selection: $selectedMin) {
                    ForEach([0, 30], id: \.self) { t in
                        Text(t.hourString).tag(t)
                    }
                }
                .pickerStyle(.wheel)
            }
            .padding(.horizontal, 60)
        }

        .padding()
        .onChange(of: selectedHour) { t in
            resultDate = numToDate(hour: selectedHour % 24, minutes: selectedMin)
        }
        .onChange(of: selectedMin) { t in
            resultDate = numToDate(hour: selectedHour % 24, minutes: selectedMin)
        }
        .onAppear {
            let hour = Calendar.current.component(.hour, from: resultDate)
            let minute = Calendar.current.component(.minute, from: resultDate)
            selectedMin = minute < 30 ? 0 : 30
            selectedHour = 24 * 25 + hour
        }
    }
}

extension Int {
    var hourString: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }
}

