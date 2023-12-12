//
//  MoodJiTestApp.swift
//  MoodJiTest WatchKit Extension
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

@main
struct MoodJiTestApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
