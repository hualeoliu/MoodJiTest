//
//  ContentView.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case heart = "heart.text.square.fill"
    case chart = "chart.bar.fill"
    case paint = "paintpalette.fill"
    case gear = "gearshape.fill"
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

struct Content0View: View {
    @Environment(\.colorScheme) var curMode
    
    @State private var aDate: Date = .now
    
    @State private var activeTab: Tab = .heart
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
    @ViewBuilder
    func CustomTab() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    if #available(iOS 17.0, *) {
                        Image(systemName: tab.rawValue)
                            .font(.title2)
                            .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                    } else {
                        Image(systemName: tab.rawValue)
                            .font(.title2)
                    }

                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 5)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    if #available(iOS 17.0, *) {
                        withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                            activeTab = tab
                            animatedTab.isAnimating = true
                        }) {
                            var trans = Transaction()
                            trans.disablesAnimations = true
                            withTransaction(trans) {
                                animatedTab.isAnimating = nil
                            }
                        }
                    } else {
                        activeTab = tab

                    }

                }
            }
        }
    }
    
    var body: some View {
        
        VStack {
            TabView(selection: $activeTab) {
                ConfettiView()
                    .frame(width: 300, height: 100)
                .setupTab(.heart)
                
                Mp4View(url: URL(string: testurl)!)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .setupTab(.chart)

                TimePicker(resultDate: $aDate)
                .setupTab(.paint)
                
                Setting()
                .setupTab(.gear)
            }
            .overlay(alignment: .bottom) {
                Divider()
            }
            
            CustomTab()
        }
        
        .accentColor(curMode == .dark ? ColorStylesDark().tabitemSelected : ColorStylesLight().tabitemSelected)
        .onAppear(perform: {
            __UserDefault.setValue(1, forKey: firstOpen)
        })
        
    }
}

extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        if #available(iOS 16.0, *) {
            self
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(tab)
                .toolbar(.hidden, for: .tabBar)
        } else {
            self
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(tab)
        }
        
    }
}


var windowWidth: CGFloat {
    UIScreen.main.bounds.width
}
