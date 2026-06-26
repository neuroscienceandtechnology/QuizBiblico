import SwiftUI

struct HomeView: View {
    @StateObject private var vm = QuizViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.indigo)
                        Text("Quiz Bíblico")
                            .font(.largeTitle.bold())
                        Text("Aprenda a Palavra de Deus\nde forma divertida")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)

                    DailyVerseCard()
                    StreakCard(progress: vm.progress)

                    NavigationLink(destination: QuizSessionView(category: nil)) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Iniciar Quiz Rápido")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
    }
}

struct DailyVerseCard: View {
    private let verses: [(String, String)] = [
        ("\"Porque Deus tanto amou o mundo que deu o seu Filho Unigênito.\"", "João 3:16"),
        ("\"O Senhor é o meu pastor; nada me faltará.\"", "Salmos 23:1"),
        ("\"Tudo posso naquele que me fortalece.\"", "Filipenses 4:13"),
        ("\"Buscai primeiro o reino de Deus e sua justiça.\"", "Mateus 6:33"),
        ("\"Confia no Senhor de todo o teu coração.\"", "Provérbios 3:5")
    ]

    private var todayVerse: (String, String) {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return verses[(day - 1) % verses.count]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Versículo do Dia", systemImage: "quote.bubble.fill")
                .font(.caption.bold())
                .foregroundStyle(.indigo)
            Text(todayVerse.0)
                .font(.body)
                .italic()
            Text(todayVerse.1)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.indigo.opacity(0.08))
        .cornerRadius(14)
        .padding(.horizontal)
    }
}

struct StreakCard: View {
    let progress: UserProgress

    var body: some View {
        HStack(spacing: 0) {
            statItem(value: "\(progress.currentStreak)", label: "Dias seguidos", icon: "flame.fill", color: .orange)
            Divider().frame(height: 40)
            statItem(value: "\(progress.totalCorrect)", label: "Acertos", icon: "checkmark.circle.fill", color: .green)
            Divider().frame(height: 40)
            statItem(value: String(format: "%.0f%%", progress.accuracy), label: "Precisão", icon: "target", color: .blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
    }

    private func statItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundStyle(color)
            Text(value).font(.title2.bold())
            Text(label).font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
