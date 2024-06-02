import SwiftUI
import SwiftData

struct CategoriesScreen: View {
    
    @Query(sort: \Category.name) var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink(value: category) {
                    CategoryCell(category: category)
                }
            }
        }
        .navigationTitle("Categories")
        .navigationDestination(for: Category.self) { category in
            CategoryScreen(category: category)
        }
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    
    return NavigationStack {
        CategoriesScreen()
    }
    .modelContainer(container)
}
