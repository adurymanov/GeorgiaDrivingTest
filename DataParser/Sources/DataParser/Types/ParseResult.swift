public struct ParseResult: Sendable {
    public let tickets: [Ticket]
    public let categories: [TicketCategory]
    public let explanations: [TicketExplanation]
    public let licenseCategories: [LicenseCategory]
}
