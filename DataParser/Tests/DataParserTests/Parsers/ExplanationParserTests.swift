import Testing
import Foundation
@testable import DataParser

@Test func explanationParserTest() async throws {
    let rootFileUrl = Bundle.module.resourceURL!.appendingPathComponent("data")
    let decoder = ExplanationsParser()
    let explanations = try? decoder.decode(
        in: rootFileUrl,
        locales: Locale.translatedLocales
    )
    #expect(explanations?.isEmpty == false)
}
