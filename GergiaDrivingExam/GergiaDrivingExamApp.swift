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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Ticket.self)
    }
}
