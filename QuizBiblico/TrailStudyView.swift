import SwiftUI

struct TrailStudyView: View {
    let node: TrailNodeData
    let nodeIndex: Int
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showQuiz = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    studySection
                    versesSection
                    startButton
                        .padding(.bottom, 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Estudo")
                        .font(.headline)
                }
            }
            .navigationDestination(isPresented: $showQuiz) {
                TrailQuizView(node: node) {
                    onComplete()
                    dismiss()
                }
            }
        }
    }

    private var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [headerColor.opacity(0.85), headerColor],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(spacing: 10) {
                Text(node.emoji)
                    .font(.system(size: 80))
                    .shadow(radius: 4)
                Text(node.title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text(node.subtitle)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.85))
                Text(node.reference)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.70))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.18))
                    .clipShape(Capsule())
            }
            .padding(.vertical, 36)
        }
    }

    private var studySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label("Contextualização", systemImage: "book.fill")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 10)
            Text(node.studyText)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(5)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }

    private var versesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Versículos-chave", systemImage: "text.quote")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 20)

            ForEach(node.keyVerses) { verse in
                verseCard(verse)
                    .padding(.horizontal, 20)
            }
        }
    }

    private func verseCard(_ verse: TrailVerse) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\"\(verse.text)\"")
                .font(.body.italic())
                .foregroundColor(.primary)
            Text(verse.reference)
                .font(.caption.bold())
                .foregroundColor(headerColor)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(headerColor.opacity(0.10))
        .overlay(
            Rectangle()
                .fill(headerColor)
                .frame(width: 4),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var startButton: some View {
        Button {
            showQuiz = true
        } label: {
            HStack {
                Text("Iniciar Quiz")
                    .font(.headline)
                Image(systemName: "arrow.right.circle.fill")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(headerColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
    }

    private var headerColor: Color {
        let colors: [Color] = [
            Color(red: 0.14, green: 0.44, blue: 0.14),
            Color(red: 0.60, green: 0.20, blue: 0.10),
            Color(red: 0.12, green: 0.36, blue: 0.62),
            Color(red: 0.44, green: 0.22, blue: 0.60),
            Color(red: 0.70, green: 0.50, blue: 0.10),
            Color(red: 0.20, green: 0.50, blue: 0.40),
            Color(red: 0.62, green: 0.20, blue: 0.35),
            Color(red: 0.18, green: 0.42, blue: 0.60),
            Color(red: 0.50, green: 0.25, blue: 0.10),
            Color(red: 0.12, green: 0.46, blue: 0.52),
            Color(red: 0.42, green: 0.18, blue: 0.58),
            Color(red: 0.14, green: 0.44, blue: 0.14),
        ]
        return colors[min(nodeIndex, colors.count - 1)]
    }
}
