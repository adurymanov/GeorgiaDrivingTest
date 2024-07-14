import Foundation

extension Ticket {
    
    var imageUrl: URL? {
        guard let imageName else { return nil }
        guard let name = imageName.split(separator: ".").first else { return nil }
        return Bundle.main.url(forResource: String(name), withExtension: "heic")
   }
    
}
