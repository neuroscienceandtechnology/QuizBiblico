import SwiftUI

struct TrailQuizView: View {
    let node: TrailNodeData
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var showFeedback = false
    @State private var score = 0
    @State private var finished = false
    @State private var wrongIndexes: [Int] = []

    private var questions: [TrailQuestion] { node.questions }
    private var currentQuestion: TrailQuestion { questions[currentIndex] }
    private var passingScore: Int { 3 }
    private var passed: Bool { score >= passingScore }

    var body: some View {
        Group {
            if finished {
                resultsView
            } else {
                questionView
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if !finished {
                    Button("Sair") { dismiss() }
                        .foregroundColor(.red)
                }
            }
        }
    }

    private var questionView: some View {
        ScrollView {
            VStack(spacing: 20) {
                progressBar
                    .padding(.top, 16)

                VStack(spacing: 6) {
                    Text("Pergunta \(currentIndex + 1) de \(questions.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text(currentQuestion.question)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    ForEach(currentQuestion.options.indices, id: \.self) { i in
                        optionButton(index: i)
                    }
                }
                .padding(.horizontal, 20)

                if showFeedback {
                    feedbackCard
                        .padding(.horizontal, 20)
                    Button {
                        nextQuestion()
                    } label: {
                        Text(currentIndex < questions.count - 1 ? "Próxima →" : "Ver Resultado")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private var progressBar: some View {
        HStack(spacing: 5) {
            ForEach(questions.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(progressColor(for: i))
                    .frame(height: 7)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
        .padding(.horizontal, 20)
    }

    private func progressColor(for index: Int) -> Color {
        if index < currentIndex { return .indigo }
        if index == currentIndex { return showFeedback
            ? (wrongIndexes.contains(currentIndex) ? .red : .green)
            : .indigo.opacity(0.4)
        }
        return Color(.systemGray5)
    }

    private func optionButton(index: Int) -> some View {
        let isSelected = selectedOption == index
        let isCorrect = index == currentQuestion.correctIndex
        var bg: Color = Color(.secondarySystemGroupedBackground)
        var border: Color = Color(.systemGray4)
        var textColor: Color = .primary

        if showFeedback {
            if isCorrect {
                bg = Color.green.opacity(0.15); border = .green; textColor = Color(red: 0, green: 0.5, blue: 0.2)
            } else if isSelected && !isCorrect {
                bg = Color.red.opacity(0.12); border = .red; textColor = .red
            }
        } else if isSelected {
            bg = Color.indigo.opacity(0.12); border = .indigo; textColor = .indigo
        }

        return Button {
            guard !showFeedback else { return }
            selectedOption = index
            withAnimation { showFeedback = true }
            if index != currentQuestion.correctIndex {
                wrongIndexes.append(currentIndex)
            } else {
                score += 1
            }
        } label: {
            HStack(spacing: 12) {
                Text(optionLabel(index))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(showFeedback && index == currentQuestion.correctIndex ? .green : textColor)
                    .frame(width: 26, height: 26)
                    .background(showFeedback && index == currentQuestion.correctIndex
                        ? Color.green.opacity(0.2) : border.opacity(0.2))
                    .clipShape(Circle())
                Text(currentQuestion.options[index])
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
                if showFeedback && index == currentQuestion.correctIndex {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                } else if showFeedback && isSelected && !isCorrect {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                }
            }
            .padding(14)
            .background(bg)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(border, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(showFeedback)
    }

    private func optionLabel(_ i: Int) -> String {
        ["A", "B", "C", "D"][i]
    }

    private var feedbackCard: some View {
        let correct = selectedOption == currentQuestion.correctIndex
        return HStack(alignment: .top, spacing: 10) {
            Image(systemName: correct ? "checkmark.seal.fill" : "info.circle.fill")
                .foregroundColor(correct ? .green : .orange)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(correct ? "Correto!" : "Quase lá!")
                    .font(.subheadline.bold())
                    .foregroundColor(correct ? .green : .orange)
                Text(currentQuestion.explanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(correct ? Color.green.opacity(0.08) : Color.orange.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(correct ? Color.green.opacity(0.3) : Color.orange.opacity(0.3), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            selectedOption = nil
            showFeedback = false
        } else {
            withAnimation { finished = true }
        }
    }

    private var resultsView: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 20) {
                Text(passed ? "🎉" : "😓")
                    .font(.system(size: 80))
                Text(passed ? "Parabéns!" : "Quase lá!")
                    .font(.largeTitle.bold())
                Text(passed ? "Você completou este ponto da trilha!" : "Tente novamente para avançar.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                scoreStars

                Text("\(score) de \(questions.count) corretas")
                    .font(.title2.bold())
                    .padding(.top, 4)

                if passed {
                    Text("Mínimo: \(passingScore)/\(questions.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(spacing: 12) {
                if passed {
                    Button {
                        onComplete()
                    } label: {
                        Label("Continuar Trilha", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                } else {
                    Button {
                        currentIndex = 0
                        selectedOption = nil
                        showFeedback = false
                        score = 0
                        wrongIndexes = []
                        withAnimation { finished = false }
                    } label: {
                        Label("Tentar Novamente", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Voltar ao Estudo")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    private var scoreStars: some View {
        HStack(spacing: 8) {
            ForEach(0..<5) { i in
                Image(systemName: i < score ? "star.fill" : "star")
                    .foregroundColor(i < score ? .yellow : Color(.systemGray4))
                    .font(.title)
            }
        }
    }
}
