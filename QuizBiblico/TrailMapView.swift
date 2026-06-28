import SwiftUI

// MARK: - Constants

private let mapW: CGFloat  = 390
private let mapH: CGFloat  = 2600
private let NR:   CGFloat  = 44   // node radius

// MARK: - Biomes

private struct Biome {
    let yStart: CGFloat
    let yEnd:   CGFloat
    let top:    Color
    let bottom: Color
    let label:  String
    let icon:   String
}

private let biomes: [Biome] = [
    Biome(yStart:    0, yEnd:  470, top: Color(hex: "2D7D32"), bottom: Color(hex: "388E3C"), label: "Terra Prometida",  icon: "🏹"),
    Biome(yStart:  470, yEnd:  780, top: Color(hex: "F5A623"), bottom: Color(hex: "E67E22"), label: "Sinai e Êxodo",    icon: "📜"),
    Biome(yStart:  780, yEnd: 1200, top: Color(hex: "C0792A"), bottom: Color(hex: "A0612A"), label: "O Egito",          icon: "🏛️"),
    Biome(yStart: 1200, yEnd: 1700, top: Color(hex: "8D6E63"), bottom: Color(hex: "6D4C41"), label: "Os Patriarcas",   icon: "⭐"),
    Biome(yStart: 1700, yEnd: 2160, top: Color(hex: "5C6BC0"), bottom: Color(hex: "3949AB"), label: "Noé e a Aliança", icon: "🌊"),
    Biome(yStart: 2160, yEnd: mapH, top: Color(hex: "1B5E20"), bottom: Color(hex: "2E7D32"), label: "A Criação",        icon: "🌍"),
]

// MARK: - Main View

