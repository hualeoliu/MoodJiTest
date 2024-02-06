//
//  LineChartView.swift
//  Flowzland
//
//  Created by flowz-leo on 2023/12/26.
//

import Charts
import SwiftUI

struct LineChartView: View {
    let chartBgColor = Color(UIColor.secondarySystemGroupedBackground)
    
    @Binding var isPlot: Bool
    @Binding var currentColor: Color
    @Binding var dataTemp: [TrendModel]
    @State private var dataFirst = TrendModel()
    
    var selectDoBlock: ((Int) -> Void)? // 选中星期index -1为平均
    
    @State private var lastColor: Color = .systemFill
    @State private var selectedElement: TrendModel? = nil
    
    private func getLine(_ marker: TrendModel, _ type: Int) -> some ChartContent { // 0last 1cur
        return LineMark(x: .value("Weekday", marker.day),
                        y: .value("Sales", type == 0 ? marker.salesLast : marker.sales),
                        series: .value("series", "\(type)"))
        .foregroundStyle((type == 0 ? lastColor : currentColor).opacity(selectedElement == nil ? 1 : 0.3))
        .lineStyle(StrokeStyle(lineWidth: 2))
        .interpolationMethod(.monotone)
        .offset(y: -10)
    }
    
    private var chart: some View {
        Chart(dataTemp, id: \.day) { marker in
            let alpha = selectedElement == nil || selectedElement?.day == marker.day ? 1 : 0.3
            if isPlot {
                Plot {
                    BarMark(
                        x: .value("Weekday", marker.day),
                        yStart: .value("BPM Min", marker.heartRateLastMin),
                        yEnd: .value("BPM Max", marker.heartRateLastMax),
                        width: .fixed(8)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle((lastColor).gradient.opacity(alpha))
                    .offset(x: -6)
                    
                    BarMark(
                        x: .value("Weekday", marker.day),
                        yStart: .value("BPM Min", marker.heartRateMin),
                        yEnd: .value("BPM Max", marker.heartRateMax),
                        width: .fixed(8)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle((currentColor).gradient.opacity(alpha))
                    .offset(x: 6)
                }
            }else{
                let lastLine = getLine(marker, 0)
                let lastColor = (selectedElement == nil ? Color.systemFill : (selectedElement?.day == marker.day ? Color.gray : Color.systemFill))
                lastLine.symbol {
                    let circleColor = lastColor.opacity(alpha)
                    Circle()
                        .strokeBorder(chartBgColor, lineWidth: 1.5)
                        .frame(width: 10)
                        .overlay(Circle()
                            .stroke(circleColor, lineWidth: 2)
                            .frame(width: 6)
                            .background {
                                Circle().foregroundStyle(selectedElement == nil ? chartBgColor : (selectedElement?.day == marker.day ? lastColor : chartBgColor))
                            }
                        )
                }
                if Date().startOfDay.dayZero >= marker.day.dayZero {
                    let curLine = getLine(marker, 1)
                    curLine.symbol {
                        let circleColor = currentColor.opacity(alpha)
                        Circle()
                            .strokeBorder(chartBgColor, lineWidth: 1.5)
                            .frame(width: 10)
                            .overlay(Circle()
                                .stroke(circleColor, lineWidth: 2)
                                .frame(width: 6)
                                .background {
                                    Circle().foregroundStyle(selectedElement == nil ? chartBgColor : (selectedElement?.day == marker.day ? currentColor : chartBgColor))
                                }
                            )
                    }
                }
            }
            
        }
        .animation(.smooth(duration: 0.3), value: dataTemp)
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let idx = findElementIndex(location: value.location, geometry: geo)
                                let element = dataTemp[idx]
                                if selectedElement?.day == element.day { // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                    selectDoBlock?(-1)
                                } else {
                                    selectedElement = element
                                    selectDoBlock?(idx)
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        let idx = findElementIndex(location: value.location, geometry: geo)
                                        selectedElement = dataTemp[idx]
                                        selectDoBlock?(idx)
                                    }
                            )
                    )
            }
        }
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if let element = selectedElement {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: element.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                        
                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY + 40
                        Rectangle().fill(Color.label)
                            .frame(width: 1, height: lineHeight)
                            .position(x: lineX, y: lineHeight/2 - 39)
                    }
                }
            }
        }
        .chartYAxis {
            
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        let weeks = ["M", "T", "W", "T", "F", "S", "S"]
                        Text("\(weeks[date.weekdayIdx])")
                            .font(TextStyles.subHeadline)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }
            }
        }
        
    }
    
    private func findElementIndex(location: CGPoint, geometry: GeometryProxy) -> Int {
        let idx = location.x / geometry.size.width * 6.8
        return min(Int(idx), 6)
    }
    
    var body: some View {
        chart
            .padding(.top, 34)
            .padding(.horizontal, 15)
            .background(
                ZStack(alignment: .topLeading) {
                    VStack {
                        ZStack(alignment: Alignment.topTrailing, content: { // 折线图最大纵坐标
                            Rectangle().fill(Color(UIColor.systemFill)).frame(height: 2)
                            HStack {
                                Text(selectedElement?.day.locatStr ?? "\(dataFirst.day.weekIdx.twoString) week")
                                Spacer()
                                Text(dataFirst.chartMax)
                            }
                            .padding(.top, 2)
                            .font(.system(size: 12).weight(.semibold))
                        })
                        .offset(y: -0)
                        Spacer()
                        ZStack(alignment: Alignment.bottomTrailing, content: { // 折线图最小纵坐标
                            Rectangle().fill(Color(UIColor.systemFill)).frame(height: 2)
                        })
                        .offset(y: -30)
                    }
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    //                    .background(Color.pink.opacity(0.3))
                }
            )
            .allowsHitTesting(true)
            .onChange(of: currentColor) { newValue in
                selectedElement = nil
            }
            .onChange(of: dataTemp) { newValue in
                selectedElement = nil
                dataFirst = dataTemp.first ?? TrendModel()
            }
            .onAppear {
                
            }
    }
}
