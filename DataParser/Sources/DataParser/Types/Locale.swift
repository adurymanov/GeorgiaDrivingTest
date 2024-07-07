public enum Locale: String, Hashable, CaseIterable, Sendable {
    case ru
    case en
    case ka
    case ab
    case az
    case hy
    case os
    case tr
}

extension Locale {

    static let translatedLocales: [Locale] = [.ru, .en, .ka, .hy, .tr, .az]

}
