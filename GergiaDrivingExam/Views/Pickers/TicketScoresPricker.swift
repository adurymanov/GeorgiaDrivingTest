import SwiftUI

struct TicketScoresPricker: View {
    
    @Binding var selection: Set<TicketScore>
    
    let scores: [TicketScore]
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(scores) { score in
                scoreCell(score).onTapGesture {
                    toggle(score)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func scoreCell(_ score: TicketScore) -> some View {
        scoreTitle(score)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.thinMaterial)
            .background(scoreBackground(score))
    }
    
    private func scoreTitle(_ score: TicketScore) -> Text {
        switch score {
        case .empty:
            Text("-")
        case let .value(int):
            Text(int, format: .number)
        }
    }
    
    private func scoreBackground(_ score: TicketScore) -> some View {
        Group {
            switch score {
            case .empty:
                Color.secondary
            case let .value(score) where score < 0:
                Color.red
            case let .value(score) where score >= 0:
                Color.green
            default:
                Color.secondary
            }
        }
        .opacity(selection.contains(score) ? 1 : 0.3)
    }
    
    private func toggle(_ score: TicketScore) {
        if selection.contains(score) {
            selection.remove(score)
        } else {
            selection.insert(score)
        }
    }
    
}

