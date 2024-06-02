struct CategoryDTO: Identifiable, Hashable {
    let id: Int
    let name: String
}

extension CategoryDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "categoryName"
    }
    
}
