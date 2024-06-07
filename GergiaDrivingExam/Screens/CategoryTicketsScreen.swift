import SwiftUI
import SwiftData

private final class TaskWrapper {
    var task: Task<Void, Never>?
}

struct CategoryTicketsScreen: View {
    
    @State private var lessonSetupScreen: LessonSetupScreen.Data?
    
    @State private var lessonScreen: Lesson?
    
    @State private var lessonSummaryScreen: Lesson?
    
    @State private var filter = TicketsFilter(
        lastReviewDateRange: nil,
        scores: []
    )
    
    @State private var searchText: String = ""
    
    @State private var tickets: [Ticket] = []

    private var searchTask = TaskWrapper()
    
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
        .task {
            let tickets = await sortedTickets
            await MainActor.run {
                self.tickets = tickets
            }
        }
        .onChange(of: searchText, { oldValue, newValue in
            searchTask.task?.cancel()
            searchTask.task = Task {
                try? await Task.sleep(for: .milliseconds(300))
                let tickets = await Task.detached {
                    await sortedTickets
                }.value
                await MainActor.run {
                    guard !Task.isCancelled else {
                        return
                    }
                    self.tickets = tickets
                }
            }
        })
        .searchable(text: $searchText)
        .toolbar {
            filtersButton
        }
        .navigationTitle("Tickets")
        .navigationDestination(for: Ticket.self) { ticket in
            TicketScreen(ticket: ticket)
        }
        .navigationDestination(for: TicketsFilter.self) { filter in
            TicketsFilterScreen(filter: filter)
        }
        .fullScreenCover(item: $lessonSetupScreen) { data in
            NavigationStack {
                LessonSetupScreen(
                    data: data,
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
        get async {
            await category
                .tickets
                .filter(using: filter)
                .filter(searchText: searchText)
                .sorted(by: { $0.id < $1.id })
        }
    }
    
    var ticketsList: some View {
        List {
            Section("\(tickets.count) tickets") {
                ForEach(tickets) { ticket in
                    NavigationLink(value: ticket) {
                        TicketCell(ticket: ticket)
                    }
                }
            }
        }
        .animation(.linear(duration: 0.3), value: tickets)
        .listStyle(.plain)
    }
    
    var startLessonButton: some View {
        Button {
            lessonSetupScreen = LessonSetupScreen.Data(
                category: category,
                filter: filter
            )
        } label: {
            Text("Start test")
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    var filtersButton: some View {
        NavigationLink(value: filter) {
            Label("Filter", systemImage: filter.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
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
