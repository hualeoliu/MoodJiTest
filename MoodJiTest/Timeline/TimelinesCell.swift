//
//  TimelinesCell.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/23.
//


import SwiftUI

struct TimelinesCell: View {
    @State private var isPage = false

    @Binding var mBean: TimelineBean
    @EnvironmentObject var mEnvBean: TimelineEnvBean

    var body: some View {
        if mBean.isReal {
            VStack(alignment: .leading, spacing: sizeStyles.spacingXxs) {
                HStack(spacing: sizeStyles.spacingXs) {
                    Capsule()
                        .fill(mBean.weekIdxs.isEmpty ? Color(UIColor.systemFill) : accentScreenTime)
                        .frame(width: 5, height: 16)
                    Text(mBean.name)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                    Text("Edit")
                        .multilineTextAlignment(.center)
                        .foregroundColor(accentWarning)
                        .sheet(isPresented: $isPage) {
                            TimelineEditView(isAdd: false, mBean: $mBean)
                        }
                        .containerShape(Rectangle())
                        .onTapGesture {
                            rigidDo()
                            isPage.toggle()
                        }
                }
                .font(TextStyles.subHeadlineSemibold)

                TimeColorView(mCells: $mBean.cells, strokeColor: Color(UIColor.secondarySystemGroupedBackground))
                    .padding(.vertical, sizeStyles.paddingL)
                    .overlay(alignment: .bottom) {
                        Divider()
                    }

                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0 ..< 7, id: \.self) { idx in
                        setWeekday(idx: idx, idx == 6)
                    }
                }
                .padding(.top, sizeStyles.paddingM)
                .animation(nil)
//                .padding(.bottom, sizeStyles.paddingS)
            }
            .padding(.horizontal, sizeStyles.paddingM)
            .padding(.top, sizeStyles.paddingM)
            .padding(.bottom, sizeStyles.paddingS)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(sizeStyles.cornerRadiusL)
            .onAppear {
//                mBean.weekIdxsLast = mBean.weekIdxs
            }
        } else {
            EmptyView()
        }
    }

    private func pointColor(_ idx: Int) -> Color {
        if mEnvBean.findBalnkWeekidx().contains(idx) {
            return .clear
        }
        if !mBean.weekIdxsLast.contains(idx) && mBean.weekIdxs.contains(idx) {
            return accentScreenTime
        }
        if mBean.weekIdxsLast.contains(idx) && !mBean.weekIdxs.contains(idx) {
            return accentWarning
        }
        return mBean.weekIdxs.contains(idx) ? Color.clear : Color(UIColor.quaternaryLabel)
    }

    private func setWeekday(idx: Int, _ isEnd: Bool = false) -> some View {
        Group {
            VStack(alignment: .center, spacing: sizeStyles.spacingXs) {
                Text(weeksShort[idx])
                    .font(TextStyles.headline)
                    .foregroundColor(mBean.weekIdxs.contains(idx) ? Color.white : Color(UIColor.label))
                    .frame(width: 36, height: 36)
                    .background(mBean.weekIdxs.contains(idx) ? accentScreenTime : Color.clear)
                    .clipShape(Circle())
                    .overlay {
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                            .inset(by: 0.5)
                            .stroke(Color(UIColor.systemFill), lineWidth: 1)
                    }

                Circle()
                    .fill(pointColor(idx))
                    .frame(width: 5, height: 5)
            }
            .onTapGesture {
                mEnvBean.times.forEach { bean in
                    if let idx = bean.weekIdxs.firstIndex(of: idx) {
                        bean.weekIdxs.remove(at: idx)
                    } else {
                        bean.weekIdxs += [idx]
                    }
                    if mBean != bean, let idx = bean.weekIdxs.firstIndex(of: idx) {
                        bean.weekIdxs.remove(at: idx)
                    }
                }

                mEnvBean.refreshList()
                rigidDo()
            }

            if !isEnd {
                Spacer(minLength: 0)
            }
        }
    }
}
