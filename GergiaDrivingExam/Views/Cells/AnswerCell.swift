import SwiftUI

struct AnswerCell: View {
    
    let answer: Answer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("#\(ticket.id)")
                .font(.title)
                .foregroundStyle(isAnswerCorrect ? .green : .red)
            if let imageUrl = ticket.imageUrl {
                imageView(imageUrl)
            }
            Text(ticket.question.defaultValue)
            Spacer().frame(height: .zero)
            ForEach(options) { item in
                optionView(
                    item.text.defaultValue,
                    background: optionBackground(optionId: item.id)
                )
            }
        }
    }
    
    private var ticket: Ticket {
        answer.ticket!
    }
    
    private var options: [Option] {
        ticket.options
    }
    
    private var isAnswerCorrect: Bool {
        ticket.rightOptionId == answer.givenAnswerId
    }
    
    private func optionView(_ value: String, background: Color) -> some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.thinMaterial)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func imageView(_ url: URL?) -> some View {
        AsyncImage(url: url) { content in
            content
                .image?
                .resizable()
                .scaledToFill()
                .frame(alignment: .center)
        }
        .frame(width: 256, height: 128)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func optionBackground(optionId: Option.ID) -> Color {
        let isCorrect = optionId == ticket.rightOptionId
        let isHighlighted = optionId == ticket.rightOptionId || optionId == answer.givenAnswerId
        
        return switch (isHighlighted, isCorrect) {
        case (true, false): .red.opacity(0.4)
        case (true, true): .green
        case (false, _): .clear
        }
    }
    
}

//#Preview {
//    let container = try! DataController.previewContainer
//    
//    let ticket = Ticket.mock()
//    let answer = Answer(id: "1", date: .now, givenAnswerId: "0")
//    
//    container.mainContext.insert(ticket)
//    container.mainContext.insert(answer)
//    
//    answer.ticket = ticket
//    
//    AnswerCell(answer: answer).padding()
//}
