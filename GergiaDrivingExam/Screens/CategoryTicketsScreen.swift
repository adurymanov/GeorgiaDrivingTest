import SwiftUI
import SwiftData

struct CategoryTicketsScreen: View {
    
    @State private var lessonSetupScreen: Category?
    
    @State private var lessonScreen: Lesson?
    
    @State private var lessonSummaryScreen: Lesson?
    
    @State private var filter = TicketsFilter(
        lastReviewDateRange: nil,
        scores: []
    )
    
    struct Data: Hashable {
        let category: Category
    }
    
    let category: Category
    
    init(data: Data) {
        self.category = data.category
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ticketsList
            startLessonButton
        }
        .toolbar {
            filtersButton
        }
        .navigationTitle(category.name)
        .navigationDestination(for: Ticket.self) { ticket in
            TicketScreen(ticket: ticket)
        }
        .navigationDestination(for: TicketsFilter.self) { filter in
            TicketsFilterScreen(filter: filter)
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
        category
            .tickets
            .filter { ticket in
                guard let range = filter.lastReviewDateRange else {
                    return true
                }
                return ticket.lastReviewDate.map { range.contains($0 )} ?? false
            }
            .filter { ticket in
                guard !filter.scores.isEmpty else {
                    return true
                }
                return filter.scores.contains(ticket.score)
            }
            .sorted(by: { $0.id < $1.id })
    }
    
    var ticketsList: some View {
        List {
            ForEach(sortedTickets) { ticket in
                NavigationLink(value: ticket) {
                    TicketCell(ticket: ticket)
                }
            }
        }
        .listStyle(.plain)
    }
    
    var startLessonButton: some View {
        Button {
            lessonSetupScreen = category
        } label: {
            Text("Start a lesson")
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    var filtersButton: some View {
        NavigationLink(value: filter) {
            Text("Filter")
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
