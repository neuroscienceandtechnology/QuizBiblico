import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentQuestion: QuizQuestion?
    @Published var selectedAnswerIndex: Int? = nil
    @Published var showExplanation = false
    @Published var sessionScore = 0
    @Published var sessionTotal = 0
    @Published var isSessionFinished = false
    @Published var progress: UserProgress
    @Published private(set) var sessionIndex = 0

    private var sessionQuestions: [QuizQuestion] = []
    private let questionsPerSession = 5

    var currentQuestionNumber: Int { sessionIndex + 1 }

    init() {
        self.progress = UserProgress.load()
        updateStreak()
    }

    func startSession(category: BibleCategory? = nil) {
        let pool = category == nil ? allQuestions : allQuestions.filter { $0.category == category }
        let unanswered = pool.filter { !progress.answeredQuestionIDs.contains($0.id) }
        let source = unanswered.isEmpty ? pool : unanswered
        sessionQuestions = Array(source.shuffled().prefix(questionsPerSession))
        sessionIndex = 0
        sessionScore = 0
        sessionTotal = 0
        isSessionFinished = false
        selectedAnswerIndex = nil
        showExplanation = false
        loadCurrentQuestion()
    }

    func selectAnswer(_ index: Int) {
        guard selectedAnswerIndex == nil, let question = currentQuestion else { return }
        selectedAnswerIndex = index
        let isCorrect = index == question.correctIndex
        progress.totalAnswered += 1
        sessionTotal += 1
        if isCorrect { progress.totalCorrect += 1; sessionScore += 1 }
        if !progress.answeredQuestionIDs.contains(question.id) {
            progress.answeredQuestionIDs.append(question.id)
        }
        showExplanation = !isCorrect
        progress.lastPlayedDate = Date()
        progress.save()
    }

    func next() {
        sessionIndex += 1
        selectedAnswerIndex = nil
        showExplanation = false
        if sessionIndex >= sessionQuestions.count {
            isSessionFinished = true
            currentQuestion = nil
        } else {
            loadCurrentQuestion()
        }
    }

    private func loadCurrentQuestion() {
        guard sessionIndex < sessionQuestions.count else { return }
        currentQuestion = sessionQuestions[sessionIndex]
    }

    private func updateStreak() {
        guard let last = progress.lastPlayedDate else { return }
        if Calendar.current.isDateInToday(last) { return }
        if !Calendar.current.isDateInYesterday(last) {
            progress.currentStreak = 0
            progress.save()
        }
    }
}
