import SwiftUI

struct QuizSessionView: View {
    let category: BibleCategory?
    @StateObject private var vm = QuizViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Group {
            if vm.isSessionFinished {
                SessionResultView(score: vm.sessionScore, total: vm.sessionTotal) {
                    vm.startSession(category: category)
                } onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                }
            } else if let question = vm.currentQuestion {
                QuestionView(vm: vm, question: question)
            } else {
                SwiftUI.ProgressView("Carregando...")
            }
        }
        .onAppear { vm.startSession(category: category) }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionView: View {
    @ObservedObject var vm: QuizViewModel
    let question: QuizQuestion

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(question.category.rawValue.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.indigo)
                    .cornerRadius(20)

                Text(question.question)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(0..<question.options.count, id: \.self) { index in
                        AnswerButton(
                            text: question.options[index],
                            state: answerState(for: index),
                            action: { vm.selectAnswer(index) }
                        )
                    }
                }
                .padding(.horizontal)

                if vm.showExplanation {
                    ExplanationCard(question: question)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if vm.selectedAnswerIndex != nil {
                    Button(action: vm.next) {
                        Text(vm.sessionIndex + 1 >= 5 ? "Ver Resultado" : "Próxima →")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("Pergunta \(vm.currentQuestionNumber) de 5")
        .animation(.easeInOut, value: vm.showExplanation)
    }

    private func answerState(for index: Int) -> AnswerButtonState {
        guard let selected = vm.selectedAnswerIndex else { return .normal }
        if index == question.correctIndex { return .correct }
        if index == selected { return .wrong }
        return .dimmed
    }
}

enum AnswerButtonState { case normal, correct, wrong, dimmed }

struct AnswerButton: View {
    let text: String
    let state: AnswerButtonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text).font(.body).multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 2))
        }
        .disabled(state != .normal)
        .animation(.easeInOut(duration: 0.2), value: state)
    }

    private var backgroundColor: Color {
        switch state {
        case .normal: return Color(.systemBackground)
        case .correct: return Color.green.opacity(0.15)
        case .wrong: return Color.red.opacity(0.15)
        case .dimmed: return Color(.systemGray6)
        }
    }
    private var foregroundColor: Color { state == .dimmed ? .secondary : .primary }
    private var borderColor: Color {
        switch state {
        case .normal: return Color(.systemGray4)
        case .correct: return .green
        case .wrong: return .red
        case .dimmed: return Color(.systemGray5)
        }
    }
}

struct ExplanationCard: View {
    let question: QuizQuestion

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Explicação Bíblica", systemImage: "info.circle.fill")
                .font(.headline).foregroundStyle(.indigo)
            Text(question.explanation).font(.body)
            HStack {
                Image(systemName: "book.closed.fill").foregroundStyle(.indigo)
                Text(question.reference).font(.caption.bold()).foregroundStyle(.indigo)
            }
        }
        .padding()
        .background(Color.indigo.opacity(0.08))
        .cornerRadius(14)
        .padding(.horizontal)
    }
}

struct SessionResultView: View {
    let score: Int
    let total: Int
    let onPlayAgain: () -> Void
    let onDismiss: () -> Void

    private var emoji: String {
        let pct = Double(score) / Double(max(total, 1))
        if pct == 1.0 { return "🏆" }
        if pct >= 0.8 { return "🎉" }
        if pct >= 0.6 { return "👍" }
        return "📖"
    }
    private var message: String {
        let pct = Double(score) / Double(max(total, 1))
        if pct == 1.0 { return "Perfeito! Parabéns!" }
        if pct >= 0.8 { return "Muito bem! Continue assim!" }
        if pct >= 0.6 { return "Bom resultado! Continue estudando!" }
        return "Continue praticando!\nA Palavra de Deus é rica!"
    }

    var body: some View {
        VStack(spacing: 28) {
            Text(emoji).font(.system(size: 70))
            Text("Sessão Concluída!").font(.largeTitle.bold())
            Text("\(score) de \(total) acertos").font(.title2).foregroundStyle(.secondary)
            Text(message).font(.body).multilineTextAlignment(.center).foregroundStyle(.secondary)

            VStack(spacing: 12) {
                Button(action: onPlayAgain) {
                    Label("Jogar Novamente", systemImage: "arrow.clockwise")
                        .font(.headline).frame(maxWidth: .infinity).padding()
                        .background(Color.indigo).foregroundColor(.white).cornerRadius(14)
                }
                Button(action: onDismiss) {
                    Text("Voltar ao Menu").font(.subheadline).foregroundStyle(.indigo)
                }
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}
