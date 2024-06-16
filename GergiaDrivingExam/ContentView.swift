//
//  ContentView.swift
//  GergiaDrivingExam
//
//  Created by Andrew on 01.06.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @AppStorage("selected_category_id") var selectedCategoryId: String?
    
    @Environment(\.modelContext) var context
    
    @State var categories: [Category] = []
    
    var body: some View {
        ZStack {
            if let selectedCategory {
                CategoryScreen(data: CategoryScreen.Data(category: selectedCategory))
            } else if categories.isEmpty {
                EmptyView()
            } else {
                CategoriesScreen()
            }
        }
        .task {
            let fetchDescriptor = FetchDescriptor<Category>(
                sortBy: [SortDescriptor(\.name)]
            )
            let categories = try? context.fetch(fetchDescriptor)
            
            await MainActor.run {
                self.categories = categories ?? []
            }
        }
    }
    
    var selectedCategory: Category? {
        categories.first { $0.id == selectedCategoryId }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Ticket.self, inMemory: true)
}
