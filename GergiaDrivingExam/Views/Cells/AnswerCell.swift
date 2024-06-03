import SwiftUI

struct AnswerCell: View {
    
    let answer: Answer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("#\(ticket.id)")
                .font(.headline)
                .foregroundStyle(isAnswerCorrect ? .green : .red)
            if let imageUrl = ticket.imageUrl {
                TicketImageView(url: imageUrl)
            }
            Text(ticket.question)
            ForEach(options, id: \.value) { item in
                optionView(
                    item.value,
                    background: optionBackground(index: item.index)
                )
            }
        }
    }
    
    private var ticket: Ticket {
        answer.ticket!
    }
    
    private var options: [(index: Int, value: String)] {
        ticket.options.enumerated().map({ ($0, $1) })
    }
    
    private var isAnswerCorrect: Bool {
        ticket.rightAnswer == answer.givenAnswer
    }
    
    private func optionView(_ value: String, background: Color) -> some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.thinMaterial)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func optionBackground(index: Int) -> Color {
        let isCorrect = index == ticket.rightAnswer
        let isHighlighted = index == ticket.rightAnswer || index == answer.givenAnswer
        
        return switch (isHighlighted, isCorrect) {
        case (true, false): .red.opacity(0.4)
        case (true, true): .green
        case (false, _): .clear
        }
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    
    let ticket = Ticket.mock()
    let answer = Answer(id: "1", date: .now, givenAnswer: 0)
    
    container.mainContext.insert(ticket)
    container.mainContext.insert(answer)
    
    answer.ticket = ticket
    
    return AnswerCell(answer: answer).padding()
}
