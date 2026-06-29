import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Início", systemImage: "house.fill") }
            TrailSelectionView()
                .tabItem { Label("Trilha", systemImage: "map.fill") }
            QuizMenuView()
                .tabItem { Label("Quiz", systemImage: "questionmark.circle.fill") }
            BibleView()
                .tabItem { Label("Bíblia", systemImage: "book.fill") }
            AudioBibleView()
                .tabItem { Label("Áudio", systemImage: "headphones") }
            DailyChallengeView()
                .tabItem { Label("Desafio", systemImage: "star.fill") }
            StatsView()
                .tabItem { Label("Progresso", systemImage: "chart.bar.fill") }
        }
        .tint(.indigo)
    }
}
