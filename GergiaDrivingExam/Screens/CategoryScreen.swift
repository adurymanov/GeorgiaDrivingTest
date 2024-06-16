import SwiftUI
import Charts
import SwiftData

struct CategoryScreen: View {
    
    struct TicketsChartItem: Identifiable, Hashable {
        var id: String { x }
        let x: String
        let y: Int
        let score: TicketScore
    }
    
    struct Data: Hashable {
        let category: Category
    }
    
    
    
    @State private var ticketsByScore: [TicketScore: [Ticket]] = [:]
    
    @State private var ticketsChartData: [TicketsChartItem] = []
    
    @State var category: Category
    
    init(
        data: Data
    ) {
        self.category = data.category
    }
    
    var body: some View {
        List {
            Section("Score") {
                ticketsView
            }
            Section {
                NavigationLink(
                    "Tickets",
                    value: CategoryTicketsScreen.Data(category: category)
                )
            }
        }
        .task {
            prepareTickets()
        }
        .toolbar {
            setupMenu
        }
        .navigationTitle(category.name)
        .navigationDestination(for: CategoryTicketsScreen.Data.self) { data in
            CategoryTicketsScreen(data: data)
        }
    }
    
    private var ticketsView: some View {
        Chart {
            ForEach(ticketsChartData) { item in
                BarMark(
                    x: .value("Score", item.x),
                    y: .value("Tickets", item.y)
                )
                .foregroundStyle(barMarkColor(item.score))
            }
        }
        .animation(.default, value: ticketsChartData)
        .chartXScale(domain: Ticket.scores.map(\.label))
        .chartYScale(domain: 0...1000)
        .padding(.vertical)
    }
    
    private var setupMenu: some View {
        CategorySelectionMenu(
            category: $category,
            select: prepareTickets
        )
    }
    
    private func prepareTickets() {
        let tickets = category.tickets
        
        let ticketsByScore = Dictionary(grouping: tickets, by: \.score)
        let ticketsChartData = ticketsByScore.map {
            TicketsChartItem(
                x: $0.key.label,
                y: $0.value.count,
                score: $0.key
            )
        }
        
        self.ticketsByScore = ticketsByScore
        self.ticketsChartData = ticketsChartData
    }
    
    private func barMarkColor(_ score: TicketScore) -> Color {
        switch score {
        case .empty:
            .secondary
        case let .value(score):
            score < 0 ? .red : .green
        }
    }
    
}

struct CategorySelectionMenu: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var categories: [Category] = []
    
    @Binding var category: Category
    
    var select: () -> Void

    var body: some View {
        Menu {
            ForEach(categories) { category in
                Button(category.name) {
                    self.category = category
                    select()
                }
            }
        } label: {
            Label("Setup", systemImage: "gearshift.layout.sixspeed")
        }
        .task {
            let fetchDescriptor = FetchDescriptor<Category>(
                sortBy: [SortDescriptor(\.name)]
            )
            let categories = try? context.fetch(fetchDescriptor)
            
            await MainActor.run {
                self.categories = categories ?? []
            }
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
        CategoryScreen(data: CategoryScreen.Data(
            category: categories.first!
        ))
    }
    .modelContainer(container)
}
