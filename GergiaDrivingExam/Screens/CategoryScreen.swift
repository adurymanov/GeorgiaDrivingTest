import SwiftUI
import Charts
import SwiftData

struct CategoryScreen: View {
    
    struct TicketsChartItem: Identifiable {
        var id: String { x }
        let x: String
        let y: Int
        let score: Int?
    }
    
    struct Data: Hashable {
        let category: Category
    }
    
    @State private var ticketsByScore: [Int?: [Ticket]] = [:]
    
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
        .chartXScale(domain: ["-"] + (-3...5).map(String.init))
        .chartYScale(domain: 0...1000)
        .padding(.vertical)
    }
    
    private func prepareTickets() {
        let tickets = category.tickets
        
        let ticketsByScore = Dictionary(grouping: tickets) { element in
            switch element.score {
            case let (.some(score)) where score <= -3:
                -3
            case let (.some(score)) where score >= 5:
                5
            default:
                element.score
            }
        }
        let ticketsChartData = ticketsByScore.map { 
            TicketsChartItem(
                x: $0.key.map(String.init) ?? "-",
                y: $0.value.count,
                score: $0.key
            )
        }
        
        self.ticketsByScore = ticketsByScore
        self.ticketsChartData = ticketsChartData
    }
    
    private func barMarkColor(_ score: Int?) -> Color {
        if let score {
            score < 0 ? .red : .green
        } else {
            .secondary
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
