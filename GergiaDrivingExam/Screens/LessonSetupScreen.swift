import SwiftUI
import SwiftData

struct LessonSetupScreen: View {
    
    struct Data: Identifiable, Hashable {
        var id: String { category.id }
        let category: Category
        let filter: TicketsFilter
    }
    
    enum NavigationTrigger {
        case lesson(Lesson)
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var ticketsCount: Int = 10
    
    @State private var isLessonStarting: Bool = false
    
    let category: Category
    
    let filter: TicketsFilter
    
    let navigate: (NavigationTrigger) -> Void
    
    init(
        data: Data,
        navigate: @escaping (NavigationTrigger) -> Void
    ) {
        self.category = data.category
        self.filter = data.filter
        self.navigate = navigate
    }
    
    var body: some View {
        List {
            formField(title: "Category") {
                Text(category.name)
            }
            formField(title: "Tickets count") {
                TextField("Tickets count", value: $ticketsCount, format: .number)
            }
            Section {
                NavigationLink(value: filter) {
                    Label("Filters", systemImage: filter.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .overlay(alignment: .bottom) {
            startButton
        }
        .navigationDestination(for: TicketsFilter.self) { filter in
            TicketsFilterScreen(filter: filter)
        }
        .navigationTitle("Test")
    }
    
    private var startButton: some View {
        Button {
            Task {
                await startLessonAction()
            }
        } label: {
            HStack {
                if isLessonStarting {
                    ProgressView()
                } else {
                    Text("Start")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .background(.thinMaterial)
    }
    
    private func formField<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).foregroundStyle(.secondary)
            content()
        }
    }
    
    private func startLessonAction() async {
        let tickets = await category
            .tickets
            .filter(using: filter)
            .shuffled()
            .prefix(ticketsCount)
        
        let lesson = Lesson(
            id: UUID().uuidString,
            date: .now
        )
        
        await MainActor.run {
            modelContext.insert(lesson)
            lesson.tickets = Array(tickets)
            navigate(.lesson(lesson))
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
        LessonSetupScreen(
            data: LessonSetupScreen.Data(
                category: categories.first!,
                filter: TicketsFilter(
                    lastReviewDateRange: nil,
                    scores: []
                )
            ),
            navigate: { print($0) }
        )
    }
    .modelContainer(container)
}