struct TrailMapView: View {
    @StateObject private var vm = TrailViewModel()
    @State private var selectedNodeIndex: Int? = nil
    @State private var charBob: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        mapContent
                            .frame(width: mapW, height: mapH)
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) { charBob = -9 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation { proxy.scrollTo("char", anchor: .center) }
                        }
                    }
                }
                progressHeader
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label("Trilha do Conhecimento", systemImage: "map.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color(hex: "1B5E20"), for: .navigationBar)
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

    // MARK: Map layers

    private var mapContent: some View {
        ZStack(alignment: .topLeading) {
            biomeBackgrounds
            biomeBanners
            pathLayer
            decorLayer
            nodesLayer
            charLayer
        }
    }

    // MARK: Biome backgrounds

    private var biomeBackgrounds: some View {
        Canvas { ctx, _ in
            for b in biomes {
                let rect = CGRect(x: 0, y: b.yStart, width: mapW, height: b.yEnd - b.yStart)
                ctx.fill(
                    Path(rect),
                    with: .linearGradient(
                        Gradient(colors: [b.top, b.bottom]),
                        startPoint: CGPoint(x: mapW/2, y: b.yStart),
                        endPoint:   CGPoint(x: mapW/2, y: b.yEnd)
                    )
                )
            }
            // Side vignettes
            let left  = Path(CGRect(x: 0,        y: 0, width: 48, height: mapH))
            let right = Path(CGRect(x: mapW - 48, y: 0, width: 48, height: mapH))
            ctx.fill(left,  with: .color(.black.opacity(0.22)))
            ctx.fill(right, with: .color(.black.opacity(0.22)))
        }
        .frame(width: mapW, height: mapH)
        .allowsHitTesting(false)
    }

    // MARK: Biome banners

    private var biomeBanners: some View {
        ZStack(alignment: .topLeading) {
            ForEach(biomes.indices, id: \.self) { i in
                let b = biomes[i]
                let y = b.yStart + 22
                HStack(spacing: 5) {
                    Text(b.icon)
                        .font(.system(size: 14))
                    Text(b.label.uppercased())
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .kerning(1.2)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(.black.opacity(0.28))
                        .overlay(Capsule().stroke(.white.opacity(0.18), lineWidth: 1))
                )
                .position(x: mapW / 2, y: y)
            }
        }
    }

    // MARK: Path

    private var pathLayer: some View {
        Canvas { ctx, _ in
            let pts = TrailViewModel.nodePositions
            for i in 0..<pts.count - 1 {
                let a   = pts[i]
                let b   = pts[i + 1]
                let mid = CGPoint(x: (a.x + b.x) / 2, y: min(a.y, b.y) - 30)

                var seg = Path()
                seg.move(to: a)
                seg.addQuadCurve(to: b, control: mid)

                // Outer dark border
                ctx.stroke(seg, with: .color(.black.opacity(0.35)),
                           style: StrokeStyle(lineWidth: 20, lineCap: .round))

                // Road fill (biome-tinted white)
                ctx.stroke(seg, with: .color(.white.opacity(0.22)),
                           style: StrokeStyle(lineWidth: 16, lineCap: .round))

                // Center dashes
                let isUnlocked = i < vm.completedCount
                let dashColor: GraphicsContext.Shading = isUnlocked
                    ? .color(Color(hex: "FFD700").opacity(0.85))
                    : .color(.white.opacity(0.50))
                ctx.stroke(seg, with: dashColor,
                           style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [12, 10]))
            }
        }
        .frame(width: mapW, height: mapH)
        .allowsHitTesting(false)
    }

    // MARK: Decorations

    private var decorLayer: some View {
        ZStack(alignment: .topLeading) {
            // === Canaan ===
            Group {
                d("🌳", 48,  138); d("🌳", 342, 160); d("🌿", 194, 195)
                d("✨", 148, 176); d("✨", 248, 210)
            }
            // === Sinai ===
            Group {
                d("⛰️", 38, 480); d("⛰️", 350, 510)
                d("✨", 196, 455); d("🌙", 256, 540)
            }
            // === Mar Vermelho / Pragas ===
            Group {
                d("🌊", 44, 660); d("🌊", 170, 648); d("🌊", 296, 672)
                d("🐸", 194, 808); d("🦟", 50, 845); d("🦟", 340, 835)
            }
            // === Egito ===
            Group {
                d("▲", 42,  788, 40, Color(red: 0.62, green: 0.44, blue: 0.10))
                d("▲", 348, 820, 34, Color(red: 0.62, green: 0.44, blue: 0.10))
                d("🔥", 162, 965); d("🏜️", 340, 1005)
            }
            // === Patriarcas ===
            Group {
                d("🌾", 42, 1148); d("🌾", 364, 1170)
                d("🏕️", 175, 1310); d("🌙", 350, 1285)
                d("⭐", 44, 1490); d("🌵", 348, 1528)
            }
            // === Noé / Babel ===
            Group {
                d("🏛️", 196, 1682)
                d("🌈", 44, 1862); d("🕊️", 340, 1888)
            }
            // === Eden / Criação ===
            Group {
                d("🌺", 44, 2048); d("🌿", 360, 2070)
                d("🌳", 74, 2228); d("🌳", 316, 2248)
                d("🦁", 72, 2415); d("🐘", 316, 2430)
                d("🦋", 196, 2380)
            }
        }
    }

    @ViewBuilder
    private func d(_ s: String, _ x: CGFloat, _ y: CGFloat, _ sz: CGFloat = 26, _ c: Color = .primary) -> some View {
        Text(s)
            .font(.system(size: sz))
            .foregroundColor(c)
            .opacity(0.82)
            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
            .position(x: x, y: y)
    }

    // MARK: Nodes

    private var nodesLayer: some View {
        ForEach(vm.nodes.indices, id: \.self) { i in
            TrailNodeButton(node: vm.nodes[i], index: i) {
                if vm.nodes[i].status != .locked { selectedNodeIndex = i }
            }
            .position(TrailViewModel.nodePositions[i])
        }
    }

    // MARK: Character

    private var charLayer: some View {
        ZStack {
            // Shadow
            Ellipse()
                .fill(.black.opacity(0.28))
                .frame(width: 46, height: 10)
                .blur(radius: 4)
                .offset(y: NR + 8)

            // Bounce arrow indicator
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                .offset(y: -(NR + 18) + charBob)

            Text("🧑")
                .font(.system(size: 36))
                .shadow(color: .black.opacity(0.35), radius: 4, x: 1, y: 3)
                .offset(y: charBob)
        }
        .animation(.spring(response: 0.8, dampingFraction: 0.65), value: vm.characterNodeIndex)
        .position(vm.characterPosition)
        .id("char")
    }

    // MARK: Progress header

    private var progressHeader: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(i < vm.completedCount
                          ? Color(hex: "FFD700")
                          : Color.white.opacity(0.20))
                    .frame(height: 5)
                    .animation(.spring(), value: vm.completedCount)
                if i < 11 {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 1, height: 5)
                }
            }
        }
        .clipShape(Capsule())
        .frame(height: 5)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .trailing) {
            Text("\(vm.completedCount)/12")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.75))
                .padding(.trailing, 18)
        }
    }
}

