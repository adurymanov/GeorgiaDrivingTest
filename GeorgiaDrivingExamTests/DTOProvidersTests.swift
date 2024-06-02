import XCTest
@testable import GergiaDrivingExam

final class DTOProvidersTests: XCTestCase {
    
    func testTicketDTOsProvider() throws {
        let provider = TicketDTOsProvider()
        let items = try provider.tickets()
        
        XCTAssert(!items.isEmpty)
    }
    
    func testCategoriesDTOsProvider() throws {
        let provider = CategoryDTOsProvider()
        let items = try provider.categories()
        
        XCTAssert(!items.isEmpty)
    }
    
    func testTicketByCategoryDTOsProvider() throws {
        let provider = TicketByCategoryDTOProvider()
        let items = try provider.ticketsByCategory()
        
        XCTAssert(!items.isEmpty)
    }
    
}
