import SwiftUI
import SwiftData

struct TicketsFilterScreen: View {
    
    @Bindable var filter: TicketsFilter
    
    var body: some View {
        List {
            Section("Score") {
                TicketScoresPricker(
                    selection: $filter.scores,
                    scores: Ticket.scores
                )
            }
            Section("Last reviewed date") {
                TicketLastReviewDatRangeFixedPicker(
                    selection: $filter.lastReviewDateRange
                )
            }
        }
        .navigationTitle("Filters")
    }
    
    private var resetButton: some View {
        Button("Reset") {
            filter.lastReviewDateRange = nil
            filter.scores = []
        }
    }
    
}


#Preview {
    let container = try! DataController.previewContainer
    let filter = TicketsFilter(
        lastReviewDateRange: nil,
        scores: []
    )
    
    container.mainContext.insert(filter)
    
    return NavigationStack {
        TicketsFilterScreen(filter: filter)
    }
    .modelContainer(container)
}
