import SwiftUI

struct TicketScreen: View {
    
    let ticket: Ticket
    
    var body: some View {
        Text("Ticket: \(ticket.id)")
            .navigationTitle("#\(ticket.id)")
    }
    
}
