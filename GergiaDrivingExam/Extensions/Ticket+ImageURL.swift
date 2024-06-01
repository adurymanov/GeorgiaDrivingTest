import Foundation

extension Ticket {
    
    var imageUrl: URL? {
       guard let imageName else { return nil }
       return Bundle.main.url(forResource: imageName, withExtension: "jpeg")
   }
    
}
