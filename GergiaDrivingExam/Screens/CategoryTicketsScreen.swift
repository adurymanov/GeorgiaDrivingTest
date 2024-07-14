import SwiftUI
import SwiftData

private final class TaskWrapper {
    var task: Task<Void, Never>?
}

struct CategoryTicketsScreen: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var lessonSetupScreen: LessonSetupScreen.Data?
    
    @State private var lessonScreen: Lesson?
    
    @State private var lessonSummaryScreen: Lesson?
    
    @State private var filter = TicketsFilter(
        lastReviewDateRange: nil,
        scores: [],
        categories: []
    )
    
    @State private var searchText: String = ""
    
    @State private var tickets: [Ticket] = []
    
    @State private var isLoaded: Bool = false
    
    @State private var isFilterChanged = false
    
    @State private var page = 0

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
        .onChange(of: searchText, { oldValue, newValue in
            searchTask.task?.cancel()
            searchTask.task = Task {
                try? await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled else { return }
                await fetch()
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
            NavigationStack {
                LessonScreen(lesson: lesson) { lesson in
                    lessonScreen = nil
                    lessonSummaryScreen = lesson
                }
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
        .task {
            guard !isLoaded else { return }
            await fetch()
            isLoaded = true
        }
        .onAppear {
            guard isLoaded else { return }
            Task {
                await fetch()
            }
        }
    }
    
    func fetch() async {
        page = .zero
        Task.detached { [page] in
            await fetchTickets(page: page, reset: true)
        }
    }
    
    func fetchNext() async {
        page += 1
        Task.detached { [page] in
            await fetchTickets(page: page, reset: false)
        }
    }
    
    func fetchTickets(page: Int, reset: Bool) async {
        let groupId = filter.categories.first
        let categoryId = category.id
        let searchText = self.searchText
        
        let predicate = #Predicate<Ticket> { ticket in
            ticket.categories.contains(where: { $0.id == categoryId })
            && (searchText.isEmpty || ticket.searchText.contains(searchText))
            && (groupId == nil) || ticket.group?.id == groupId
        }
        var fetchDescriptor = FetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\.id)]
        )
        
        fetchDescriptor.fetchLimit = 100
        fetchDescriptor.fetchOffset = page * 100
        
        let tickets: [Ticket]
        
        do {
            tickets = try modelContext.fetch(fetchDescriptor)
        } catch {
            print(error)
            return
        }
        
        await MainActor.run {
            if reset {
                self.tickets = tickets
            } else {
                self.tickets += tickets
            }
        }
    }
    
    var sortedTickets: [Ticket] {
        get {
            category
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
                Text("Loading..").onAppear {
                    Task {
                        await fetchNext()
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
