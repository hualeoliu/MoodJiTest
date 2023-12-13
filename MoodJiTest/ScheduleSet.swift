//
//  ScheduleSet.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import SwiftUI

struct ScheduleSet: View {
    @EnvironmentObject var coloState : MainColorModel

    @State var curTapIdx = 0
    
    var body: some View {
        VStack {
            Spacer().frame(height: 24)
            Text("Set your sleep schedule")
                .font(TextStyles.title3Bold)
                .foregroundColor(Color(UIColor.label))
            Text("Tell Moodji your schedule to know you better.\nDon't worry, an approximate time is enough")
                .padding(.top, 8)
                .font(TextStyles.body)
                .lineSpacing(3)
                .foregroundColor(Color(UIColor.tertiaryLabel))
            
            Spacer().frame(height: 30)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                HStack {
                    HStack {
                        Spacer()
                        Image(systemName: "bed.double.fill")
                        Text("SLEEP")
                            .font(TextStyles.title3Bold)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                    }
                    .onTapGesture {
                        curTapIdx = 0
                    }
                    
                    HStack {
                        Spacer()
                        Image(systemName: "building.2.fill")
                        Text("WORK")
                            .font(TextStyles.title3Bold)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                    }
                    .onTapGesture {
                        curTapIdx = 1
                    }
                }
                .frame(height: 50)

                Image(uiImage: UIImage(named: "schedule_taped")!.withRenderingMode(.alwaysTemplate)).offset(x: curTapIdx == 0 ? -90 : 90, y: 0).animation(.easeIn)
            })

            Spacer().frame(height: 24)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: 16, content: {
                    Text("Placeholder")
                })
            })
            
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.systemGroupedBackground))
        .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
        .foregroundColor(curTapIdx == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime)
        .ignoresSafeArea()

    }
    
}

struct ScheduleSet_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSet()
    }
}
