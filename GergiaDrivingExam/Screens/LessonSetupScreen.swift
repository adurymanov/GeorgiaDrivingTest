import SwiftUI
import SwiftData

struct LessonSetupScreen: View {
    
    enum NavigationTrigger {
        case lesson(Lesson)
    }
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ticketsCount: Int = 10
    
    let category: Category
    
    let navigate: (NavigationTrigger) -> Void
    
    var body: some View {
        List {
            formField(title: "Category") {
                Text(category.name)
            }
            formField(title: "Tickets count") {
                TextField("Tickets count", value: $ticketsCount, format: .number)
            }
        }
        .overlay(alignment: .bottom) {
            startButton
        }
        .navigationTitle("Lesson")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                closeButton
            }
        }
    }
    
    private var closeButton: some View {
        Button("Close") {
            dismiss()
        }
    }
    
    private var startButton: some View {
        Button {
            startLessonAction()
        } label: {
            Text("Start")
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
    
    private func startLessonAction() {
        let tickets = category.tickets.shuffled().prefix(ticketsCount)
        
        let lesson = Lesson(
            id: UUID().uuidString,
            date: .now
        )
        
        modelContext.insert(lesson)
        
        lesson.tickets = Array(tickets)
        
        navigate(.lesson(lesson))
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
            category: categories.first!,
            navigate: { print($0) }
        )
    }
    .modelContainer(container)
}
