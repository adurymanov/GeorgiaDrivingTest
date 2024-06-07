import SwiftUI
import Charts
import SwiftData

struct CategoryScreen: View {
    
    struct TicketsChartItem: Identifiable {
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
    
    let category: Category
    
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
                    "All tickets",
                    value: CategoryTicketsScreen.Data(category: category)
                )
            }
        }
        .task {
            prepareTickets()
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
        .chartXScale(domain: Ticket.scores.map(scoreTitle(_:)))
        .chartYScale(domain: 0...1000)
        .padding(.vertical)
    }
    
    private func prepareTickets() {
        let tickets = category.tickets
        
        let ticketsByScore = Dictionary(grouping: tickets, by: \.score)
        let ticketsChartData = ticketsByScore.map {
            TicketsChartItem(
                x: scoreTitle($0.key),
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
    
    private func scoreTitle(_ score: TicketScore) -> String {
        switch score {
        case let .value(score):
            String(score)
        case .empty:
            "-"
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
