import SwiftUI
import SwiftData

struct LessonTaskScreen: View {
    
    private struct IndexedOption: Identifiable, Hashable {
        var id: String { value }
        let index: Int
        let value: String
    }
    
    @State private var selectedOption: IndexedOption?
    
    @State private var helpTicket: Ticket?
    
    let ticket: Ticket
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading) {
                    if let url = ticket.imageUrl {
                        TicketImageView(url: url)
                    }
                    questionView
                    optionsSelectorView
                }
            }
            if selectedOption != nil {
                nextButtonView
            } else {
                skipButtonView
            }
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
            IndexedOption(index: $0.0, value: $0.1)
        }
    }
    
    private var questionView: some View {
        Text(ticket.question)
            .padding()
    }
    
    private var optionsSelectorView: some View {
        ForEach(options) { option in
            Button {
                select(option: option)
            } label: {
                OptionCell(
                    value: option.value,
                    style: optionCellStyle(option: option),
                    highlighted: option == selectedOption
                )
            }
            .disabled(selectedOption != nil)
        }
        .padding(.horizontal)
    }
    
    private var nextButtonView: some View {
        Button {
            nextTicket()
        } label: {
            Text("Next ticket")
                .frame(maxWidth: .infinity)
                .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    private var skipButtonView: some View {
        Button {
            skipTicket()
        } label: {
            Text("Skip ticket")
                .frame(maxWidth: .infinity)
                .padding(8)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .tint(.clear)
        .foregroundStyle(.primary)
    }
    
    private var helpButtonView: some View {
        Button {
            helpTicket = ticket
        } label: {
            Label("Help", systemImage: "questionmark.circle")
        }
        .disabled(ticket.explanation == nil)
    }
    
    private func optionCellStyle(option: IndexedOption) -> OptionCell.Style {
        guard let selectedOption else { return .normal }
        
        return if option.index == ticket.rightAnswer {
            .right
        } else if option.index == selectedOption.index {
            .wrong
        } else {
            .normal
        }
    }
    
    private func select(option: IndexedOption) {
        guard selectedOption == nil else { return }
        selectedOption = option
    }
    
    private func skipTicket() {
        
    }
    
    private func nextTicket() {
        
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
        score: 100
    )
    
    return NavigationStack {
        LessonTaskScreen(
            ticket: ticket
        )
    }
    .modelContainer(container)
}
