import SwiftData

@Model
final class Category: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var name: String
    
    @Relationship(inverse: \Ticket.categories) var tickets: [Ticket] = []
    
    init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
}
