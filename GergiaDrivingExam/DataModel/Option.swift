import SwiftData

@Model
final class Option: Identifiable {
    
    var id: String
    
    var index: Int
    
    var text: LocalizedText
    
    @Relationship(inverse: \Ticket.options) var ticket: Ticket?
    
    init(id: String, index: Int, text: LocalizedText) {
        self.id = id
        self.index = index
        self.text = text
    }
    
}
