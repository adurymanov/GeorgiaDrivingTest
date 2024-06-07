import SwiftUI

struct TicketImageView: View {
    
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { content in
            content.image?.resizable().scaledToFit()
        }
        .background(.thinMaterial)
    }
    
}
