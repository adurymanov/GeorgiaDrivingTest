import SwiftData
import Foundation

@Model
final class Ticket: Identifiable {
    
    static let scoreRange = -3...3
    
    static var scores: [TicketScore] {
        [.empty] + Self.scoreRange.map { TicketScore.value($0) }
    }
    
    @Attribute(.unique) var id: String
    
    var question: LocalizedText
    
    var rightOptionId: Option.ID
    
    var imageName: String?
    
    var score: TicketScore
    
    var searchText: String
    
    @Relationship(deleteRule: .cascade) var options = [Option]()
    
    @Relationship(deleteRule: .cascade) var explanation: TicketExplanation?
    
    @Relationship var categories = [Category]()
    
    @Relationship var givenAnswers = [Answer]()
    
    @Relationship var lessons = [Lesson]()
    
    @Relationship(inverse: \TicketCategory.tickets) var group: TicketCategory?
    
    var lastReviewDate: Date? {
        givenAnswers.map(\.date).max()
    }
    
    func isBelongCategory(_ category: Category) -> Bool {
        categories.contains(where: { $0.id == category.id })
    }
    
    init(
        id: String,
        question: LocalizedText,
        rightOptionId: Option.ID,
        imageName: String? = nil,
        score: TicketScore = .empty,
        options: [Option] = [Option](),
        explanation: TicketExplanation? = nil,
        categories: [Category] = [Category](),
        givenAnswers: [Answer] = [Answer](), 
        lessons: [Lesson] = [Lesson]()
    ) {
        self.id = id
        self.question = question
        self.rightOptionId = rightOptionId
        self.imageName = imageName
        self.score = score
        self.options = options
        self.explanation = explanation
        self.categories = categories
        self.givenAnswers = givenAnswers
        self.lessons = lessons
        self.searchText = question.defaultValue
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

extension TicketScore {
    
    var label: String {
        switch self {
        case .empty: "-"
        case .value(-3): "G"
        case .value(-2): "F"
        case .value(-1): "E"
        case .value(0): "D"
        case .value(1): "C"
        case .value(2): "B"
        case .value(3): "A"
        default: "-"
        }
    }
    
}

extension Array where Element == Ticket {
    
    func filter(using filter: TicketsFilter) -> Self {
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
    
    func filter(searchText: String?) -> Self {
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
        question: LocalizedText = .init(value: [.en: "Question"]),
        rightOptionId: Option.ID = "1",
        imageName: String? = nil,
        score: TicketScore = .value(1)
    ) -> Ticket {
        Ticket(
            id: id,
            question: question,
            rightOptionId: rightOptionId,
            imageName: imageName,
            score: score
        )
    }
    
}
