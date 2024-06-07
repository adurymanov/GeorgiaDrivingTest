//
//  GergiaDrivingExamApp.swift
//  GergiaDrivingExam
//
//  Created by Andrew on 01.06.2024.
//

import SwiftUI
import SwiftData

@main
struct GeorgiaDrivingExamApp: App {
    
    @State var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                ContentView(navigationPath: navigationPath)
            }
        }
        .modelContainer(try! DataController.appContainer)
    }
}
