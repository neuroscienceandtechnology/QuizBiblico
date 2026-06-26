import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Início", systemImage: "house.fill") }
            QuizMenuView()
                .tabItem { Label("Quiz", systemImage: "questionmark.circle.fill") }
            DailyChallengeView()
                .tabItem { Label("Desafio", systemImage: "star.fill") }
            StatsView()
                .tabItem { Label("Progresso", systemImage: "chart.bar.fill") }
        }
        .tint(.indigo)
    }
}
