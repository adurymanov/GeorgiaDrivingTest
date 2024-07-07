import Testing
import Foundation
@testable import DataParser

@Test func categoriesParserTest() async throws {
    let rootFileUrl = Bundle.module.resourceURL!.appendingPathComponent("data")
    let decoder = CategoriesParser()
    let categories = decoder.parse(
        in: rootFileUrl,
        locales: Locale.translatedLocales
    )
    #expect(categories.isEmpty == false)
    #expect(categories.reduce(into: 0) { $0 += $1.name.value.count } == 192)
}
