import SwiftUI
import SwiftData

struct LessonSummaryScreen: View {
    
    let lesson: Lesson
    
    var body: some View {
        List {
            ForEach(lesson.answers) { answer in
                NavigationLink(value: answer.ticket) {
                    AnswerCell(answer: answer)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Ticket.self) { ticket in
            TicketScreen(ticket: ticket)
        }
        .navigationTitle("Summary")
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    
    let lesson = Lesson(id: "1", date: .now)
    let ticket = Ticket.mock()
    let answer = Answer(id: "1", date: .now, givenAnswer: 1)
    
    container.mainContext.insert(lesson)
    container.mainContext.insert(ticket)
    container.mainContext.insert(answer)
    
    lesson.tickets = [ticket]
    lesson.answers = [answer]
    answer.ticket = ticket
    
    return NavigationStack {
        LessonSummaryScreen(lesson: lesson)
    }
    .modelContainer(container)
}
