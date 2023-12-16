//
//  Guides.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/14.
//

import SwiftUI

struct Guides: View {
    @StateObject var coloState = MainColorModel()

    @State private var showNewView = false
    
    @State private var isPopoverVisible = false
    
    @State var curArr = [ScheduleBean]()
    let centerOffset = (winW-(16.byScaleWidth())*2)/4
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if !showNewView {
//                Image("guide\(idx)").resizable().aspectRatio(contentMode: .fill)

                VStack(alignment: .center, spacing: 0) {
                    Spacer().frame(height: 24.byScaleWidth())
                    
                    Image("GoodM")
                        .padding(.top, winH*0.05)
                        .padding(.bottom, 15.byScaleWidth())
                    
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
                            
                            HStack {
                                Spacer()
                                Image(systemName: "building.2.fill")
                                Text("WORK")
                                    .font(TextStyles.subHeadlineSemibold)
                                Spacer()
                            }
                            .foregroundColor(coloState.timeType == 1 ? ColorStylesDark().accentScreenTime : Color(UIColor.tertiaryLabel))
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
                                SchedulListCell(dic: e, dicIdx: index, isGuide: true)
                            }
                            
                            HStack(alignment: .center, spacing: 4, content: {
                                Spacer()
                                Image(systemName: "plus")
                                Text("Add Schedule")
                                Spacer()
                            })
                            .font(TextStyles.subHeadlineSemibold)
                            .frame(height: 66)
                            .overlay(RoundedRectangle(cornerRadius: SizeStylesPro().spacingM.byScaleWidth())
                                        .stroke(curArr.isEmpty ? coloState.timeType == 0 ? ColorStylesDark().accentSleep : ColorStylesDark().accentScreenTime : .clear, lineWidth: 1))

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
                    
                    VStack {
                        Button(action: {
                            nextDo()
                        }, label: {
                            Text("Next").font(TextStyles.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(ColorStylesDark().accentScreenTime).cornerRadius(16)
                        })
                        
                        Button(action: {
                            skipDo()
                        }, label: {
                            Text("Skip now").font(TextStyles.subHeadline).foregroundColor(Color(UIColor.tertiaryLabel))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                        })
                    }
                    .padding(.top, 14.byScaleWidth())
                    .padding(.bottom, 24.byScaleWidth())
                }
                .padding(24.byScaleWidth())
                .background(LinearGradient(gradient: Gradient(colors: [ColorStylesDark().accentSleep,Color(UIColor.lightText)]), startPoint: .init(x: 0.5, y: -1), endPoint: .bottom))
            }
            
            if showNewView {
                ContentView()
                    .environmentObject(coloState)
            }
        }
        .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
        .ignoresSafeArea()
        .environmentObject(coloState)
        .onAppear(perform: {
            __dateSir.dateFormat = "HH:mm"
            __UserDefault.setValue(curArr, forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr)
            __UserDefault.setValue(curArr, forKey: coloState.timeType == 1 ? sleepTimeArr : workTimeArr)
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
    
    func nextDo() {
        if coloState.timeType == 0 {
            if curArr.count < 2 {
                doneDo(num: curArr.count)
            }else{
                skipDo()
            }
        }else if coloState.timeType == 1 {
            if curArr.count < 2 {
                doneDo(num: curArr.count+2)
            }else{
                showNewView.toggle()
            }
        }
    }
    
    func skipDo() {
        if coloState.timeType == 1 {
            showNewView.toggle()
        }else{
            coloState.timeType = 1
            dataLoadDo()
        }
    }
    
    func doneDo(num: Int) {
        __dateSir.dateFormat = "HH:mm"
        var haq = ScheduleBean()
        switch num {
        case 0:
            haq = ScheduleBean(days: [0,1,2,3,4], start: __dateSir.date(from: "23:00")!, end: __dateSir.date(from: "07:00")!)
            break
        case 1:
            haq = ScheduleBean(days: [5,6], start: __dateSir.date(from: "23:30")!, end: __dateSir.date(from: "09:00")!)
            break
        case 2:
            haq = ScheduleBean(days: [0], start: __dateSir.date(from: "09:00")!, end: __dateSir.date(from: "18:00")!)
            break
        default:
            haq = ScheduleBean(days: [1,2,3,4], start: __dateSir.date(from: "09:00")!, end: __dateSir.date(from: "18:00")!)
        }
        curArr += [haq]
        
        var dataArr = [Data]()
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(haq)
            if let t = __UserDefault.value(forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr) as? [Data] {
                print("color 设置 \(t)")
                dataArr = t
            }
            dataArr += [data]
            __UserDefault.setValue(dataArr, forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr)
            __UserDefault.synchronize()
            
        } catch {
            print("转换失败: \(error.localizedDescription)")
        }

    }
}

