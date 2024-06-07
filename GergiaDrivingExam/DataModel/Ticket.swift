import SwiftData
import Foundation

@Model
final class Ticket: Identifiable {
    
    static let scoreRange = -3...3
    
    static var scores: [TicketScore] {
        [.empty] + Self.scoreRange.map { TicketScore.value($0) }
    }
    
    @Attribute(.unique) var id: String
    
    var question: String
    
    var options: [String]
    
    var rightAnswer: Int
    
    var imageName: String?
    
    var explanation: String?
    
    var score: TicketScore
    
    @Relationship var categories = [Category]()
    
    @Relationship var givenAnswers = [Answer]()
    
    @Relationship var lessons = [Lesson]()
    
    var lastReviewDate: Date? {
        givenAnswers.map(\.date).max()
    }
    
    var searchText: String {
        (id + question + options.joined() + (explanation ?? "")).lowercased()
    }
    
    init(
        id: String,
        question: String,
        options: [String],
        rightAnswer: Int,
        imageName: String?,
        explanation: String?,
        score: TicketScore
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.imageName = imageName
        self.explanation = explanation
        self.score = score
    }
    
    func increaseScore() {
        switch score {
        case .empty:
            self.score = .value(1)
        case let .value(score) where score >= Self.scoreRange.upperBound:
            self.score = .value(Self.scoreRange.upperBound)
        case let .value(score):
            self.score = .value(score + 1)
        }
    }
    
    func decreaseScore() {
        switch score {
        case .empty:
            self.score = .value(-1)
        case let .value(score) where score <= Self.scoreRange.lowerBound:
            self.score = .value(Self.scoreRange.lowerBound)
        case let .value(score):
            self.score = .value(score - 1)
        }
    }
    
}

extension Array where Element == Ticket {
    
    func filter(using filter: TicketsFilter) async -> Self {
        var filtered = [Ticket]()
        
        for ticket in self {
            guard !Task.isCancelled else {
                return []
            }
            var isSelected = true
            
            if let range = filter.lastReviewDateRange {
                isSelected = ticket.lastReviewDate.map { range.contains($0 )} ?? false
            } 
            if !filter.scores.isEmpty {
                isSelected = filter.scores.contains(ticket.score)
            }
            
            if isSelected {
                filtered.append(ticket)
            }
        }
        
        return filtered
    }
    
    func filter(searchText: String?) async -> Self {
        guard let searchText, !searchText.isEmpty else {
            return self
        }
        let lowercasedSearchText = searchText.lowercased()
        var result = [Ticket]()
        
        for ticket in self {
            guard !Task.isCancelled else {
                return []
            }
            if ticket.searchText.contains(lowercasedSearchText) {
                result.append(ticket)
            }
        }
        
        return result
    }
    
}

extension Ticket {
    
    static func mock(
        id: String = "1",
        question: String = "Имеют ли право участники дорожно-транспортного происшествия получить первую медицинскую помощь, помощь спасателя или другого вида от уполномоченного государственного лица и от местных органов самоуправления, также от других уполномоченных лиц?",
        options: [String] = [
            "Имеют",
            "Не имеют",
            "Имеют не"
        ],
        rightAnswer: Int = 1,
        imageName: String? = "154",
        explanation: String? = "Согласно подпункта 1 пункта «Б.Д» статьи 20 Закона Грузии «О дорожном движении» участники дорожного движения имеют право на получение первой помощи, спасательной и иной помощи от государственных органов и органов местного самоуправления, уполномоченных закона, а также от иных уполномоченных лиц.Во время дорожно-транспортного происшествия.",
        score: TicketScore = .value(100)
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
