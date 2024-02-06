//
//  MainView.swift
//  MoodJiTest
//
//  Created by ZZ on 2024/2/5.
//

import SwiftUI
import SwiftUIIntrospect

enum Tab: String, CaseIterable {
    case chart = "chart.bar.fill"
    case heart = "heart.text.square.fill"
    case paint = "paintpalette.fill"
    case gear = "gearshape.fill"
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

struct MainView: View {    
    @State private var aDate: Date = .now
    
    @State private var activeTab: Tab = .chart
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }

    var body: some View {
        VStack {
            TabView(selection: $activeTab) {
                ReportTrendView().tag(Tab.chart)

                ConfettiView()
                    .tag(Tab.heart)
                    .frame(width: 300, height: 100)
                    .shining("fsx")

                TimelinesView().tag(Tab.paint)
                
                Setting().tag(Tab.gear)
            }
            .introspect(.tabView, on: .iOS(.v16, .v17), customize: { v in
                v.tabBar.isHidden = true
            })
            .overlay(alignment: .bottom) {
                Divider()
            }
            
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
        .accentColor(tabitemSelected)
        .onAppear(perform: {
            __UserDefault.setValue(1, forKey: firstOpen)
        })
        
    }
}


var windowWidth: CGFloat {
    UIScreen.main.bounds.width
}
