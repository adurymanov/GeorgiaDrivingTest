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
    
    @Query(sort: \Category.name) var categories: [Category]
    
    let navigationPath: NavigationPath
    
    var body: some View {
        if let selectedCategory {
            CategoryScreen(data: CategoryScreen.Data(category: selectedCategory))
        } else {
            CategoriesScreen()
        }
    }
    
    var selectedCategory: Category? {
        categories.first { $0.id == selectedCategoryId }
    }
    
}

#Preview {
    ContentView(navigationPath: NavigationPath())
        .modelContainer(for: Ticket.self, inMemory: true)
}
