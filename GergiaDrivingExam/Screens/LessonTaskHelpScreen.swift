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
        Text(ticket.explanation)
            .padding()
    }
    
    private var closeButton: some View {
        Button("Done") {
            dismiss()
        }
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
        explanation: "Согласно подпункта 1 пункта «Б.Д» статьи 20 Закона Грузии «О дорожном движении» участники дорожного движения имеют право на получение первой помощи, спасательной и иной помощи от государственных органов и органов местного самоуправления, уполномоченных закона, а также от иных уполномоченных лиц.Во время дорожно-транспортного происшествия.",
        score: 100
    )
    
    return NavigationStack {
        LessonTaskHelpScreen(
            ticket: ticket
        )
    }
    .modelContainer(container)
}
