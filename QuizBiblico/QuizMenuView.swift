import SwiftUI

struct QuizMenuView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: QuizSessionView(category: nil)) {
                        categoryRow(icon: "shuffle", title: "Aleatório", subtitle: "Todas as categorias", color: .indigo)
                    }
                } header: { Text("Jogar") }

                Section {
                    ForEach(BibleCategory.allCases, id: \.self) { category in
                        NavigationLink(destination: QuizSessionView(category: category)) {
                            categoryRow(
                                icon: iconFor(category),
                                title: category.rawValue,
                                subtitle: "\(allQuestions.filter { $0.category == category }.count) perguntas",
                                color: colorFor(category)
                            )
                        }
                    }
                } header: { Text("Por Categoria") }
            }
            .navigationTitle("Quiz Bíblico")
        }
    }

    private func categoryRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.title2).foregroundStyle(color).frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func iconFor(_ category: BibleCategory) -> String {
        switch category {
        case .genesis: return "leaf.fill"
        case .jesus: return "cross.fill"
        case .salmos: return "music.note"
        case .atos: return "person.3.fill"
        case .profetas: return "megaphone.fill"
        case .geral: return "book.fill"
        }
    }

    private func colorFor(_ category: BibleCategory) -> Color {
        switch category {
        case .genesis: return .green
        case .jesus: return .orange
        case .salmos: return .purple
        case .atos: return .blue
        case .profetas: return .red
        case .geral: return .indigo
        }
    }
}
