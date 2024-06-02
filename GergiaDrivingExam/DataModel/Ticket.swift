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
        imageName: String?,
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

extension Ticket {
    
    static func mock(
        id: String = "1",
        question: String = "Имеют ли право участники дорожно-транспортного происшествия получить первую медицинскую помощь, помощь спасателя или другого вида от уполномоченного государственного лица и от местных органов самоуправления, также от других уполномоченных лиц?",
        options: [String] = [
            "Имеют",
            "Не имеют"
        ],
        rightAnswer: Int = 1,
        imageName: String? = "154",
        explanation: String? = "Согласно подпункта 1 пункта «Б.Д» статьи 20 Закона Грузии «О дорожном движении» участники дорожного движения имеют право на получение первой помощи, спасательной и иной помощи от государственных органов и органов местного самоуправления, уполномоченных закона, а также от иных уполномоченных лиц.Во время дорожно-транспортного происшествия.",
        score: Int? = 100
    ) -> Self {
        self.init(
            id: id,
            question: question,
            options: options,
            rightAnswer: rightAnswer,
            imageName: imageName,
            explanation: explanation,
            score: score
        )
    }
    
}
