import SwiftUI

struct StatsView: View {
    @State private var progress = UserProgress.load()

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 0) {
                        statCell(value: "\(progress.currentStreak)", label: "Sequência Atual", icon: "flame.fill", color: .orange)
                        statCell(value: "\(progress.bestStreak)", label: "Melhor Sequência", icon: "trophy.fill", color: .yellow)
                    }
                }

                Section {
                    statRow(icon: "questionmark.circle.fill", color: .indigo, label: "Perguntas Respondidas", value: "\(progress.totalAnswered)")
                    statRow(icon: "checkmark.circle.fill", color: .green, label: "Respostas Corretas", value: "\(progress.totalCorrect)")
                    statRow(icon: "xmark.circle.fill", color: .red, label: "Respostas Incorretas", value: "\(progress.totalAnswered - progress.totalCorrect)")
                    statRow(icon: "target", color: .blue, label: "Precisão Geral", value: String(format: "%.1f%%", progress.accuracy))
                } header: { Text("Estatísticas") }

                Section {
                    statRow(icon: "book.fill", color: .indigo, label: "Perguntas Respondidas", value: "\(progress.answeredQuestionIDs.count) de \(allQuestions.count)")
                    ProgressBarRow(answered: progress.answeredQuestionIDs.count, total: allQuestions.count)
                } header: { Text("Cobertura da Bíblia") }

                Section {
                    Button(role: .destructive) {
                        UserDefaults.standard.removeObject(forKey: "userProgress")
                        progress = UserProgress()
                    } label: {
                        Label("Reiniciar Progresso", systemImage: "arrow.counterclockwise")
                    }
                } header: { Text("Dados") }
            }
            .navigationTitle("Meu Progresso")
            .onAppear { progress = UserProgress.load() }
        }
    }

    private func statCell(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundStyle(color).font(.title2)
            Text(value).font(.title.bold())
            Text(label).font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func statRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(color).frame(width: 28)
            Text(label)
            Spacer()
            Text(value).foregroundStyle(.secondary).bold()
        }
    }
}

struct ProgressBarRow: View {
    let answered: Int
    let total: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray5)).frame(height: 12)
                RoundedRectangle(cornerRadius: 6).fill(Color.indigo)
                    .frame(width: geo.size.width * CGFloat(answered) / CGFloat(max(total, 1)), height: 12)
            }
        }
        .frame(height: 12)
    }
}
