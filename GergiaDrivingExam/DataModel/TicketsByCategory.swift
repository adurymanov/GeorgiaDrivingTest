import SwiftData

@Model
final class TicketsByCategory: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var indexInCategory: Int
    
    @Relationship var category: Category?
    
    @Relationship var ticket: Ticket?
    
    init(
        id: String,
        indexInCategory: Int
    ) {
        self.id = id
        self.indexInCategory = indexInCategory
    }
    
}
