import SwiftData

@Model
final class TicketCategory: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var name: LocalizedText
    
    @Relationship var tickets: [Ticket] = []
    
    init(id: String, name: LocalizedText) {
        self.id = id
        self.name = name
    }
    
}
