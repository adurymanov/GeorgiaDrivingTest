import SwiftUI

struct OptionSelectableCell: View {
    
    private struct Configuration {
        let selectorImage: String
        let selectorColor: Color
        let highlightColor: Color
    }
    
    enum Style {
        case normal
        case right
        case wrong
    }
    
    let value: String
    
    let style: Style
    
    let highlighted: Bool
    
    init(
        value: String,
        style: Style = .normal,
        highlighted: Bool = false
    ) {
        self.value = value
        self.style = style
        self.highlighted = highlighted
    }
    
    var body: some View {
        HStack {
            selectorView
            valueView
            Spacer()
        }
        .padding(8)
        .background(.thinMaterial)
        .background(highlighted ? configuration.highlightColor : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
        .foregroundStyle(.primary)
    }
    
    private var configuration: Configuration {
        switch style {
        case .normal:
            Configuration(
                selectorImage: "circle",
                selectorColor: .secondary,
                highlightColor: .clear
            )
        case .right:
            Configuration(
                selectorImage: "checkmark.circle.fill",
                selectorColor: .green,
                highlightColor: .green.opacity(0.3)
            )
        case .wrong:
            Configuration(
                selectorImage: "xmark.circle.fill",
                selectorColor: .red,
                highlightColor: .red.opacity(0.3)
            )
        }
    }
    
    private var valueView: some View {
        Text(value)
            .multilineTextAlignment(.leading)
    }
    
    private var selectorView: some View {
        Image(systemName: configuration.selectorImage)
            .foregroundStyle(configuration.selectorColor)
    }
    
}

#Preview("OptionCell: Normal") {
    OptionSelectableCell(
        value: "Имеют",
        style: .normal
    )
    .padding()
}

#Preview("OptionCell: Right") {
    VStack {
        OptionSelectableCell(
            value: "Имеют",
            style: .right
        )
        OptionSelectableCell(
            value: "Имеют",
            style: .right,
            highlighted: true
        )
    }
    .padding()
}

#Preview("OptionCell: Wrong") {
    VStack {
        OptionSelectableCell(
            value: "Имеют",
            style: .wrong
        )
        OptionSelectableCell(
            value: "Имеют",
            style: .wrong,
            highlighted: true
        )
    }
    .padding()
}

