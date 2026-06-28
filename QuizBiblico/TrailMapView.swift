import SwiftUI

private let mapWidth: CGFloat = 390
private let mapHeight: CGFloat = 2500
private let nodeRadius: CGFloat = 36

struct TrailMapView: View {
    @StateObject private var vm = TrailViewModel()
    @State private var selectedNodeIndex: Int? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack(alignment: .topLeading) {
                            mapBackground
                            decorations
                            trailPath
                            ForEach(vm.nodes.indices, id: \.self) { i in
                                TrailNodeCircle(node: vm.nodes[i]) {
                                    if vm.nodes[i].status != .locked {
                                        selectedNodeIndex = i
                                    }
                                }
                                .position(TrailViewModel.nodePositions[i])
                            }
                            characterView
                                .position(vm.characterPosition)
                                .animation(.spring(response: 0.8, dampingFraction: 0.65), value: vm.characterNodeIndex)
                                .id("character")
                            Color.clear.frame(width: 1, height: 1)
                                .position(x: 195, y: mapHeight - 20)
                                .id("bottom")
                        }
                        .frame(width: mapWidth, height: mapHeight)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo("character", anchor: .center)
                            }
                        }
                    }
                }
                progressHeader
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trilha do Conhecimento")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color(red: 0.13, green: 0.40, blue: 0.13), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: Binding(
                get: { selectedNodeIndex != nil },
                set: { if !$0 { selectedNodeIndex = nil } }
            )) {
                if let i = selectedNodeIndex {
                    TrailStudyView(node: vm.nodes[i], nodeIndex: i) {
                        vm.completeNode(index: i)
                    }
                }
            }
        }
    }

    private var progressHeader: some View {
        HStack(spacing: 4) {
            ForEach(0..<12) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(i < vm.completedCount ? Color.yellow : Color.white.opacity(0.35))
                    .frame(height: 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }

    private var characterView: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 52, height: 52)
                .blur(radius: 6)
            Text("🧑")
                .font(.system(size: 34))
        }
    }

    private var mapBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color(red: 0.22, green: 0.62, blue: 0.22), location: 0.00),
                .init(color: Color(red: 0.30, green: 0.70, blue: 0.28), location: 0.06),
                .init(color: Color(red: 0.92, green: 0.84, blue: 0.34), location: 0.16),
                .init(color: Color(red: 0.87, green: 0.62, blue: 0.22), location: 0.28),
                .init(color: Color(red: 0.80, green: 0.55, blue: 0.28), location: 0.42),
                .init(color: Color(red: 0.70, green: 0.50, blue: 0.32), location: 0.54),
                .init(color: Color(red: 0.80, green: 0.58, blue: 0.28), location: 0.66),
                .init(color: Color(red: 0.30, green: 0.64, blue: 0.26), location: 0.80),
                .init(color: Color(red: 0.14, green: 0.44, blue: 0.14), location: 1.00),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: mapWidth, height: mapHeight)
    }

    private var decorations: some View {
        ZStack(alignment: .topLeading) {
            Group {
                decoration("🌳", x: 60,  y: 120)
                decoration("🌿", x: 330, y: 150)
                decoration("🌳", x: 155, y: 200)
                decoration("⛰️", x: 40,  y: 390)
                decoration("⛰️", x: 340, y: 420)
                decoration("✨", x: 200, y: 360)
                decoration("🌊", x: 160, y: 580)
                decoration("🌊", x: 290, y: 620)
                decoration("🌊", x: 50,  y: 640)
                decoration("🐸", x: 200, y: 780)
            }
            Group {
                decoration("▲", x: 45,  y: 760, font: 44, color: Color(red: 0.6, green: 0.4, blue: 0.1))
                decoration("▲", x: 345, y: 810, font: 36, color: Color(red: 0.6, green: 0.4, blue: 0.1))
                decoration("🔥", x: 155, y: 950)
                decoration("🏜️", x: 330, y: 1000)
                decoration("🌾", x: 50,  y: 1130)
                decoration("🌾", x: 360, y: 1160)
                decoration("🏕️", x: 175, y: 1300)
                decoration("🌙", x: 345, y: 1270)
                decoration("⭐", x: 52,  y: 1490)
                decoration("🌵", x: 340, y: 1530)
            }
            Group {
                decoration("🏛️", x: 190, y: 1670)
                decoration("🌈", x: 48,  y: 1840)
                decoration("🕊️", x: 330, y: 1870)
                decoration("🌺", x: 50,  y: 2020)
                decoration("🌿", x: 355, y: 2060)
                decoration("🌳", x: 80,  y: 2210)
                decoration("🌳", x: 310, y: 2230)
                decoration("🦁", x: 195, y: 2380)
            }
        }
    }

    private func decoration(_ symbol: String, x: CGFloat, y: CGFloat, font: CGFloat = 26, color: Color = .primary) -> some View {
        Text(symbol)
            .font(.system(size: font))
            .foregroundColor(color)
            .opacity(0.75)
            .position(x: x, y: y)
    }

    private var trailPath: some View {
        Canvas { ctx, size in
            let positions = TrailViewModel.nodePositions
            var path = Path()
            for i in 0..<positions.count - 1 {
                let p0 = positions[i]
                let p1 = positions[i + 1]
                let mid = CGPoint(x: (p0.x + p1.x) / 2, y: (p0.y + p1.y) / 2)
                if i == 0 {
                    path.move(to: p0)
                }
                path.addQuadCurve(to: p1, control: CGPoint(x: mid.x, y: mid.y - 20))
            }
            ctx.stroke(
                path,
                with: .color(.white.opacity(0.55)),
                style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [10, 8])
            )
        }
        .frame(width: mapWidth, height: mapHeight)
    }
}

struct TrailNodeCircle: View {
    let node: TrailNodeData
    let onTap: () -> Void
    @State private var pulse = false

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: nodeRadius * 2, height: nodeRadius * 2)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: node.status == .available ? 3.5 : 2)
                            .scaleEffect(node.status == .available && pulse ? 1.25 : 1.0)
                            .opacity(node.status == .available && pulse ? 0.0 : 1.0)
                    )
                    .shadow(color: shadowColor.opacity(0.5), radius: 6, x: 0, y: 3)

                if node.status == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text(node.emoji)
                        .font(.system(size: 22))
                    if node.status == .completed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .background(Circle().fill(.white).padding(2))
                            .font(.system(size: 14))
                            .offset(x: 18, y: -18)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: nodeRadius * 2, height: nodeRadius * 2)
        .onAppear {
            if node.status == .available {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                    pulse = true
                }
            }
        }
        .overlay(
            Text(node.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 90)
                .offset(y: nodeRadius + 14)
        )
    }

    private var bgColor: Color {
        switch node.status {
        case .locked: return Color.gray.opacity(0.45)
        case .available: return Color(red: 0.22, green: 0.40, blue: 0.82)
        case .completed: return Color(red: 0.85, green: 0.68, blue: 0.10)
        }
    }

    private var borderColor: Color {
        switch node.status {
        case .locked: return .white.opacity(0.4)
        case .available: return .white
        case .completed: return Color.yellow
        }
    }

    private var shadowColor: Color {
        switch node.status {
        case .locked: return .black
        case .available: return .blue
        case .completed: return .yellow
        }
    }
}
