import SwiftUI
import SwiftData

struct LessonTaskHelpScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let ticket: Ticket
    
    var body: some View {
        ScrollView {
            explanationView
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                closeButton
            }
        }
        .navigationTitle("#\(ticket.id)")
    }
    
    private var explanationView: some View {
        Group {
            if let explanation = ticket.explanation {
                Text(explanation.explanation.defaultValue)
            } else {
                Text("No explanation").foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var closeButton: some View {
        Button("Done") {
            dismiss()
        }
    }
    
}

#Preview {
    let container = try! DataController.previewContainer

    let ticket = Ticket(
        id: "10",
        question: .init(value: [.ru: "Имеют ли право участники дорожно-транспортного происшествия получить первую медицинскую помощь, помощь спасателя или другого вида от уполномоченного государственного лица и от местных органов самоуправления, также от других уполномоченных лиц?",]), 
        rightOptionId: "1",
        imageName: "154", 
        score: .value(100),
        options: [
            .init(id: "1", index: 1, text: .init(value: [.ru: "Имеют"])),
            .init(id: "2", index: 2, text: .init(value: [.ru: "Не имеют"])),
        ],
        explanation: .init(
            id: "1",
            explanation: .init(value: [.ru: "Согласно подпункта 1 пункта «Б.Д» статьи 20 Закона Грузии «О дорожном движении» участники дорожного движения имеют право на получение первой помощи, спасательной и иной помощи от государственных органов и органов местного самоуправления, уполномоченных закона, а также от иных уполномоченных лиц.Во время дорожно-транспортного происшествия."]),
            simplified: nil
        )
    )
    
    NavigationStack {
        LessonTaskHelpScreen(
            ticket: ticket
        )
    }
    .modelContainer(container)
}
