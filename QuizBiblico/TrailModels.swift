import Foundation

enum TrailNodeStatus: String, Codable {
    case locked
    case available
    case completed
}

struct TrailVerse: Identifiable {
    let id = UUID()
    let text: String
    let reference: String
}

struct TrailQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct TrailNodeData: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let emoji: String
    let reference: String
    let studyText: String
    let keyVerses: [TrailVerse]
    let questions: [TrailQuestion]
    var status: TrailNodeStatus
}
