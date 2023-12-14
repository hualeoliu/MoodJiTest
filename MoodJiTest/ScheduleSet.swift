//
//  ScheduleSet.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import SwiftUI

struct ScheduleSet: View {
    @EnvironmentObject var coloState : MainColorModel
    @Binding var isPresented: Bool
    @Binding var mDic: [String: Any]
    let weekStrs = ["M", "T", "W", "T", "F", "S", "S"]
    
    func isSelected(idx: Int) -> Bool {
        let days = mDic["days"] as? [Int]
        if let t = days {
            return t.contains(idx)
        }
        return false
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    VStack {
                        Image(coloState.timeType == 0 ? "schedule_sleep" : "schedule_work")
                        Text(coloState.timeType == 0 ? "SLEEP" : "WORK").font(TextStyles.headline).foregroundColor(Color(UIColor.label))
                    }
                    Spacer()
                }
                
                Text("CHOOSE DAYS").font(TextStyles.subHeadline).foregroundColor(Color(UIColor.secondaryLabel))
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    ForEach(0..<weekStrs.count, id: \.self) { idx in
                        Text(weekStrs[idx]).font(TextStyles.headline).foregroundColor(Color(UIColor.label))
                            .background(isSelected(idx: idx) ? (coloState.timeType == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime) : Color.clear)
                            .frame(width: 36, height: 36, alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(UIColor.systemFill), lineWidth: 1))
                        Spacer()
                    }
                }
                .padding(SizeStylesPro().spacing16)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(SizeStylesPro().spacing16)
                
                Text("TIME").font(TextStyles.subHeadline).foregroundColor(Color(UIColor.secondaryLabel))
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Start").font(TextStyles.body).foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("09:00")
                    }
                    .padding(SizeStylesPro().spacing12)
                    
                    HStack {
                        Text("End").font(TextStyles.body).foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("19:00")
                    }
                    .padding(SizeStylesPro().spacing12)
                }
                .padding(SizeStylesPro().spacing16)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(SizeStylesPro().spacing16)
                
                Spacer()
            }
            .padding(SizeStylesPro().spacing16)
            
            
            .navigationBarTitle(Text("Schedule")).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:  Button(action: {
                isPresented.toggle()
            }) {
                Text("Cancel").font(.body)
            }, trailing: Button(action: {
                isPresented.toggle()
                
            }) {
                Text("Done")
            })
        }
        .background(Color(UIColor.systemGroupedBackground))
        .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
        .foregroundColor(coloState.timeType == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime)
        .environmentObject(coloState)
        .onAppear(perform: {
            UINavigationBar.appearance().backgroundColor = UIColor.clear
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().shadowImage = UIImage()
            
        })
    }
}

