import Foundation

struct TicketByCategoryDTOProvider {
    
    let decoder: JSONDecoder
    
    let bundle: Bundle
    
    init(
        decoder: JSONDecoder = JSONDecoder(),
        bundle: Bundle = .main
    ) {
        self.decoder = decoder
        self.bundle = bundle
    }
    
    func ticketsByCategory() throws -> [[String: Int]] {
        let ticketsFile = bundle.url(forResource: "ticketsByCat", withExtension: "json")!
        let ticketsData = try Data(contentsOf: ticketsFile)
        return try decoder.decode([[String: Int]].self, from: ticketsData)
    }
    
}
