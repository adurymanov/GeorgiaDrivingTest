import SwiftUI

struct AnswerCell: View {
    
    let answer: Answer
    
    var body: some View {
        Text("Answer: \(answer.id)")
    }
    
}
