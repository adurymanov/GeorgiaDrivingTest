import SwiftData
import Foundation

@Model
final class Answer {
    
    @Attribute(.unique) var id: String
    
    var date: Date
    
    var givenAnswer: Int
    
    @Relationship(inverse: \Ticket.givenAnswers) var ticket: Ticket?
    
    @Relationship(inverse: \Lesson.answers) var lesson: Lesson? 
    
    init(
        id: String,
        date: Date,
        givenAnswer: Int
    ) {
        self.id = id
        self.date = date
        self.givenAnswer = givenAnswer
    }
    
}
