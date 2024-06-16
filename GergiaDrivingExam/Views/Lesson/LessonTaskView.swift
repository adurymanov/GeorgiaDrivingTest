import SwiftUI
import SwiftData

struct LessonTaskView: View {
    
    @State private var selectedOptionIndex: Int?
    
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
                selectedOptionIndex = answer.givenAnswer
            }
        }
    }
    
    private var options: Array<(offset: Int, element: String)> {
        Array(ticket.options.enumerated())
    }
    
    private var questionView: some View {
        Text(ticket.question)
    }
    
    private var titleView: some View {
        Text("#\(ticket.id)").font(.headline)
    }
    
    private var optionsSelectorView: some View {
        ForEach(options, id: \.element) { (index, option) in
            Button {
                select(index: index)
            } label: {
                OptionSelectableCell(
                    value: option,
                    style: optionCellStyle(index: index),
                    highlighted: index == selectedOptionIndex
                )
                .contentTransition(.symbolEffect(.replace, options: .speed(10)))
            }
            .disabled(selectedOptionIndex != nil)
            .foregroundStyle(.primary)
        }
    }
    
    private func optionCellStyle(index: Int) -> OptionSelectableCell.Style {
        guard let selectedOptionIndex else { return .normal }
        
        return if index == ticket.rightAnswer {
            .right
        } else if index == selectedOptionIndex {
            .wrong
        } else {
            .normal
        }
    }
    
    private func select(index: Int) {
        guard selectedOptionIndex == nil else { return }
        selectedOptionIndex = index
        
        let answer = Answer(
            id: UUID().uuidString,
            date: .now,
            givenAnswer: index
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
