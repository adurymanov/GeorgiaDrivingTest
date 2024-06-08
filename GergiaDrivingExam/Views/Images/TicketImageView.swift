import SwiftUI

struct TicketImageView: View {
    
    struct Magnification: Equatable {
        let magnification: CGFloat
        let anchor: UnitPoint
    }
    
    @State private var magnifyBy: Magnification = Magnification(
        magnification: 1,
        anchor: UnitPoint(x: 0.5, y: 0.5)
    )
    
    @GestureState private var offset: CGSize = .zero

    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { content in
            content.image?.resizable().scaledToFit()
        }
        .scaleEffect(magnifyBy.magnification, anchor: magnifyBy.anchor)
        .offset(offset)
        .animation(.default, value: magnifyBy)
        .overlay {
            GeometryReader { proxy in
                Color
                    .clear
                    .contentShape(Rectangle())
                    .gesture(zoomGesture(proxy: proxy))
                    .gesture(dragGesture(proxy: proxy))
            }
        }
        .clipped()
        .background(.thinMaterial)
    }
    
    private func zoomGesture(proxy: GeometryProxy) -> some Gesture {
        SpatialTapGesture(count: 1).onEnded { value in
            magnifyBy = if magnifyBy.magnification == 1 {
                Magnification(
                    magnification: 2,
                    anchor: UnitPoint(
                        x: value.location.x / proxy.size.width,
                        y: value.location.y / proxy.size.height
                    )
                )
            } else {
                Magnification(
                    magnification: 1,
                    anchor: UnitPoint(x: 0.5, y: 0.5)
                )
            }
        }
    }
    
    private func dragGesture(proxy: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: .zero).updating($offset) { value, state, _ in
            guard magnifyBy.magnification == 2 else {
                return
            }
            state = value.translation
        }
    }
    
}

#Preview {
    TicketImageView(
        url: Bundle.main.url(
            forResource: "154",
            withExtension: "jpeg"
        )
    )
}
