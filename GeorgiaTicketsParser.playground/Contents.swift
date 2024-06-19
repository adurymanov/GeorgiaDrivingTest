import Foundation

// 1811 tickets

struct Ticket: Identifiable {
    let id: String
    let question: String
    let explanation: String
    let options: [String]
    let imageUrl: URL?
    let ticketCategory: String
    let licenceCategory: String
}

let ticketUrl = URL(string: "https://teoria.on.ge/tickets?ticket=1500")!
var request = URLRequest(url: ticketUrl)

request.setValue("exam-settings=%7B%22category%22%3A2%2C%22locale%22%3A%22en%22%2C%22skin%22%3A%22dark%22%2C%22user%22%3A0%2C%22created%22%3A1718565687%7D", forHTTPHeaderField: "Cookie")
request.httpShouldHandleCookies = true


let (data, _) = try await URLSession.shared.data(for: request)
let pageContent = String(data: data, encoding: .utf8)!

print(pageContent)
