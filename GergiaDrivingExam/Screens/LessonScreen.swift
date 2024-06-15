import SwiftUI
import SwiftData

struct LessonScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var answers = [Ticket: Answer]()
    
    @State private var tickets = [Ticket]()
    
    @State private var selection: Int = .zero
    
    @State private var help: Ticket?
    
    @State private var selectedOptionIndex: Int?
    
    let lesson: Lesson
    
    let finish: (Lesson) -> Void
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(Array(tickets.enumerated()), id: \.element.id) { (index, ticket) in
                    LessonTaskView(
                        ticket: ticket,
                        answer: answers[ticket],
                        onSelect: { answer in
                            saveAnswer(ticket: ticket, answer: answer)
                        }
                    )
                    .navigationTitle("#\(ticket.id)")
                    .tag(index)
                }
            }
            HStack {
                if let selectedTicket {
                    if answers[selectedTicket] != nil {
                        nextButtonView
                    } else {
                        skipButtonView
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.default, value: selection)
        .overlay {
            if tickets.isEmpty {
                noTicketsView
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                closeButtonView
            }
            ToolbarItem(placement: .status) {
                Text("\(selection + 1)/\(tickets.count)").monospaced()
            }
            if let selectedTicket {
                ToolbarItem {
                    helpButton(ticket: selectedTicket)
                }
            }
        }
        .task {
            tickets = lesson.tickets
        }
        .sheet(item: $help) { ticket in
            NavigationStack {
                LessonTaskHelpScreen(ticket: ticket)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var noTicketsView: some View {
        VStack {
            Text("No questions selected")
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var closeButtonView: some View {
        Button("Close") {
            dismiss()
        }
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
        .padding(.horizontal)
    }
    
    private var skipButtonView: some View {
        Button {
            nextTicket()
        } label: {
            Text(skipButtonTitle)
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal)
        .foregroundStyle(.primary)
    }
    
    private func helpButton(ticket: Ticket) -> some View {
        Button {
            help = ticket
        } label: {
            Label("Help", systemImage: "questionmark.circle")
        }
        .disabled(ticket.explanation == nil)
    }
    
    // MARK: - Values
    
    private var selectedTicket: Ticket? {
        tickets.isEmpty ? nil : tickets[selection]
    }
    
    private var isLast: Bool {
        selection == tickets.count - 1
    }
    
    private var skipButtonTitle: String {
        isLast ? "Finish" : "Skip question"
    }
    
    private var nextButtonTitle: String {
        isLast ? "Finish" : "Next question"
    }
    
    // MARK: - Actions
    
    private func saveAnswer(ticket: Ticket, answer: Answer) {
        modelContext.insert(answer)
        answer.ticket = ticket
        
        if answer.givenAnswer == ticket.rightAnswer {
            ticket.increaseScore()
        } else {
            ticket.decreaseScore()
        }
        
        answer.lesson = lesson
        answers[ticket] = answer
    }
    
    private func nextTicket() {
        if selection < tickets.count - 1 {
            selection += 1
        } else {
            finish(lesson)
        }
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    
    let lesson = Lesson(
        id: UUID().uuidString,
        date: .now
    )
    let tickets = [
        Ticket.mock(id: "1", question: "Q1"),
        Ticket.mock(id: "2", question: "Q2", explanation: nil),
        Ticket.mock(id: "3", question: "Q3"),
        Ticket.mock(id: "4", question: "Q4"),
    ]
    
    container.mainContext.insert(lesson)
    tickets.forEach { ticket in
        container.mainContext.insert(ticket)
    }
    
    lesson.tickets = tickets
    
    return NavigationStack {
        LessonScreen(
            lesson: lesson,
            finish: { print($0) }
        )
    }
    .modelContainer(container)
}
