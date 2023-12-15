//
//  Guides.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/14.
//

import SwiftUI

struct Guides: View {
    @StateObject var coloState = MainColorModel()

    @State var idx : Int
    @State private var showNewView = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if !showNewView {
                Image("guide\(idx)").resizable().aspectRatio(contentMode: .fill)
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(Color.pink.opacity(0.01))
                        .onTapGesture {
                            showNewView.toggle()
                            idx = 3
                            
                            doneDo()
                        }
                }
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.9)
                        .foregroundColor(Color.pink.opacity(0.01))
                        .onTapGesture {
                            showNewView.toggle()
                            if idx == 3 {
                                doneDo()
                            }
                        }
                }
            }
            
            if showNewView {
                if idx == 3 {
                    ContentView()
                        .environmentObject(coloState)
                }else{
                    Guides(idx: idx+1)
                        .animation(nil)
                }
            }
        }
        
        .edgesIgnoringSafeArea(.all)
    }
    
    func doneDo() {
        print("okk ")
        __dateSir.dateFormat = "HH:mm"
        let haq = ScheduleBean(days: [5,6], start: __dateSir.date(from: "23:00")!, end: __dateSir.date(from: "07:00")!)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(haq)
            
            if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                print("okk", dic)
                __UserDefault.setValue([dic], forKey: coloState.timeType == 0 ? sleepTimeArr : workTimeArr)
                __UserDefault.synchronize()
            }
        } catch {
            print("转换失败: \(error.localizedDescription)")
        }

    }
}

