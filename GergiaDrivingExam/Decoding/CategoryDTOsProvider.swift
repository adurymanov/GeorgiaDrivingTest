import Foundation

struct CategoryDTOsProvider {
    
    let decoder: JSONDecoder
    
    let bundle: Bundle
    
    init(
        decoder: JSONDecoder = JSONDecoder(),
        bundle: Bundle = .main
    ) {
        self.decoder = decoder
        self.bundle = bundle
    }
    
    func categories() throws -> [CategoryDTO] {
        let ticketsFile = bundle.url(forResource: "categories", withExtension: "json")!
        let ticketsData = try Data(contentsOf: ticketsFile)
        return try decoder.decode([CategoryDTO].self, from: ticketsData)
    }
    
}
