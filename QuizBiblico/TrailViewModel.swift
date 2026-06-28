import SwiftUI
import Combine

class TrailViewModel: ObservableObject {
    @Published var nodes: [TrailNodeData]
    @Published var characterNodeIndex: Int = 0

    static let nodePositions: [CGPoint] = [
        CGPoint(x: 195, y: 2420),  // 1: Criação - centro baixo
        CGPoint(x: 82,  y: 2228),  // 2: Adão e Eva - esq
        CGPoint(x: 308, y: 2042),  // 3: Noé - dir
        CGPoint(x: 82,  y: 1858),  // 4: Babel - esq
        CGPoint(x: 308, y: 1674),  // 5: Abraão - dir
        CGPoint(x: 82,  y: 1490),  // 6: Isaque/Jacó - esq
        CGPoint(x: 308, y: 1306),  // 7: José - dir
        CGPoint(x: 82,  y: 1122),  // 8: Moisés - esq
        CGPoint(x: 308, y: 938),   // 9: Pragas - dir
        CGPoint(x: 82,  y: 754),   // 10: Mar Vermelho - esq
        CGPoint(x: 308, y: 570),   // 11: Mandamentos - dir
        CGPoint(x: 195, y: 360),   // 12: Josué - centro topo
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
