//
//  MoodJiTestApp.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

@main
struct MoodJiTestApp: App {
    
    @StateObject var coloState = MainColorModel()
    
    var body: some Scene {
        WindowGroup {
            
            MainView()
                .environmentObject(coloState)
            
        }
    }
}
