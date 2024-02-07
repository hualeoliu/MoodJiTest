//
//  ReportTrendView.swift
//  Flowzland
//
//  Created by flowz-leo on 2023/12/25.
//

import SwiftUI

struct ReportTrendView: View {
    let weekStrs = [
        -1: NSLocalizedString("AVG", comment: ""),
        0: NSLocalizedString("MON", comment: ""),
        1: NSLocalizedString("TUE", comment: ""),
        2: NSLocalizedString("WED", comment: ""),
        3: NSLocalizedString("THU", comment: ""),
        4: NSLocalizedString("FRI", comment: ""),
        5: NSLocalizedString("SAT", comment: ""),
        6: NSLocalizedString("SUN", comment: ""),
    ]
    let flexWidth: CGFloat = UIScreen.main.bounds.width - 2*sizeStyles.spacingM

    @Environment(\.locale) private var locale

    let dataSir = DataHandleSir()
    @State var trendIndex : Int = 0 //传过来的or选中的 数据展示类型
    @State var weekSomeDay : Date = Date()//传过来的周
    
    @State private var trendColor = Color.pink
    @State private var trendName = ""
    @State private var weekIndex = -1 //图标竖线选中的周几 -1周平均
    @State private var weekday = "AVG"
    
    @State private var currentValue = "--"
    @State private var trendValue = 0
    @State private var lastValue = "--"

    let typesActive = [
        NSLocalizedString("Steps", comment: ""),
        NSLocalizedString("TimeInDaylight", comment: ""),
        NSLocalizedString("WHRV", comment: ""),
        NSLocalizedString("InBed", comment: ""),
        NSLocalizedString("SleepScreenTime", comment: ""),
        NSLocalizedString("HeartRate", comment: ""),
        NSLocalizedString("Awake", comment: ""),
        NSLocalizedString("REM", comment: ""),
        NSLocalizedString("Core", comment: ""),
        NSLocalizedString("Deep", comment: ""),
    ]
    @State private var colorsActive = [
        accentSteps,
        Color.blue,
        Color.pink,
        statusSleepWindDown,
        statusSleepScreenTime,
        Color.pink,
        statusSleepAwake,
        statusSleepRem,
        statusSleepCore,
        statusSleepDeep,
    ]

    @State private var isShowHeartRate = false
    @State private var dataTrend = [TrendModel]()
    @State private var isCanTap = true

    private func changeWeekday(_ index: Int) {
        weekIndex = index
        weekday = weekStrs[weekIndex] ?? ""
        
        var current: Double = 0
        var last: Double = 1
        if weekIndex == -1 {//周
            
        }else{
            weekSomeDay = weekSomeDay.sunday.prevDay(6 - index)
            current = dataTrend[index].sales
            last = dataTrend[index].salesLast
            switch trendIndex {
            case 3:
                currentValue = "\(current.hourNum)h \(current.minuteNum)m"
                lastValue = "\(last.hourNum)h \(last.minuteNum)m"
            default:
                currentValue = dataTrend[index].sales.twoString
                lastValue = dataTrend[index].salesLast.twoString
            }
  
        }
        
        if last == 0 {
            if current > 0 {
                trendValue = 100
            }else{
                trendValue = 0
            }
        }else{
            trendValue = Int((current - last)/last*100)
        }
    }
    
    private func changeTrend(_ index: Int) {
        trendIndex = index
        trendColor = colorsActive[trendIndex]
        trendName = typesActive[trendIndex]
        isShowHeartRate = trendIndex == 5
        
        dataSir.loadTrends(weekSomeDay: weekSomeDay, trendIndex: trendIndex) { t in
            dataTrend = t
            changeWeekday(-1)
        }
    }
    
    private func loadStart() {
        dataSir.reqHealthKit {
            changeTrend(trendIndex)
        }
    }

    private var headView: some View {
        HStack(alignment: .top, spacing: sizeStyles.spacingXs) {
            VStack(alignment: .leading, spacing: 6) {//last
                HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
                    Color(UIColor.secondaryLabel)
                        .frame(width: 12, height: 12)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                    Text("Last Week")
                        .font(TextStyles.subHeadline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text(lastValue)
                        .frame(height: 24)
                        .lineLimit(1).minimumScaleFactor(0.5)
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: sizeStyles.spacingXxxs) {
                    Text(weekday)
                        .font(TextStyles.subHeadline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .offset(y: 6)
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {//cur
                HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
                    trendColor
                        .frame(width: 12, height: 12)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                    Text(trendName)
                        .font(TextStyles.subHeadline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text(currentValue)
                        .frame(height: 24)
                        .lineLimit(1).minimumScaleFactor(0.5)
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: sizeStyles.spacingXxxs) {
                    Image(systemName: trendValue < 0 ? "arrow.down.forward.circle.fill" : "arrow.up.forward.circle.fill")
                        .font(TextStyles.title3Bold)
                    Text("\(abs(trendValue))%")
                        .font(TextStyles.title3Bold)
                    Spacer()
                }
                .foregroundColor(trendValue < 0 ? .red : .green)
                .opacity(trendValue == 0 ? 0.01 : 1)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .center, spacing: 14) {
                    headView

                    // 折线图
                    LineChartView(isPlot: $isShowHeartRate, currentColor: $trendColor, dataTemp: $dataTrend) { index in
                        changeWeekday(index)
                    }
                }
                .padding(.top, sizeStyles.paddingS)
                .padding(.bottom, sizeStyles.paddingL)
                .padding(.horizontal, sizeStyles.paddingS)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(sizeStyles.cornerRadiusXl)
                
                VStack(alignment: .leading, spacing: sizeStyles.spacingS) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("Select One To Show Trends")
                            .font(TextStyles.body)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.horizontal, sizeStyles.paddingXxs)

                    FlexibleView(data: typesActive, spacing: sizeStyles.paddingXs, availableWidth: flexWidth, alignment: .leading) { item in
                        Group {
                            if let idx = typesActive.firstIndex(of: item), idx < colorsActive.count {
                                HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
                                    colorsActive[idx]
                                        .frame(width: 12, height: 12)
                                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                                    Text(item)
                                        .font(TextStyles.subHeadline)
                                        .foregroundColor(Color(UIColor.label))
                                }
                                .padding(.horizontal, sizeStyles.paddingXs)
                                .padding(.vertical, sizeStyles.paddingS)
                                .background(trendIndex == idx ? accentSleepSecondary : Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(sizeStyles.cornerRadiusM)
                                .onTapGesture {
                                    if isCanTap {
                                        rigidDo()
                                        changeTrend(idx)
                                        
                                        isCanTap = false
                                        uiAfterDo(0.2) {//控制切换数据频率 减少性能压力
                                            isCanTap = true
                                        }
                                    }
                                }
                            }else{
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding(.top, sizeStyles.paddingXs)
            .padding(.bottom, sizeStyles.paddingXs)
            .padding(.horizontal, sizeStyles.paddingM)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("Trends", displayMode: .inline)
        }
        .onAppear {
            loadStart()
        }
    }
}
