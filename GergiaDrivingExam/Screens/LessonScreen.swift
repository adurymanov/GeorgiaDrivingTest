import SwiftUI
import SwiftData

struct LessonScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var navigationPath = NavigationPath()
    
    @State private var answers = [Ticket: Answer]()
    
    @State private var tickets = [Ticket]()
    
    let lesson: Lesson
    
    let finish: (Lesson) -> Void
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if let ticket = tickets.first {
                    rootTaskScreenView(ticket)
                } else {
                    noTicketsView
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    closeButtonView
                }
            }
        }
        .task {
            tickets = lesson.tickets
        }
    }
    
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
    
    private func rootTaskScreenView(_ ticket: Ticket) -> some View {
        LessonTaskScreen(
            data: LessonTaskScreen.Data(
                ticket: ticket,
                answer: answers[ticket],
                isLast: lesson.tickets.last == ticket
            ),
            navigate: navigation
        )
        .navigationDestination(for: LessonTaskScreen.Data.self) { data in
            LessonTaskScreen(
                data: data,
                navigate: navigation
            )
        }
    }
    
    private func navigation(_ trigger: LessonTaskScreen.NavigationTrigger) {
        switch trigger {
        case let .next(ticket, answer):
            answer.lesson = lesson
            answers[ticket] = answer
            next(ticket: ticket)
        case let .skip(ticket):
            next(ticket: ticket)
        }
    }
    
    private func next(ticket: Ticket) {
        guard let indexOfTicket = tickets.firstIndex(of: ticket) else {
            return
        }
        
        if indexOfTicket < tickets.count - 1 {
            let nextIndex = tickets.index(after: indexOfTicket)
            let nextTicket = tickets[nextIndex]
            let nextAnswer = answers[nextTicket]
            
            navigationPath.append(LessonTaskScreen.Data(
                ticket: nextTicket,
                answer: nextAnswer,
                isLast: lesson.tickets.last == nextTicket
            ))
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
        Ticket.mock(id: "1"),
        Ticket.mock(id: "2"),
        Ticket.mock(id: "3"),
        Ticket.mock(id: "4"),
    ]
    
    container.mainContext.insert(lesson)
    tickets.forEach { ticket in
        container.mainContext.insert(ticket)
    }
    
    lesson.tickets = tickets
    
    return LessonScreen(
        lesson: lesson,
        finish: { print($0) }
    )
    .modelContainer(container)
}
