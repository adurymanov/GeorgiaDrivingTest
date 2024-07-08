import Foundation

public struct TicketsDataParser {

    public func parse(in rootFolder: URL) throws -> ParseResult {
        let categories = CategoriesParser().parse(
            in: rootFolder,
            locales: Locale.translatedLocales
        )
        let explanations = try ExplanationsParser().decode(
            in: rootFolder,
            locales: Locale.translatedLocales
        )
        let tickets = try TicketsParser(
            categories: categories,
            explanations: explanations
        ).parse(
            from: rootFolder,
            for: Locale.allCases
        )

        return ParseResult(
            tickets: tickets,
            categories: categories,
            explanations: explanations,
            licenseCategories: Set(tickets.flatMap(\.licenseCategories)).sorted { $0.name < $1.name } 
        )
    }
    
    public init() {}

}
