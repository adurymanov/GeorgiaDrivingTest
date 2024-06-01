import SwiftUI

struct CategoryCell: View {
    
    let category: Category
    
    var body: some View {
        Text(category.name)
    }
    
}
