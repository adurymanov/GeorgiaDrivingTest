import SwiftUI
import SwiftData

struct TicketsFilterScreen: View {
    
    @Bindable var filter: TicketsFilter
    
    @Query
    var categories: [TicketCategory]
    
    @State
    private var selectedCategory: TicketCategory.ID?
    
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
            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories) { category in
                        Text(category.name.defaultValue).tag(category.id)
                    }
                }
                .pickerStyle(.navigationLink)
            }
        }
        .onChange(of: selectedCategory) { _, newValue in
            filter.categories = newValue.map({ Set([$0]) }) ?? Set()
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
        scores: [],
        categories: []
    )
    
    container.mainContext.insert(filter)
    
    return NavigationStack {
        TicketsFilterScreen(filter: filter)
    }
    .modelContainer(container)
}
