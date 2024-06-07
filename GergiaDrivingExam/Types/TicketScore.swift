enum TicketScore: Codable, Hashable, Identifiable {
    var id: String {
        switch self {
        case .empty:
            "empty"
        case let .value(score):
            "score_\(score)"
        }
    }
    case empty
    case value(_ score: Int)
}
