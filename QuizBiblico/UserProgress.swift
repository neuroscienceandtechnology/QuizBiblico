import Foundation

struct UserProgress: Codable {
    var totalAnswered: Int = 0
    var totalCorrect: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var lastPlayedDate: Date?
    var answeredQuestionIDs: [Int] = []
    var dailyChallengeCompletedDate: Date?

    var accuracy: Double {
        guard totalAnswered > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalAnswered) * 100
    }

    static func load() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: "userProgress"),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return UserProgress()
        }
        return progress
    }

    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        UserDefaults.standard.set(data, forKey: "userProgress")
    }
}
