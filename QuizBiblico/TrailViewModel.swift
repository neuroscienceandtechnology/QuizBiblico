import SwiftUI
import Combine

class TrailViewModel: ObservableObject {
    @Published var nodes: [TrailNodeData]
    @Published var characterNodeIndex: Int = 0

    static let nodePositions: [CGPoint] = [
        CGPoint(x: 195, y: 2978),  // 1: Criação
        CGPoint(x: 82,  y: 2742),  // 2: Adão e Eva
        CGPoint(x: 308, y: 2514),  // 3: Noé
        CGPoint(x: 82,  y: 2287),  // 4: Babel
        CGPoint(x: 308, y: 2060),  // 5: Abraão
        CGPoint(x: 82,  y: 1834),  // 6: Isaque/Jacó
        CGPoint(x: 308, y: 1607),  // 7: José
        CGPoint(x: 82,  y: 1381),  // 8: Moisés
        CGPoint(x: 308, y: 1154),  // 9: Pragas
        CGPoint(x: 82,  y: 928),   // 10: Mar Vermelho
        CGPoint(x: 308, y: 702),   // 11: Mandamentos
        CGPoint(x: 195, y: 443),   // 12: Josué
    ]

    var characterPosition: CGPoint {
        TrailViewModel.nodePositions[min(characterNodeIndex, TrailViewModel.nodePositions.count - 1)]
    }

    var completedCount: Int {
        nodes.filter { $0.status == .completed }.count
    }

    private let progressKey = "trail_progress_v2"

    init() {
        var base = TrailData.nodes
        base[0].status = .available
        nodes = base
        loadProgress()
    }

    func completeNode(index: Int) {
        guard index >= 0, index < nodes.count else { return }
        nodes[index].status = .completed
        characterNodeIndex = index
        if index + 1 < nodes.count {
            nodes[index + 1].status = .available
        }
        saveProgress()
    }

    func resetProgress() {
        var base = TrailData.nodes
        base[0].status = .available
        nodes = base
        characterNodeIndex = 0
        UserDefaults.standard.removeObject(forKey: progressKey)
    }

    private func saveProgress() {
        let completed = nodes.indices.filter { nodes[$0].status == .completed }
        UserDefaults.standard.set(completed, forKey: progressKey)
    }

    private func loadProgress() {
        guard let completed = UserDefaults.standard.array(forKey: progressKey) as? [Int], !completed.isEmpty else { return }
        for i in completed {
            guard i < nodes.count else { continue }
            nodes[i].status = .completed
            if i + 1 < nodes.count { nodes[i + 1].status = .available }
        }
        if let last = completed.max(), last < nodes.count {
            characterNodeIndex = last
        }
    }
}
