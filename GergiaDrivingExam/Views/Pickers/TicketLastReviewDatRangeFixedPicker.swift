import SwiftUI

struct TicketLastReviewDatRangeFixedPicker: View {
    
    struct NamedDateRange: Identifiable, Hashable {
        var id: String { name }
        let name: String
        let range: ClosedRange<Date>
    }
    
    @Binding var selection: ClosedRange<Date>?
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(namedDatesRanges) { range in
                fixedDateRangeView(title: range.name, range: range.range).onTapGesture {
                    toggle(range.range)
                }
            }
        }
    }
    
    var namedDatesRanges: [NamedDateRange] {
        let calendar = Calendar.current
        let now = Date()

        // Get start and end of today
        guard let todayStart = calendar.startOfDay(for: now) as Date?,
              let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)?.addingTimeInterval(-1) else {
            return []
        }

        // Get start and end of yesterday
        guard let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart),
              let yesterdayEnd = calendar.date(byAdding: .day, value: 1, to: yesterdayStart)?.addingTimeInterval(-1) else {
            return []
        }

        let todayRange: ClosedRange<Date> = todayStart...todayEnd
        let yesterdayRange: ClosedRange<Date> = yesterdayStart...yesterdayEnd

        return [
            NamedDateRange(name: "Today", range: todayRange),
            NamedDateRange(name: "Yesterday", range: yesterdayRange)
        ]
    }
    
    private func fixedDateRangeView(title: String, range: ClosedRange<Date>) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.thinMaterial)
            .background(selection == range ? .green : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
    private func toggle(_ range: ClosedRange<Date>) {
        if selection == range {
            selection = nil
        } else {
            selection = range
        }
    }
    
}
