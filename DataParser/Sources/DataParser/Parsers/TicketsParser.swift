import Foundation

struct TicketsParser {

    enum TicketsParserError: Error {
        case rightOptionNotFound(ticketId: Int)
    }

    private struct TicketDTO: Decodable {
        let question: String
        let options: [OptionDTO]
        let licenceCategories: [String]
        let explanation: String?
        let ticketCategory: String
        let imageUrl: String?
        let id: Int
    }

    private struct OptionDTO: Decodable {
        let index: Int
        let value: String
        let isRight: Bool
    }

    let categories: [TicketCategory]

    let explanations: [TicketExplanation]

    private var categoriesByName: [String: TicketCategory] {
        Dictionary(uniqueKeysWithValues: categories.map { ($0.name.value[.ka] ?? "", $0) })
    }

    func parse(from folder: URL, for locales: [Locale]) throws -> [Ticket] { 
        let ticketsFolder = folder.appendingPathComponent("tickets")
        var result = [Int: [Locale: TicketDTO]]()
        for locale in locales {
            let tickets = try parse(from: ticketsFolder, for: locale)
            for (id, ticket) in tickets where ticket.question != "" {
                result[id, default: [:]][locale] = ticket
            }
        }
        return try groupByLocale(result).values.sorted { $0.id < $1.id }
    }

    private func groupByLocale(_ tickets: [Int: [Locale: TicketDTO]]) throws -> [Int: Ticket] {
        var result = [Int: Ticket]()
        for (id, tickets) in tickets {
            let question = LocalizedText(value: tickets.mapValues { $0.question })
            let optionsValues = try parseOptions(ticketId: id, ticket: tickets)
            let ticketCategory = categoriesByName[tickets[.ka]!.ticketCategory]!
            let explanation = explanations.first { $0.id == explanationId(from: id) }
            let licenseCategories = tickets[.ka]!.licenceCategories.map { LicenseCategory(name: $0) }
            let ticket = Ticket(
                id: id,
                explanation: explanation,
                licenseCategories: licenseCategories,
                question: question,
                imageName: "\(id).heic",
                options: optionsValues.options,
                rightOptionId: optionsValues.right,
                ticketCategory: ticketCategory
            )
            result[id] = ticket
        }
        return result
    }

    private func parseOptions(ticketId: Int, ticket: [Locale: TicketDTO]) throws -> (options: [Option], right: Option.ID) {
        let options = ticket.mapValues { $0.options }
        var optionsByIndex: [Int: [Locale: OptionDTO]] = [:]
        for (locale, options) in options {
            for option in options {
                optionsByIndex[option.index, default: [:]][locale] = option
            }
        }
        var result = [Option]()
        for (index, options) in optionsByIndex {
            let value = LocalizedText(value: options.mapValues { $0.value })
            let option = Option(
                id: "\(ticketId)_\(index)",
                index: index,
                value: value
            )
            result.append(option)
        }
        let rightOptionIndex = ticket[.ka]!.options.first { $0.isRight }?.index

        guard let rightOptionIndex = rightOptionIndex else {
            throw TicketsParserError.rightOptionNotFound(ticketId: ticketId)
        }

        let rightOptionId = "\(ticketId)_\(rightOptionIndex)"

        return (result, rightOptionId)
    }
    
    private func parse(from folder: URL, for locale: Locale) throws -> [Int: TicketDTO] {
        let localeFolderUrl = folder.appendingPathComponent("tickets-\(locale.rawValue).json")
        let content = try Data(contentsOf: localeFolderUrl)
        let tickets = try JSONDecoder().decode([TicketDTO].self, from: content)

        return Dictionary(uniqueKeysWithValues: tickets.map { ($0.id, $0) })
    }

    private func explanationId(from ticketId: Int) -> String {
        "explanation_\(ticketId)"
    }

}

