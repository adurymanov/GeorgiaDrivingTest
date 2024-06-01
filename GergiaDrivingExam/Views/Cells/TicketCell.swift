import SwiftUI

struct TicketCell: View {
    
    let ticket: Ticket
    
    var body: some View {
        Text("Ticket: \(ticket.id)")
    }
}