// MARK: - Node Button

struct TrailNodeButton: View {
    let node:  TrailNodeData
    let index: Int
    let onTap: () -> Void

    @State private var ringScale: CGFloat = 1.0
    @State private var ringOpacity: CGFloat = 0.8

    private var nodeColor: Color {
        switch node.status {
        case .locked:    return Color(hex: "546E7A")
        case .available: return Color(hex: "1565C0")
        case .completed: return Color(hex: "E65100")
        }
    }

    private var nodeGrad: LinearGradient {
        switch node.status {
        case .locked:
            return LinearGradient(colors: [Color(hex: "78909C"), Color(hex: "455A64")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .available:
            return LinearGradient(colors: [Color(hex: "42A5F5"), Color(hex: "1565C0")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .completed:
            return LinearGradient(colors: [Color(hex: "FFCA28"), Color(hex: "F57F17")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Pulsing ring for available
                if node.status == .available {
                    Circle()
                        .stroke(Color(hex: "90CAF9").opacity(ringOpacity), lineWidth: 3)
                        .frame(width: NR * 2 + 14, height: NR * 2 + 14)
                        .scaleEffect(ringScale)
                }

                // Outer ring / rim
                Circle()
                    .fill(.white.opacity(0.18))
                    .frame(width: NR * 2 + 6, height: NR * 2 + 6)

                // Main circle
                Circle()
                    .fill(nodeGrad)
                    .frame(width: NR * 2, height: NR * 2)
                    .shadow(color: nodeColor.opacity(0.55), radius: 8, x: 0, y: 5)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)

                // Shine overlay (top-left highlight)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.28), .clear],
                            startPoint: UnitPoint(x: 0.2, y: 0.1),
                            endPoint:   UnitPoint(x: 0.8, y: 0.9)
                        )
                    )
                    .frame(width: NR * 2, height: NR * 2)

                // Content
                if node.status == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.70))
                } else {
                    Text(node.emoji)
                        .font(.system(size: 28))
                }

                // Completed badge
                if node.status == .completed {
                    ZStack {
                        Circle().fill(.white).frame(width: 22, height: 22)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "2E7D32"))
                    }
                    .offset(x: NR - 5, y: -(NR - 5))
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: NR * 2 + 20, height: NR * 2 + 20)
        .overlay(alignment: .bottom) {
            if node.status != .locked {
                Text(node.title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.65), radius: 3, x: 0, y: 1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 86)
                    .offset(y: NR + 22)
            }
        }
        .onAppear {
            guard node.status == .available else { return }
            withAnimation(.easeOut(duration: 1.3).repeatForever(autoreverses: false)) {
                ringScale   = 1.55
                ringOpacity = 0
            }
        }
    }
}

// MARK: - Color from hex

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >>  8) & 0xFF) / 255
        let b = Double( int        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
