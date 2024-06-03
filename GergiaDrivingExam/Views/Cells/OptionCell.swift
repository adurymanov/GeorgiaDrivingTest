import SwiftUI

struct OptionCell: View {
    
    private struct Configuration {
        let highlightColor: Color
    }
    
    let value: String
    
    let highlighted: Bool
    
    var body: some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.thinMaterial)
            .background(highlighted ? .green : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .multilineTextAlignment(.leading)
    }
    
}

#Preview("OptionCell") {
    OptionCell(value: "Value", highlighted: false)
        .padding()
}

#Preview("OptionCell: Highlighted") {
    OptionCell(value: "Value", highlighted: true)
        .padding()
}
