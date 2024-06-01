import SwiftUI
import SwiftData

struct LessonTaskScreen: View {
    
    private struct IndexedOption: Identifiable, Hashable {
        var id: String { value }
        let index: Int
        let value: String
    }
    
    @State private var selectedOption: IndexedOption?
    
    let ticket: Ticket
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading) {
                    if let imageUrl {
                        ticketImageView(imageUrl: imageUrl)
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
    }
    
    private var imageUrl: URL? {
        guard let imageName = ticket.imageName else {
            return nil
        }
        return Bundle.main.url(forResource: imageName, withExtension: "jpeg")
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
            
        } label: {
            Label("Help", systemImage: "questionmark.circle")
        }
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
    
    
    private func ticketImageView(imageUrl: URL) -> some View {
        AsyncImage(url: imageUrl) { content in
            content.image?.resizable().scaledToFit()
        }
        .background(.thinMaterial)
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Ticket.self,
        configurations: config
    )

    let ticket = Ticket(
        id: "10",
        question: "Имеют ли право участники дорожно-транспортного происшествия получить первую медицинскую помощь, помощь спасателя или другого вида от уполномоченного государственного лица и от местных органов самоуправления, также от других уполномоченных лиц?",
        options: [
            "Имеют",
            "Не имеют"
        ],
        rightAnswer: 1,
        imageName: "154",
        explanation: "explanation",
        score: 100
    )
    
    return NavigationStack {
        LessonTaskScreen(
            ticket: ticket
        )
    }
    .modelContainer(container)
}
