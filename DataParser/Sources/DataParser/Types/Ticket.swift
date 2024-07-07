public struct Ticket: Identifiable, Hashable {
    public let id: Int
    public let explanation: TicketExplanation?
    public let licenseCategories: [LicenseCategory]
    public let question: LocalizedText
    public let imageName: String
    public let options: [Option]
    public let rightOptionId: Option.ID
    public let ticketCategory: TicketCategory
}
