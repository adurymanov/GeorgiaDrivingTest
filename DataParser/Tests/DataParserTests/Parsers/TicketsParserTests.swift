import Testing
import Foundation
@testable import DataParser

@Test func ticketsParserTest() async throws {
    let rootFileUrl = Bundle.module.resourceURL!.appendingPathComponent("data")
    let decoder = TicketsParser(
        categories: CategoriesParser().parse(
            in: rootFileUrl,
            locales: Locale.translatedLocales
        ),
        explanations: try ExplanationsParser().decode(
            in: rootFileUrl,
            locales: Locale.translatedLocales
        )
    )
    let tickets = try decoder.parse(
        from: rootFileUrl,
        for: Locale.allCases
    )
    #expect(tickets.isEmpty == false)
}
