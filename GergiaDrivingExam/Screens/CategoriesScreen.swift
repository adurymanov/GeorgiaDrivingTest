import SwiftUI
import SwiftData

struct CategoriesScreen: View {
    
    @AppStorage("selected_category_id") var selectedCategoryId: String?
    
    @Query(sort: \Category.name) var categories: [Category]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(categories) { category in
                    categoryCell(category)
                }
            }
        }
        .safeAreaPadding()
        .navigationTitle("Categories")
    }
    
    private func categoryCell(_ category: Category) -> some View {
        Button {
            selectedCategoryId = category.id
        } label: {
            Text(category.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
