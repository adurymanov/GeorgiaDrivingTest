import SwiftUI

struct CategoryScreen: View {
    
    let category: Category
    
    var body: some View {
        List {
            ForEach(category.tickets) { ticket in
                NavigationLink(value: ticket) {
                    TicketCell(ticket: ticket)
                }
            }
        }
        .toolbar {
            startLessonButton
        }
        .navigationTitle(category.name)
        .navigationDestination(for: Ticket.self) { ticket in
            TicketScreen(ticket: ticket)
        }
    }
    
    var startLessonButton: some View {
        Button("Start lesson") {
            
        }
    }
    
}
