import SwiftUI
import SwiftData

struct LessonTaskScreen: View {
    
    private struct IndexedOption: Identifiable, Hashable {
        var id: String { value }
        let index: Int
        let value: String
    }
    
    enum NavigationTrigger {
        case next(ticket: Ticket, answer: Answer)
        case skip(ticket: Ticket)
    }
    
    struct Data: Hashable {
        let ticket: Ticket
        let answer: Answer?
        let isLast: Bool
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedOption: IndexedOption?
    
    @State private var helpTicket: Ticket?
    
    let ticket: Ticket
    
    let answer: Answer?
    
    let isLast: Bool
    
    let navigate: (NavigationTrigger) -> Void
    
    init(
        data: Data,
        navigate: @escaping (NavigationTrigger) -> Void
    ) {
        self.ticket = data.ticket
        self.answer = data.answer
        self.isLast = data.isLast
        self.navigate = navigate
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading) {
                    if let url = ticket.imageUrl {
                        TicketImageView(url: url)
                    }
                    questionView
                    optionsSelectorView
                }
            }
            if selectedOption != nil {
                nextButtonView
            } else {
                skipButtonView
            }
        }
        .task {
            if let answer {
                selectedOption = options.first(where: { $0.index == answer.givenAnswer })
            }
        }
        .toolbar {
            ToolbarItem {
                helpButtonView
            }
        }
        .navigationTitle("#\(ticket.id)")
        .sheet(item: $helpTicket) { ticket in
            NavigationStack {
                LessonTaskHelpScreen(ticket: ticket)
            }
        }
    }
    
    private var options: [IndexedOption] {
        ticket.options.enumerated().map {
            IndexedOption(index: $0.0, value: $0.1)
        }
    }
    
    private var skipButtonTitle: String {
        isLast ? "Finish" : "Skip question"
    }
    
    private var nextButtonTitle: String {
        isLast ? "Finish" : "Next question"
    }
    
    private var questionView: some View {
        Text(ticket.question)
            .padding()
    }
    
    private var optionsSelectorView: some View {
        ForEach(options) { option in
            Button {
                select(option: option)
            } label: {
                OptionSelectableCell(
                    value: option.value,
                    style: optionCellStyle(option: option),
                    highlighted: option == selectedOption
                )
            }
            .disabled(selectedOption != nil)
            .foregroundStyle(.primary)
        }
        .padding(.horizontal)
    }
    
    private var nextButtonView: some View {
        Button {
            nextTicket()
        } label: {
            Text(nextButtonTitle)
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    private var skipButtonView: some View {
        Button {
            skipTicket()
        } label: {
            Text(skipButtonTitle)
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.bordered)
        .padding()
        .foregroundStyle(.primary)
    }
    
    private var helpButtonView: some View {
        Button {
            helpTicket = ticket
        } label: {
            Label("Help", systemImage: "questionmark.circle")
        }
        .disabled(ticket.explanation == nil)
    }
    
    private func optionCellStyle(option: IndexedOption) -> OptionSelectableCell.Style {
        guard let selectedOption else { return .normal }
        
        return if option.index == ticket.rightAnswer {
            .right
        } else if option.index == selectedOption.index {
            .wrong
        } else {
            .normal
        }
    }
    
    private func select(option: IndexedOption) {
        guard selectedOption == nil else { return }
        selectedOption = option
    }
    
    private func skipTicket() {
        navigate(.skip(ticket: ticket))
    }
    
    private func nextTicket() {
        guard let selectedOption else { return }
        
        let answer = Answer(
            id: UUID().uuidString,
            date: .now,
            givenAnswer: selectedOption.index
        )
        modelContext.insert(answer)
        answer.ticket = ticket
        
        if answer.givenAnswer == ticket.rightAnswer {
            ticket.increaseScore()
        } else {
            ticket.decreaseScore()
        }
        
        navigate(.next(ticket: ticket, answer: answer))
    }
    
}

#Preview {
    let container = try! DataController.previewContainer

    let ticket = Ticket.mock()
    
    return NavigationStack {
        LessonTaskScreen(
            data: LessonTaskScreen.Data(
                ticket: ticket,
                answer: nil,
                isLast: true
            ),
            navigate: { print($0) }
        )
    }
    .modelContainer(container)
}
