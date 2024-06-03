import SwiftUI
import SwiftData

struct CategoryTicketsScreen: View {
    
    @State private var lessonSetupScreen: Category?
    
    @State private var lessonScreen: Lesson?
    
    @State private var lessonSummaryScreen: Lesson?
    
    struct Data: Hashable {
        let category: Category
    }
    
    let category: Category
    
    init(
        data: Data
    ) {
        self.category = data.category
    }
    
    var body: some View {
        List {
            ForEach(sortedTickets) { ticket in
                NavigationLink(value: ticket) {
                    TicketCell(ticket: ticket)
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            startLessonButton
        }
        .navigationTitle(category.name)
        .navigationDestination(for: Ticket.self) { ticket in
            TicketScreen(ticket: ticket)
        }
        .fullScreenCover(item: $lessonSetupScreen) { data in
            NavigationStack {
                LessonSetupScreen(
                    category: data,
                    navigate: navigation
                )
                .closeButton()
            }
        }
        .fullScreenCover(item: $lessonScreen) { lesson in
            LessonScreen(lesson: lesson) { lesson in
                lessonScreen = nil
                lessonSummaryScreen = lesson
            }
        }
        .fullScreenCover(item: $lessonSummaryScreen) { lesson in
            NavigationStack {
                LessonSummaryScreen(
                    lesson: lesson
                )
                .closeButton()
            }
        }
    }
    
    var sortedTickets: [Ticket] {
        category.tickets.sorted(by: { $0.id < $1.id })
    }
    
    var startLessonButton: some View {
        Button("Start a lesson") {
            lessonSetupScreen = category
        }
    }
    
    private func navigation(_ trigger: LessonSetupScreen.NavigationTrigger) {
        switch trigger {
        case .lesson(let lesson):
            lessonSetupScreen = nil
            lessonScreen = lesson
        }
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    let descriptor = FetchDescriptor<Category>(
        sortBy: [SortDescriptor(\.name)]
    )
    
    let categories = try! container.mainContext.fetch(descriptor)
    
    return NavigationStack {
        CategoryTicketsScreen(data: CategoryTicketsScreen.Data(
            category: categories.first!
        ))
    }
    .modelContainer(container)
}
