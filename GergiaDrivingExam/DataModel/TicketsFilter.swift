import Foundation
import SwiftData

@Model
final class TicketsFilter {
    
    private var _lastReviewMinDate: Date?
    
    private var _lastReviewMaxDate: Date?
    
    var scores: Set<TicketScore>
    
    var categories: Set<TicketCategory.ID>
    
    var lastReviewDateRange: ClosedRange<Date>? {
        get {
            guard let _lastReviewMinDate, let _lastReviewMaxDate else {
                return nil
            }
            return _lastReviewMinDate..._lastReviewMaxDate
        }
        set {
            _lastReviewMinDate = newValue?.lowerBound
            _lastReviewMaxDate = newValue?.upperBound
        }
    }
    
    init(
        lastReviewDateRange: ClosedRange<Date>?,
        scores: Set<TicketScore>,
        categories: Set<TicketCategory.ID>
    ) {
        self._lastReviewMinDate = lastReviewDateRange?.lowerBound
        self._lastReviewMaxDate = lastReviewDateRange?.upperBound
        self.scores = scores
        self.categories = categories
    }
    
    var isEmpty: Bool {
        scores.isEmpty 
        && categories.isEmpty
        && _lastReviewMinDate == nil
        && _lastReviewMaxDate == nil
    }
    
}
