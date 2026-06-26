import SwiftUI

struct DailyChallengeView: View {
    @State private var isCompleted = false
    private let challenge = todayChallenge()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: isCompleted ? "star.circle.fill" : "star.circle")
                            .font(.system(size: 56))
                            .foregroundStyle(isCompleted ? .yellow : .indigo)
                            .animation(.spring(), value: isCompleted)

                        Text("Desafio de Hoje").font(.title.bold())
                        Text(formattedDate())
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 14) {
                        Label(challenge.title, systemImage: "flame.fill")
                            .font(.headline).foregroundStyle(.orange)
                        Text(challenge.description).font(.title3)
                        Divider()
                        Text(challenge.verse).font(.body).italic().foregroundStyle(.secondary)
                        Text(challenge.reference).font(.caption.bold()).foregroundStyle(.indigo)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Button(action: { withAnimation { isCompleted = true }; markComplete() }) {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            Text(isCompleted ? "Desafio Concluído!" : "Marcar como Concluído")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity).padding()
                        .background(isCompleted ? Color.green : Color.indigo)
                        .foregroundColor(.white).cornerRadius(14)
                    }
                    .disabled(isCompleted)
                    .padding(.horizontal)

                    if isCompleted {
                        Text("\"Bem-feito, servo bom e fiel!\" - Mateus 25:23")
                            .font(.caption).italic().foregroundStyle(.secondary)
                            .multilineTextAlignment(.center).padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
        .onAppear { checkIfCompleted() }
    }

    private func checkIfCompleted() {
        let progress = UserProgress.load()
        if let date = progress.dailyChallengeCompletedDate {
            isCompleted = Calendar.current.isDateInToday(date)
        }
    }

    private func markComplete() {
        var progress = UserProgress.load()
        progress.dailyChallengeCompletedDate = Date()
        progress.save()
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: Date()).capitalized
    }
}