// {"question":"F[sw f[sh[fh0fkf tb0fqef> f,fh0 fvfimsyf6`f hshys7`f8w`f h7syn` fv8f f0fhf ps[`0flf?","options":[{"index":1,"value":"Fblfhfn` vfimsyf fhys7`f8","isRight":false},{"value":"Fvfimsyf kfc fhys7`f8","isRight":true,"index":2}],"licenceCategories":["[B, B1]","[Tram]","[B+C1 Mil]"],"explanation":"„საგზაო მოძრაობის შესახებ“ საქართველოს კანონის 36-ე მუხლის მე-4 პუნქტის „გ“ ქვეპუნქტის თანახმად, თანაბარმნიშვნელოვანი გზების გადაკვეთაზე ურელსო სატრანსპორტო საშუალების მძღოლი ვალდებულია გზა დაუთმოს მარჯვნიდან მოახლოებულ სატრანსპორტო საშუალებას. ამავე წესით უნდა იხელმძღვანელონ ურთიერთშორის რელსიანი სატრანსპორტო საშუალებების მძღოლებმაც. ასეთ გზაჯვარედინზე რელსიან სატრანსპორტო საშუალებას აქვს უპირატესობა ურელსო სატრანსპორტო საშუალების მიმართ, მიუხედავად მისი მოძრაობის მიმართულებისა.","ticketCategory":"გზაჯვარედინის გავლა","imageUrl":"http:\/\/teoria.on.ge\/files\/new\/f24b95a352dc25441ea2b32cb823623b.jpg","id":1},{"explanation":"„საგზაო მოძრაობის შესახებ“ საქართველოს კანონის 25-ე მუხლის მე-7 პუნქტის თანახმად, მძღოლმა მიმდებარე ტერიტორიიდან გზაზე გამოსვლისას ან გზიდან ასეთ ტერიტორიაზე შესვლისას გზა უნდა დაუთმოს ქვეითებს.","licenceCategories":["[A, A1]","[B, B1]","[C]","[C1]","[D]","[D1]","[T, S]","[Tram]","[B+C1 Mil]"],"ticketCategory":"მოძრაობა, მანევრირება, სავალი ნაწილი","id":2,"question":"Fvfimsyf 7f9im fhys7`f8> bf9ye fqfrshflumsk f7syn` fv8fcsh0f lfyfkfkj fimf7fef8 fv8f b0fhf b[`0jevf?","options":[{"index":1,"value":"B[`0jeg","isRight":true},{"index":2,"value":"B[`0fv","isRight":false}],"imageUrl":"http:\/\/teoria.on.ge\/files\/new\/3901279bfb0b8ba384efab93b45e69c7.jpg"},{"id":3,"question":"Fkfifh,fuf f,hb fhlshufps f,fh0 fnhfycgjhnn` [fh[`fuf6`f h7syn` f[sw f[sh[fh0fkf fb0fqhf fpby pvflf?","imageUrl":"http:\/\/teoria.on.ge\/files\/new\/b3f0938beb8b1ee8547668238de1fc85.jpg","ticketCategory":"შუქნიშნის სიგნალები","explanation":"„საგზაო მოძრაობის შესახებ“ საქართველოს კანონის 29-ე მუხლის მე-2 პუნქტის „ა“ და „ე“ ქვეპუნქტების თანახმად, შუქნიშნის ფერად მაშუქ სიგნალებს აქვთ შემდეგი მნიშვნელობა: ა) წითელი მაშუქი სიგნალი ან წითელი მოციმციმე მაშუქი სიგნალი კრძალავს მოძრაობას; ე) მწვანე მაშუქი სიგნალი რთავს მოძრაობის ნებას.","options":[{"isRight":true,"value":"Fvfimsyf kfc fhys7`f8","index":1},{"index":2,"value":"Fvjnjwbrk fhys7`f8","isRight":false}],"licenceCategories":["[A, A1]","[AM]"]},{"id":4,"explanation":"„საგზაო მოძრაობის შესახებ“ საქართველოს კანონის 36-ე მუხლის მე-3 პუნქტის „ა“ ქვეპუნქტის თანახმად, რეგულირებულ გზაჯვარედინზე, შუქნიშნის მწვანე სიგნალის ჩართვის დროს მარცხნივ მოხვევისას ან მობრუნებისას, ურელსო სატრანსპორტო საშუალების მძღოლი ვალდებულია გზა დაუთმოს საპირისპირო მიმართულებიდან პირდაპირ ან მარჯვნივ მოძრავ სატრანსპორტო საშუალებას. ამავე კანონის 28-ე მუხლის მე-3 პუნქტის თანახმად შუქნიშნის მაშუქი სიგნალების მოთხოვნებს აქვს უპირატესი ძალა გავლის უპირატესობის განმსაზღვრელი საგზაო ნიშნებისა და საგზაო მონიშვნების მოთხოვნების მიმართ.","imageUrl":"http:\/\/teoria.on.ge\/files\/new\/3d3547b9cf89d34451ed9ccef0fe0f1c.jpg","ticketCategory":"შუქნიშნის სიგნალები","licenceCategories":["[B, B1]","[Tram]","[B+C1 Mil]"],"options":[{"isRight":false,"index":1,"value":"Fvfimsyf bfq`f fhys7`f8"},{"index":2,"value":"Fvfimsyf ir`fr`f fhys7`f8","isRight":true}],"question":"F[sw f[sh[fh0fkf tb0fqef f,fh0 fvfimsyf6`f hshys7`uf8w`f h7syn` f9s;`fhf pvflf?"},
