//
//  ScheduleSet.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/13.
//

import SwiftUI

var listBlock: (()->())?
struct ScheduleList: View {
    @EnvironmentObject var coloState : MainColorModel
    @State private var isPopoverVisible = false
    
    @State var curArr = [ScheduleBean]()
    let centerOffset = (winW-(16.byScaleWidth())*2)/4
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 24.byScaleWidth())
            Text("Set your sleep schedule")
                .font(TextStyles.title3Bold)
                .foregroundColor(Color(UIColor.label))
            Text("Tell Moodji your schedule to know you better.\nDon't worry, an approximate time is enough")
                .padding(.top, 8.byScaleWidth())
                .font(TextStyles.body)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor.tertiaryLabel))
            
            Spacer().frame(height: SizeStylesPro().spacingXxl)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                HStack {
                    HStack(alignment: .center, spacing: SizeStylesPro().paddingXxs.byScaleWidth(), content: {
                        Spacer()
                        Image(systemName: "bed.double.fill")
                        Text("SLEEP")
                            .font(TextStyles.subHeadlineSemibold)
                        Spacer()
                    })
                    .foregroundColor(coloState.timeType == 0 ? ColorStylesDark().accentSleep : Color(UIColor.tertiaryLabel))
                    .onTapGesture {
                        coloState.timeType = 0
                        dataLoadDo()
                    }
                    
                    HStack {
                        Spacer()
                        Image(systemName: "building.2.fill")
                        Text("WORK")
                            .font(TextStyles.subHeadlineSemibold)
                        Spacer()
                    }
                    .foregroundColor(coloState.timeType == 1 ? ColorStylesDark().accentScreenTime : Color(UIColor.tertiaryLabel))
                    .onTapGesture {
                        coloState.timeType = 1
                        dataLoadDo()
                    }
                }
                .frame(height: 50)//应该固定高
                
                Image(uiImage: UIImage(named: "schedule_taped")!.withRenderingMode(.alwaysTemplate))
                    .offset(x: coloState.timeType == 0 ? -centerOffset : centerOffset, y: 0).animation(.easeIn)
                    .foregroundColor(coloState.timeType == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime)
            })
            
            Spacer().frame(height: SizeStylesPro().spacingM.byScaleWidth())
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .center, spacing: SizeStylesPro().spacingS.byScaleWidth(), content: {
                    ForEach(Array(curArr.enumerated()), id: \.element) { index, e in
                        SchedulListCell(dic: e, dicIdx: index)
                    }
                    
                    HStack(alignment: .center, spacing: 4, content: {
                        Spacer()
                        Image(systemName: "plus")
                        Text("Add Schedule")
                        Spacer()
                    })
                    .font(TextStyles.subHeadlineSemibold)
                    .frame(height: 42)
                    .onTapGesture {
                        isPopoverVisible.toggle()
                    }
                    .popover(isPresented: $isPopoverVisible) {
                        ScheduleSet(isPresented: $isPopoverVisible, arrIdx: curArr.count)
                    }
                })
                .padding(.top, SizeStylesPro().spacingXs.byScaleWidth())
                .foregroundColor(coloState.timeType == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime)
            })
            
        }
        .padding(.leading, SizeStylesPro().spacingM.byScaleWidth())
        .padding(.trailing, SizeStylesPro().spacingM.byScaleWidth())
        .padding(.top, SizeStylesPro().spacingM.byScaleWidth())
        .background(Color(UIColor.systemGroupedBackground))
        .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
        .ignoresSafeArea()
        .environmentObject(coloState)
        .onAppear(perform: {
            __dateSir.dateFormat = "HH:mm"
            //            __dateSir.locale = Locale(identifier: "da")
            
            //            __UserDefault.setValue(curArr, forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr)
            dataLoadDo()
            listBlock = {//编辑保存后刷新
                dataLoadDo()
            }
        })
    }
    
    func dataLoadDo() {
        curArr = []
        if let t = __UserDefault.value(forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr) as? [Data] {
            print("loo 设置 \(t.count)")
            
            t.forEach { dic in
                do{
                    let haq = try JSONDecoder().decode(ScheduleBean.self, from: dic)
                    curArr += [haq]
                    print("Key 1: \(haq.days)")
                 }catch{
                     
                 }

            }
        }
    }
    
}


struct SchedulListCell: View {
    @EnvironmentObject var coloState : MainColorModel
    
    @State private var isPopoverVisible = false
    @State var dic : ScheduleBean
    @State var dicIdx : Int
    @State var isGuide : Bool = false
    let weekStrs = [0: "Mon", 1: "Tue", 2: "Wed", 3: "Thu", 4: "Fri", 5: "Sta", 6: "Sun"]
    
    func weekStrGet(arr: [Int]?) -> String {
        let arr = arr ?? []
        if arr == [5, 6] || arr == [6, 5] {
            return "Weekend"
        }
        if arr.count == 5 && !arr.contains(5) && !arr.contains(6) {
            return "Weekdays"
        }
        if arr.count == 7 {
            return "Everyday"
        }
        if arr.count == 1 {
            return weekStrs[arr.first!]!
        }
        if arr.count > 1 {
            var str = ""
            for idx in 0..<arr.count {
                if idx == arr.count-1 {
                    str += "\(weekStrs[arr[idx]]!)"
                }else if idx == arr.count-2 {
                    str += "\(weekStrs[arr[idx]]!) and "
                }else{
                    str += "\(weekStrs[arr[idx]]!), "
                }
            }
            return str
        }
        return "Unkown"
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: SizeStylesPro().spacingXs.byScaleWidth()) {
            Text(weekStrGet(arr: dic.days))
                .font(TextStyles.subHeadlineSemibold)
            HStack {
                Text("\(__dateSir.string(from: dic.start ?? Date())) - \(__dateSir.string(from: dic.end ?? Date())) ")
                    .font(TextStyles.title3Bold)
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Button(action: {
                    isPopoverVisible.toggle()
                }, label: {
                    Text("Edit")
                        .font(TextStyles.subHeadlineSemibold)
                })
                .popover(isPresented: $isPopoverVisible) {
                    ScheduleSet(isPresented: $isPopoverVisible, arrIdx: dicIdx)
                }
            }
        }
        .padding(SizeStylesPro().spacingM.byScaleWidth())
        .background(isGuide ? Color.clear : Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(SizeStylesPro().spacingM.byScaleWidth())
        .overlay(RoundedRectangle(cornerRadius: SizeStylesPro().spacingM.byScaleWidth()).stroke(Color(isGuide ? UIColor.systemFill : .clear), lineWidth: 1))
        .environmentObject(coloState)
    }
}

