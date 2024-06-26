import SwiftUI

struct TicketCell: View {
    
    let ticket: Ticket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("#\(ticket.id)").font(.title)
            if let imageUrl = ticket.imageUrl {
                imageView(imageUrl)
            }
            Text(ticket.question)
            Spacer().frame(height: .zero)
            ForEach(ticket.options, id: \.self) { option in
                optionView(option)
            }
        }
    }
    
    private func imageView(_ url: URL?) -> some View {
        AsyncImage(url: url) { content in
            content
                .image?
                .resizable()
                .scaledToFill()
                .frame(alignment: .center)
        }
        .frame(width: 256, height: 128)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func optionView(_ value: String) -> some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
}

#Preview {
    let container = try! DataController.previewContainer
    
    let ticket = Ticket(
        id: "10",
        question: "Имеют ли право участники дорожно-транспортного происшествия получить первую медицинскую помощь, помощь спасателя или другого вида от уполномоченного государственного лица и от местных органов самоуправления, также от других уполномоченных лиц?",
        options: [
            "Имеют",
            "Не имеют"
        ],
        rightAnswer: 1,
        imageName: "154",
        explanation: "Согласно подпункта 1 пункта «Б.Д» статьи 20 Закона Грузии «О дорожном движении» участники дорожного движения имеют право на получение первой помощи, спасательной и иной помощи от государственных органов и органов местного самоуправления, уполномоченных закона, а также от иных уполномоченных лиц.Во время дорожно-транспортного происшествия.",
        score: .value(100)
    )
    container.mainContext.insert(ticket)
    
    return TicketCell(ticket: ticket)
        .padding()
}
