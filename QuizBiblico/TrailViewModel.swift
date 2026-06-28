import SwiftUI
import Combine

class TrailViewModel: ObservableObject {
    @Published var nodes: [TrailNodeData]
    @Published var characterNodeIndex: Int = 0

    static let nodePositions: [CGPoint] = [
        CGPoint(x: 195, y: 2300),
        CGPoint(x: 82,  y: 2110),
        CGPoint(x: 308, y: 1930),
        CGPoint(x: 82,  y: 1750),
        CGPoint(x: 308, y: 1570),
        CGPoint(x: 82,  y: 1390),
        CGPoint(x: 308, y: 1210),
        CGPoint(x: 82,  y: 1030),
        CGPoint(x: 308, y: 850),
        CGPoint(x: 82,  y: 670),
        CGPoint(x: 308, y: 490),
        CGPoint(x: 195, y: 290),
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
        withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
            characterNodeIndex = index
        }
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
