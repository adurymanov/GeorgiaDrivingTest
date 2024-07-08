import SwiftData

@Model
final class TicketExplanation: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var explanation: LocalizedText
    
    var simplified: LocalizedText?
    
    init(id: String, explanation: LocalizedText, simplified: LocalizedText? = nil) {
        self.id = id
        self.explanation = explanation
        self.simplified = simplified
    }
    
}
