import Foundation

public struct CategoriesParser {

    public func parse(in folder: URL, locales: [Locale]) -> [TicketCategory] {
        let categoriesFolder = folder.appendingPathComponent("categories")
        var result = [String: [Locale: String]]()
        for locale in locales {
            let categories = parse(in: categoriesFolder, for: locale)
            for (id, name) in categories {
                result[id, default: [:]][locale] = name
            }
        }
        return groupByLocale(result).values.sorted { $0.id < $1.id }
    }

    private func groupByLocale(_ categories: [String: [Locale: String]]) -> [String: TicketCategory] {
        var result = [String: TicketCategory]()
        for (id, names) in categories {
            let name = LocalizedText(value: names.mapValues { $0 })
            let ticketCategory = TicketCategory(
                id: id, 
                name: name
            )
            result[id] = ticketCategory
        }
        return result
    }

    private func parse(in folder: URL, for locale: Locale) -> [String: String] {
        // Parse categories form file in folder for locale like "en.json"
        // in file dictionary with key-value pairs like "id": "localized name"
        let localeFolderUrl = folder.appendingPathComponent("\(locale.rawValue).json")
        let content = try! Data(contentsOf: localeFolderUrl)
        return try! JSONDecoder().decode([String: String].self, from: content)
    }

}
