struct LocalizedText: Codable {
    let value: [Locale: String]
}

extension LocalizedText {
    
    var searchValue: String {
        value.map(\.value).joined(separator: " ")
    }
    
    var defaultValue: String {
        value[.en] ?? ""
    }
    
}
