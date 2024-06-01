//
//  ContentView.swift
//  GergiaDrivingExam
//
//  Created by Andrew on 01.06.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        CategoriesScreen()
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Ticket.self, inMemory: true)
}
