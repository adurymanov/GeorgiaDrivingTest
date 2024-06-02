import Foundation

struct TicketDTOsProvider {
    
    let decoder: JSONDecoder
    
    let bundle: Bundle
    
    init(
        decoder: JSONDecoder = JSONDecoder(),
        bundle: Bundle = .main
    ) {
        self.decoder = decoder
        self.bundle = bundle
    }
    
    func tickets() throws -> [TicketDTO] {
        let ticketsFile = bundle.url(forResource: "tickets", withExtension: "json")!
        let ticketsData = try Data(contentsOf: ticketsFile)
        return try decoder.decode([TicketDTO].self, from: ticketsData)
    }
    
}
