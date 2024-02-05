//
//  TimeCell.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/23.
//

import SwiftUI

struct TimeCell: View {
    @State private var isOpen = true
    @State private var showStartTimePick = false // fix
    @State private var showEndTimePick = false

    @Binding var mBean: TimeCellBean
    var cellDoBlock: ((_ type: Int) -> Void)?

    private func loadStart() {}

    var body: some View {
        VStack(alignment: .leading, spacing: sizeStyles.spacingXs) {
            HStack(alignment: .center, spacing: 8) {
                Text(mBean.type.name)
                    .font(TextStyles.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(mBean.type.mainColor())
                Spacer(minLength: 0)
                if mBean.type != .Sleep {
                    Toggle("", isOn: $isOpen)
                        .onChange(of: isOpen) { newValue in
                            if !isOpen {
                                uiAfterDo(0.14) {
                                    cellDoBlock?(0) // close
                                }
                            }
                        }
                } else {
                    if !isGoalMeet() {
                        Text("Does not meet your sleep goal")
                            .font(TextStyles.subHeadlineSemibold)
                            .foregroundColor(accentWarning)
                    }
                }
            }
            .padding(.leading, sizeStyles.paddingXxs)
            .padding(.bottom, sizeStyles.paddingXs)

            VStack(alignment: .leading, spacing: 0) {
                if mBean.type != .Work {
                    durationView
                }

                timeView()
                if showStartTimePick {
                    TimePicker(resultTimestamp: $mBean.firstStamp)
                        .overlay(alignment: .top, content: {
                            Divider()
                        })
                }

                if mBean.type == .Work || mBean.type == .Sleep {
                    timeView(isStart: false)
                }
                if showEndTimePick {
                    TimePicker(resultTimestamp: $mBean.secStamp)
                        .overlay(alignment: .top, content: {
                            Divider()
                        })
                }

                if mBean.type == .Work || mBean.type == .Study {
                    appView
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.top, sizeStyles.paddingS)
        .padding(.bottom, sizeStyles.paddingXs)
        .padding(.horizontal, sizeStyles.paddingS)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(sizeStyles.cornerRadiusL)
        .onAppear(perform: {
            loadStart()
        })
        .onTapGesture {
            cellDoBlock?(2) // 空白点击
        }
    }

    func isGoalMeet() -> Bool {
//        return true
//        if mBean.secStamp > mBean.firstStamp {
//            
//        } else {
//            
//        }
        
        var stamp = abs(mBean.secStamp - mBean.firstStamp)
        stamp = stamp > 12 * everyHourStamp ? everyDayStamp - stamp : stamp
        return stamp > mBean.duration * 60
    }
    
    private var durationView: some View {
        HStack(alignment: .center) {
            Button {
                rigidDo()
                mBean.duration -= 15
                mBean.duration = max(15, mBean.duration)
            } label: {
                Image(systemName: "minus")
                    .font(TextStyles.headline)
                    .frame(width: 40, height: 40)
                    .background(mBean.type.mainBgColor)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                    .foregroundColor(Color(UIColor.label))
            }

            Spacer(minLength: 0)
            VStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
                Group {
                    if #available(iOS 17.0, *) {
                        Text("\(Int(mBean.duration) / 60): \((Int(mBean.duration) % 60).twoString)")
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                            }
                    } else {
                        Text("\(Int(mBean.duration) / 60): \((Int(mBean.duration) % 60).twoString)")
                    }
                }
                .frame(width: 100)
                .font(TextStyles.title2.weight(.heavy))
                .foregroundColor(Color(UIColor.label))

                Text(mBean.type == .Sleep ? "Time Asleep Goal" : "DURATION")
                    .font(TextStyles.footnoteSemibold)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }

            Spacer(minLength: 0)
            Button {
                rigidDo()
                mBean.duration += 15
            } label: {
                Image(systemName: "plus")
                    .font(TextStyles.headline)
                    .foregroundColor(Color(UIColor.label))
                    .frame(width: 40, height: 40)
                    .background(mBean.type.mainBgColor)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
            }
        }
        .padding(.vertical, sizeStyles.paddingL)
        .padding(.horizontal, sizeStyles.paddingXxs)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private func timeView(isStart: Bool = true) -> some View {
        HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
            Image(systemName: isStart ? mBean.type.firstIcon : mBean.type.secIcon)
                .font(TextStyles.headline)
                .foregroundColor(isStart ? mBean.type.mainColor() : mBean.type.secColor())
            Text(isStart ? mBean.type.firstName : mBean.type.secName)
                .font(TextStyles.headline)
                .foregroundColor(Color(UIColor.label))
            Spacer(minLength: 0)
            Text("\((isStart ? mBean.firstStamp : mBean.secStamp).hourNum.twoString):\((isStart ? mBean.firstStamp : mBean.secStamp).minuteNum.twoString)")
                .font(TextStyles.headline)
                .foregroundColor((isStart && showStartTimePick) || (!isStart && showEndTimePick) ? accentWarning : Color(UIColor.label))
                .padding(.all, sizeStyles.paddingS)
                .background((isStart && showStartTimePick) || (!isStart && showEndTimePick) ? accentWarning.opacity(0.2) : mBean.type.mainBgColor)
                .cornerRadius(sizeStyles.cornerRadiusXxl)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        rigidDo()
                        if isStart {
                            showStartTimePick.toggle()
                            if showEndTimePick {
                                showEndTimePick.toggle()
                            }
                        } else {
                            showEndTimePick.toggle()
                            if showStartTimePick {
                                showStartTimePick.toggle()
                            }
                        }
                    }
                }
        }
        .padding(.leading, sizeStyles.paddingXxs)
        .padding(.vertical, sizeStyles.paddingM)
        .overlay(alignment: .top) {
            if !isStart {
                Divider()
            }
        }
    }

    private var appView: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: sizeStyles.spacingXs) {
                HStack(alignment: .center, spacing: 8) {
                    Text(mBean.type == .Work ? "Choose App For Working" : "Choose App For Studying")
                        .font(TextStyles.headline)
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.up.right")
                        .font(TextStyles.headline)
                }
                .foregroundColor(mBean.type.mainColor())
                .frame(maxWidth: .infinity)
                Text("The screen time of the selected App will be automatically counted as focused")
                    .font(TextStyles.subHeadline)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, sizeStyles.paddingXxs)
        .padding(.top, sizeStyles.paddingXl)
        .padding(.trailing, sizeStyles.paddingXs)
        .padding(.bottom, sizeStyles.paddingM)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
