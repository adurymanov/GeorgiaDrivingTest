import SwiftUI
import SwiftData

struct CategoriesScreen: View {
    
    @Query(sort: \Category.name) var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink(value: CategoryScreen.Data(category: category)) {
                    CategoryCell(category: category)
                }
            }
        }
        .navigationTitle("Categories")
        .navigationDestination(for: CategoryScreen.Data.self) { data in
            CategoryScreen(data: data)
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
