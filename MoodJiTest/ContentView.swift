//
//  ContentView.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

enum IntroViewType: Int, CaseIterable {
    case kAgreement
//    case kWatchStatus
//    case kAutoSync
//    case kStatusType
    case kHealthPermission
//    case kScreenPermission
    case kSetSleepSchedule
//    case kAddWatctface
    case kHome
}

private func calcInitIntroView() -> IntroViewType {
//    let agreement = UserDefaults.standard.object(forKey: GlobalSettings.agreementKey) as? Bool ?? false
//    let finishIntro = UserDefaults.standard.object(forKey: GlobalSettings.finishIntroKey) as? Bool ?? false

//    if !agreement {
//        return IntroViewType.kAgreement
//    }
//
//    if !finishIntro {
//        return IntroViewType.kWatchStatus
//    }

    return IntroViewType.kHome
}

struct ContentView: View {
    @State private var introNavigationPath: [IntroViewType] = []

    private var initPage = calcInitIntroView()

    var body: some View {
        Group {
            // home view中包含tab view，嵌入在一个navigation stack中是不被推荐的
            if initPage == .kHome || introNavigationPath.last == IntroViewType.kHome {
                MainView()
            } else {
                NavigationStack(path: $introNavigationPath) {
                    createPageView(initPage)
                        .navigationDestination(for: IntroViewType.self) { t in
                            createPageView(t)
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private func createPageView(_ pageType: IntroViewType) -> some View {
        Group {
            switch pageType {
                case .kAgreement:
                    AggrementView(path: $introNavigationPath)
                        .navigationBarHidden(true)
                case .kHealthPermission:
                    HealthReq(path: $introNavigationPath)
                        .navigationBarHidden(true)
                case .kSetSleepSchedule:
                    TimelineIntroduce(path: $introNavigationPath)
                        .navigationBarHidden(true)
                case .kHome:
                    MainView()
            }
        }
    }
}
