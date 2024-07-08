import SwiftUI
import SwiftData

struct LessonTaskView: View {
    
    @State private var selectedOptionId: Option.ID?
    
    let ticket: Ticket
    
    let answer: Answer?
    
    let onSelect: (Answer) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = ticket.imageUrl {
                    TicketImageView(url: url)
                }
                VStack(alignment: .leading, spacing: 16) {
                    questionView
                    optionsSelectorView
                }
                .padding()
            }
        }
        .task {
            if let answer {
                selectedOptionId = answer.givenAnswerId
            }
        }
        .sensoryFeedback(.impact, trigger: selectedOptionId)
    }
    
    private var options: [Option] {
        ticket.options
    }
    
    private var questionView: some View {
        Text(ticket.question.defaultValue)
    }
    
    private var titleView: some View {
        Text("#\(ticket.id)").font(.headline)
    }
    
    private var optionsSelectorView: some View {
        ForEach(options) { option in
            Button {
                select(optionId: option.id)
            } label: {
                OptionSelectableCell(
                    value: option.text.defaultValue,
                    style: optionCellStyle(optionId: option.id),
                    highlighted: option.id == selectedOptionId
                )
                .contentTransition(.symbolEffect(.replace, options: .speed(10)))
            }
            .disabled(selectedOptionId != nil)
            .foregroundStyle(.primary)
        }
    }
    
    private func optionCellStyle(optionId: Option.ID) -> OptionSelectableCell.Style {
        guard let selectedOptionId else { return .normal }
        
        return if optionId == ticket.rightOptionId {
            .right
        } else if optionId == selectedOptionId {
            .wrong
        } else {
            .normal
        }
    }
    
    private func select(optionId: Option.ID) {
        guard selectedOptionId == nil else { return }
        selectedOptionId = optionId
        
        let answer = Answer(
            id: UUID().uuidString,
            date: .now,
            givenAnswerId: optionId
        )
        
        onSelect(answer)
    }
    
}

#Preview {
    let container = try! DataController.previewContainer

    let ticket = Ticket.mock()
    
    return NavigationStack {
        LessonTaskView(
            ticket: ticket,
            answer: nil,
            onSelect: { print($0) }
        )
    }
    .modelContainer(container)
}
