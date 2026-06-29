import SwiftUI
import Combine

class TrailViewModel: ObservableObject {
    @Published var nodes: [TrailNodeData]
    @Published var characterNodeIndex: Int = 0

    let trailID: TrailID

    static let nodePositions: [CGPoint] = [
        CGPoint(x: 195, y: 2978),
        CGPoint(x: 82,  y: 2742),
        CGPoint(x: 308, y: 2514),
        CGPoint(x: 82,  y: 2287),
        CGPoint(x: 308, y: 2060),
        CGPoint(x: 82,  y: 1834),
        CGPoint(x: 308, y: 1607),
        CGPoint(x: 82,  y: 1381),
        CGPoint(x: 308, y: 1154),
        CGPoint(x: 82,  y: 928),
        CGPoint(x: 308, y: 702),
        CGPoint(x: 195, y: 443),
    ]

    var characterPosition: CGPoint {
        TrailViewModel.nodePositions[min(characterNodeIndex, TrailViewModel.nodePositions.count - 1)]
    }

    var completedCount: Int {
        nodes.filter { $0.status == .completed }.count
    }

    private var progressKey: String {
        switch trailID {
        case .genesis:    return "trail_progress_v2"
        case .evangelhos: return "trail_progress_evangelhos_v1"
        }
    }

    static func savedCompletedCount(for trail: TrailID) -> Int {
        let key: String
        switch trail {
        case .genesis:    key = "trail_progress_v2"
        case .evangelhos: key = "trail_progress_evangelhos_v1"
        }
        return (UserDefaults.standard.array(forKey: key) as? [Int])?.count ?? 0
    }

    init(trail: TrailID = .genesis) {
        trailID = trail
        var base: [TrailNodeData]
        switch trail {
        case .genesis:    base = TrailData.nodes
        case .evangelhos: base = EvangelhoData.nodes
        }
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
        var base: [TrailNodeData]
        switch trailID {
        case .genesis:    base = TrailData.nodes
        case .evangelhos: base = EvangelhoData.nodes
        }
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
