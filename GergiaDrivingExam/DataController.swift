import SwiftData
import Foundation

@MainActor
final class DataController {
    
    static var previewContainer: ModelContainer {
        get throws {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(
                for: Ticket.self,
                configurations: config
            )
            
            let ticketsProvider = TicketDTOsProvider()
            let categoriesProvider = CategoryDTOsProvider()
            let ticketsByCategoryProvider = TicketByCategoryDTOProvider()
            
            let categoriesDTOs = try categoriesProvider.categories()
            let ticketsDTOs = try ticketsProvider.tickets()
            let ticketsByCategory = try ticketsByCategoryProvider.ticketsByCategory()

            let categories = categoriesDTOs.map { dto in
                Category(id: String(dto.id), name: dto.name)
            }
            let tickets = ticketsDTOs.map { dto in
                Ticket(
                    id: String(dto.id),
                    question: dto.question,
                    options: dto.answers,
                    rightAnswer: dto.rightAnswerIndex,
                    imageName: dto.imageName.isEmpty ? nil : dto.imageName,
                    explanation: dto.description,
                    score: nil
                )
            }
            
            for ticket in tickets {
                container.mainContext.insert(ticket)
            }
            for category in categories {
                container.mainContext.insert(category)
            }
            
            for (index, ticketIndexesInCategory) in ticketsByCategory.enumerated() {
                let ids = Set(ticketIndexesInCategory.keys)
                
                categories[index].tickets = tickets
                    .filter({ ids.contains($0.id) })
                    .sorted(by: {
                        ticketIndexesInCategory[$0.id, default: .zero] < ticketIndexesInCategory[$1.id, default: .zero]
                    })
            }
            
            return container
        }
    }
    
}
