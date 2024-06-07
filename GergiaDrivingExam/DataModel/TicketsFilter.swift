import Foundation
import SwiftData

@Model
final class TicketsFilter {
    
    @Attribute(.unique) var id: String
    
    var dates: ClosedRange<Date>
    
    var scores: Set<TicketScore>
    
    @Relationship(inverse: \Category.filter) var category: Category?
    
    init(
        id: String,
        dates: ClosedRange<Date>,
        scores: Set<TicketScore>
    ) {
        self.id = id
        self.dates = dates
        self.scores = scores
    }
    
}
