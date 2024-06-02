import SwiftData

@Model
final class Ticket: Identifiable {
    
    @Attribute(.unique) var id: String
    
    var question: String
    
    var options: [String]
    
    var rightAnswer: Int
    
    var imageName: String?
    
    var explanation: String?
    
    var score: Int?
    
    @Relationship var categories = [Category]()
    
    @Relationship var givenAnswers = [Answer]()
    
    @Relationship var lessons = [Lesson]()
    
    init(
        id: String,
        question: String,
        options: [String],
        rightAnswer: Int,
        imageName: String,
        explanation: String?,
        score: Int?
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.imageName = imageName
        self.explanation = explanation
        self.score = score
    }
    
}
