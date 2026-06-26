import Foundation

enum BibleCategory: String, CaseIterable, Codable {
    case genesis = "Gênesis e Criação"
    case jesus = "Jesus e Evangelhos"
    case salmos = "Salmos e Provérbios"
    case atos = "Atos e Cartas"
    case profetas = "Profetas"
    case geral = "Geral"
}

struct QuizQuestion: Identifiable, Codable {
    let id: Int
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let reference: String
    let category: BibleCategory
    var propheticMeaning: String = ""

    var correctAnswer: String { options[correctIndex] }
}
