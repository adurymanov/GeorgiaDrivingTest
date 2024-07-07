import Foundation

public struct ExplanationsParser {

    struct ExplanationDTO: Decodable {
        let translation: String
        let simplified: String?
    }

    public func decode(in folder: URL, locales: [Locale]) throws -> [TicketExplanation] {
        var result = [Int: [Locale: ExplanationDTO]]()
        let explanationFolder = folder.appendingPathComponent("explanations")
        for locale in locales {
            let explanations = try decode(in: explanationFolder, for: locale)
            for (id, explanation) in explanations {
                result[id, default: [:]][locale] = explanation
            } 
        }
        return groupByLocale(result).values.sorted { $0.id < $1.id }
    }

    private func groupByLocale(_ explanations: [Int: [Locale: ExplanationDTO]]) -> [Int: TicketExplanation] {
        var result = [Int: TicketExplanation]()
        for (id, explanations) in explanations {
            let translation = LocalizedText(value: explanations.mapValues { $0.translation })
            let simplified = LocalizedText(value: explanations.compactMapValues { $0.simplified })
            let ticketExplanation = TicketExplanation(
                id: "explanation_\(id)", 
                explanation: translation, 
                simpleExplanation: simplified
            )
            result[id] = ticketExplanation
        }
        return result
    }

    private func decode(in folder: URL, for locale: Locale) throws -> [Int: ExplanationDTO] {
        let localeFolderUrl = folder.appendingPathComponent("\(locale.rawValue)")
        let fileManager = FileManager.default
        let fileUrls = try! fileManager.contentsOfDirectory(at: localeFolderUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        var explanations = [Int: ExplanationDTO]()
        for fileUrl in fileUrls {
            let id = Int(fileUrl.deletingPathExtension().lastPathComponent)!
            let explanation: ExplanationDTO
            do {
                let content = try Data(contentsOf: fileUrl)
                explanation = try JSONDecoder().decode(ExplanationDTO.self, from: content)
            } catch {
                print("Error decoding explanation for ticket \(id) in locale \(locale.rawValue): \(error)")
                continue
            }
            explanations[id] = explanation
        }
        return explanations
    }

}
