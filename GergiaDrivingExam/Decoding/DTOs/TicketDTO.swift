struct TicketDTO: Identifiable, Hashable {
    let id: Int
    let question: String
    let answers: [String]
    let rightAnswerIndex: Int
    let description: String?
    let imageName: String
}

extension TicketDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "examTicketId"
        case question = "question"
        case answers = "answers"
        case rightAnswerIndex = "rightAnswer"
        case description = "description"
        case imageName = "imgsrc"
    }
    
}
