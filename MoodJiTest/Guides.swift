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
                        .alignmentGuide(.center) { _ in
                            geometry.size.height * 0.5 // 调整顶部位置  不起作用??
                        }
                        .alignmentGuide(.center) { _ in
                            geometry.size.width * 0.3 // 调整左侧位置
                        }
                        .onTapGesture {
                            showNewView.toggle()
                            idx = 3
                        }
                }
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.9)
                        .foregroundColor(Color.pink.opacity(0.01))
                        .onTapGesture {
                            showNewView.toggle()
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
}

