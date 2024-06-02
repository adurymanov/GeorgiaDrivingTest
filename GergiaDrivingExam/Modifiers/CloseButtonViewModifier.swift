import SwiftUI

struct CloseButtonViewModifier: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                closeButton
            }
        }
    }
    
    private var closeButton: some View {
        Button("Close") {
            dismiss()
        }
    }
    
}

extension View {
    
    func closeButton() -> some View {
        modifier(CloseButtonViewModifier())
    }
    
}
