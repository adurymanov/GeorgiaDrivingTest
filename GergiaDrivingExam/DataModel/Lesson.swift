import SwiftData
import Foundation

@Model
final class Lesson: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var date: Date
    
    @Relationship(inverse: \Ticket.lessons) var tickets = [Ticket]()
    
    @Relationship var answers = [Answer]()
    
    init(
        id: String,
        date: Date
    ) {
        self.id = id
        self.date = date
    }
    
}
