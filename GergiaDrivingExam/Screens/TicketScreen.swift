import SwiftUI

struct TicketScreen: View {
    
    private struct IndexedOption: Identifiable, Hashable {
        var id: String { value }
        let index: Int
        let value: String
    }
    
    @State private var helpTicket: Ticket?
    
    let ticket: Ticket
    
    var body: some View {
        ScrollView {
            if let url = ticket.imageUrl {
                TicketImageView(url: url)
            }
            Text(ticket.question).padding()
            optionsView
        }
        .toolbar {
            ToolbarItem {
                helpButtonView
            }
        }
        .navigationTitle("#\(ticket.id)")
        .sheet(item: $helpTicket) { ticket in
            NavigationStack {
                LessonTaskHelpScreen(ticket: ticket)
            }
        }
    }
    
    private var options: [IndexedOption] {
        ticket.options.enumerated().map {
            IndexedOption(index: $0.offset, value: $0.element)
        }
    }
    
    private var optionsView: some View {
        VStack {
            ForEach(options) { option in
                OptionCell(
                    value: option.value,
                    highlighted: ticket.rightAnswer == option.index
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var helpButtonView: some View {
        Button {
            helpTicket = ticket
        } label: {
            Label("Help", systemImage: "questionmark.circle")
        }
        .disabled(ticket.explanation == nil)
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
    
    return NavigationStack {
        TicketScreen(ticket: ticket)
    }
}
