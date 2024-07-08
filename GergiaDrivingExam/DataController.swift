import SwiftData
import Foundation

@MainActor
final class DataController {
    
    static var appContainer: ModelContainer {
        get throws {
            let config = ModelConfiguration()
            let container = try! ModelContainer(
                for: Ticket.self, TicketsFilter.self,
                configurations: config
            )
            
            if let newData = try parseTickets() {
                try setup(context: container.mainContext, data: newData)
            }
            
            return container
        }
    }
    
    static var previewContainer: ModelContainer {
        get throws {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(
                for: Ticket.self, TicketsFilter.self,
                configurations: config
            )
            
            if let newData = try parseTickets() {
                try setup(context: container.mainContext, data: newData)
            }
            
            return container
        }
    }
    
}

import ZIPFoundation
import DataParser

struct Metadata: Decodable {
    let version: String
}

private func parseTickets(fileManager: FileManager = .default, userDefaults: UserDefaults = .standard) throws -> ParseResult? {
    guard let resourceFile = Bundle.main.url(forResource: "data", withExtension: "zip") else {
        return nil
    }
    let version = userDefaults.string(forKey: "data_version") ?? "0.0.0"
    let tmpFolder = fileManager.temporaryDirectory.appending(path: UUID().uuidString)
    
    try fileManager.unzipItem(at: resourceFile, to: tmpFolder)
    
    let dataFolder = tmpFolder.appending(path: "data")
    
    let metadataUrl = dataFolder.appending(path: "metadata.json")
    let metadata = try JSONDecoder().decode(Metadata.self, from: Data(contentsOf: metadataUrl))
    
    guard version != metadata.version else {
        return nil
    }
    
    let data = try TicketsDataParser().parse(in: dataFolder)
    
    userDefaults.setValue(metadata.version, forKey: "data_version")
    
    return data
}

private func setup(context: ModelContext, data: ParseResult) throws {
    let explanations = data.explanations.map {
        TicketExplanation(
            id: $0.id,
            explanation: LocalizedText(data: $0.explanation),
            simplified: LocalizedText(data: $0.simpleExplanation)
        )
    }
    let categories = data.categories.map {
        TicketCategory(
            id: $0.id,
            name: LocalizedText(data: $0.name)
        )
    }
    let licenseCategories = data.licenseCategories.map {
        Category(
            id: $0.name,
            name: $0.name
        )
    }
    let tickets = data.tickets.map {
        Ticket(
            id: "\($0.id)",
            question: LocalizedText(data: $0.question),
            rightOptionId: $0.rightOptionId,
            imageName: $0.imageName
        )
    }
    let options = data.tickets.flatMap(\.options).map {
        Option(
            id: $0.id,
            index: $0.index,
            text: LocalizedText(data: $0.value)
        )
    }
    
    for explanation in explanations {
        context.insert(explanation)
    }
    for category in categories {
        context.insert(category)
    }
    for licenseCategory in licenseCategories {
        context.insert(licenseCategory)
    }
    for ticket in tickets {
        context.insert(ticket)
    }
    for option in options {
        context.insert(option)
    }
    
    let explanationsById = Dictionary(uniqueKeysWithValues: explanations.map({ ($0.id, $0) }))
    let categoriesById = Dictionary(uniqueKeysWithValues: categories.map({ ($0.id, $0) }))
    let licenseCategoriesById = Dictionary(uniqueKeysWithValues: licenseCategories.map({ ($0.id, $0) }))
    let ticketsById = Dictionary(uniqueKeysWithValues: tickets.map({ ($0.id, $0) }))
    let optionsById = Dictionary(uniqueKeysWithValues: options.map({ ($0.id, $0) }))
    
    
    for ticket in data.tickets {
        let ticketModel = ticketsById["\(ticket.id)"]!
        
        ticketModel.explanation = ticket.explanation.flatMap { explanationsById[$0.id] }
        ticketModel.options = ticket.options.compactMap { optionsById[$0.id] }
        ticketModel.group = categoriesById[ticket.ticketCategory.id]
        ticketModel.categories = ticket.licenseCategories.compactMap { licenseCategoriesById[$0.name] }
    }
    
    try context.save()
}

extension Locale {
    
    init(data: DataParser.Locale) {
        self = switch data {
        case .ab: .ab
        case .az: .az
        case .ru: .ru
        case .en: .en
        case .ka: .ka
        case .hy: .hy
        case .os: .os
        case .tr: .tr
        }
    }
    
}

extension LocalizedText {
    
    init(data: DataParser.LocalizedText) {
        self.init(
            value:  Dictionary(
                uniqueKeysWithValues: data.value.map({ (Locale(data: $0.key), $0.value) })
            )
        )
    }
    
}
