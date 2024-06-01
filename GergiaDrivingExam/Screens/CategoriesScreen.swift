import SwiftUI
import SwiftData

struct CategoriesScreen: View {
    
    @Query var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink(value: category) {
                    CategoryCell(category: category)
                }
            }
        }
        .navigationDestination(for: Category.self) { category in
            CategoryScreen(category: category)
        }
    }
    
}
