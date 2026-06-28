import SwiftUI

private let mapWidth: CGFloat = 390
private let mapHeight: CGFloat = 2600
private let nodeR: CGFloat = 36
private let pillarH: CGFloat = 12

// MARK: - Main Map View

struct TrailMapView: View {
    @StateObject private var vm = TrailViewModel()
    @State private var selectedNodeIndex: Int? = nil
    @State private var charBob: CGFloat = 0
    @State private var charShadowScale: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack(alignment: .topLeading) {
                            biomeBackground
                            terrainLayer
                            roadPath
                            decoLayer
                            nodesLayer
                            characterLayer
                            Color.clear.frame(width: 1, height: 1)
                                .position(x: 195, y: mapHeight - 10)
                                .id("bottom")
                        }
                        .frame(width: mapWidth, height: mapHeight)
                    }
                    .onAppear {
                        startCharacterAnim()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation { proxy.scrollTo("character", anchor: .center) }
                        }
                    }
                }
                topProgressBar
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "map.fill")
                            .foregroundColor(.yellow)
                        Text("Trilha do Conhecimento")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color(red: 0.09, green: 0.26, blue: 0.09), for: .navigationBar)
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

    private func startCharacterAnim() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            charBob = -10
        }
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            charShadowScale = 0.75
        }
    }

    // MARK: - Progress Bar

    private var topProgressBar: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                ForEach(0..<12) { i in
                    Capsule()
                        .fill(i < vm.completedCount
                              ? LinearGradient(colors: [.yellow, Color(red: 1, green: 0.75, blue: 0)], startPoint: .leading, endPoint: .trailing)
                              : LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.15)], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 7)
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                        .animation(.spring(), value: vm.completedCount)
                }
            }
            .padding(.horizontal, 16)
            Text("\(vm.completedCount)/12 etapas concluídas")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: - Background Gradient

    private var biomeBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color(red: 0.15, green: 0.55, blue: 0.15), location: 0.00),
                .init(color: Color(red: 0.22, green: 0.65, blue: 0.20), location: 0.07),
                .init(color: Color(red: 0.88, green: 0.80, blue: 0.32), location: 0.18),
                .init(color: Color(red: 0.82, green: 0.58, blue: 0.20), location: 0.30),
                .init(color: Color(red: 0.75, green: 0.50, blue: 0.25), location: 0.44),
                .init(color: Color(red: 0.68, green: 0.45, blue: 0.28), location: 0.55),
                .init(color: Color(red: 0.78, green: 0.56, blue: 0.26), location: 0.65),
                .init(color: Color(red: 0.32, green: 0.65, blue: 0.28), location: 0.80),
                .init(color: Color(red: 0.12, green: 0.42, blue: 0.12), location: 1.00),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: mapWidth, height: mapHeight)
    }

    // MARK: - Terrain (Canvas drawn hills and water)

    private var terrainLayer: some View {
        Canvas { ctx, _ in
            drawTerrain(ctx: ctx)
        }
        .frame(width: mapWidth, height: mapHeight)
        .allowsHitTesting(false)
    }

    private func drawTerrain(ctx: GraphicsContext) {
        // Canaan hills (top)
        drawHill(ctx, cx: 195, cy: 220, rx: 180, ry: 90, color: Color(red: 0.18, green: 0.62, blue: 0.18).opacity(0.45))
        drawHill(ctx, cx: 60,  cy: 280, rx: 90,  ry: 50, color: Color(red: 0.22, green: 0.68, blue: 0.22).opacity(0.35))
        drawHill(ctx, cx: 340, cy: 310, rx: 80,  ry: 45, color: Color(red: 0.22, green: 0.68, blue: 0.22).opacity(0.30))

        // Sinai cliffs (desert top)
        drawHill(ctx, cx: 50,  cy: 530, rx: 100, ry: 55, color: Color(red: 0.90, green: 0.82, blue: 0.30).opacity(0.40))
        drawHill(ctx, cx: 340, cy: 560, rx: 95,  ry: 50, color: Color(red: 0.90, green: 0.82, blue: 0.30).opacity(0.30))
        drawHill(ctx, cx: 200, cy: 600, rx: 70,  ry: 38, color: Color(red: 0.78, green: 0.66, blue: 0.25).opacity(0.25))

        // Egypt dunes / pyramids hint
        drawHill(ctx, cx: 50,  cy: 850, rx: 90,  ry: 55, color: Color(red: 0.78, green: 0.58, blue: 0.22).opacity(0.40))
        drawHill(ctx, cx: 345, cy: 880, rx: 85,  ry: 52, color: Color(red: 0.78, green: 0.58, blue: 0.22).opacity(0.35))

        // Desert sand dunes
        drawHill(ctx, cx: 80,  cy: 1100, rx: 120, ry: 60, color: Color(red: 0.70, green: 0.52, blue: 0.28).opacity(0.30))
        drawHill(ctx, cx: 310, cy: 1130, rx: 110, ry: 55, color: Color(red: 0.70, green: 0.52, blue: 0.28).opacity(0.28))

        // Patriarchs semi-arid terrain
        drawHill(ctx, cx: 100, cy: 1380, rx: 100, ry: 50, color: Color(red: 0.60, green: 0.48, blue: 0.30).opacity(0.28))
        drawHill(ctx, cx: 310, cy: 1420, rx: 100, ry: 48, color: Color(red: 0.60, green: 0.48, blue: 0.30).opacity(0.25))

        // Noah / Flood water shimmer
        drawWaterStreak(ctx, y: 1750)

        // Eden hills (bottom)
        drawHill(ctx, cx: 80,  cy: 2100, rx: 130, ry: 65, color: Color(red: 0.20, green: 0.58, blue: 0.18).opacity(0.35))
        drawHill(ctx, cx: 315, cy: 2130, rx: 120, ry: 60, color: Color(red: 0.20, green: 0.58, blue: 0.18).opacity(0.30))
        drawHill(ctx, cx: 195, cy: 2350, rx: 160, ry: 80, color: Color(red: 0.15, green: 0.50, blue: 0.15).opacity(0.40))

        // Vignette edges (darker sides)
        var leftShadow = Path()
        leftShadow.addRect(CGRect(x: 0, y: 0, width: 50, height: mapHeight))
        ctx.fill(leftShadow, with: .color(Color.black.opacity(0.18)))

        var rightShadow = Path()
        rightShadow.addRect(CGRect(x: mapWidth - 50, y: 0, width: 50, height: mapHeight))
        ctx.fill(rightShadow, with: .color(Color.black.opacity(0.18)))
    }

    private func drawHill(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, rx: CGFloat, ry: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: cx - rx, y: cy))
        path.addCurve(
            to: CGPoint(x: cx + rx, y: cy),
            control1: CGPoint(x: cx - rx * 0.5, y: cy - ry * 1.6),
            control2: CGPoint(x: cx + rx * 0.5, y: cy - ry * 1.6)
        )
        path.closeSubpath()
        ctx.fill(path, with: .color(color))

        // Hill lighting: bright top edge
        var rimPath = Path()
        rimPath.move(to: CGPoint(x: cx - rx, y: cy))
        rimPath.addCurve(
            to: CGPoint(x: cx + rx, y: cy),
            control1: CGPoint(x: cx - rx * 0.5, y: cy - ry * 1.6),
            control2: CGPoint(x: cx + rx * 0.5, y: cy - ry * 1.6)
        )
        ctx.stroke(rimPath, with: .color(Color.white.opacity(0.12)), lineWidth: 2)
    }

    private func drawWaterStreak(_ ctx: GraphicsContext, y: CGFloat) {
        for i in 0..<6 {
            let offsetY = y + CGFloat(i) * 22
            var p = Path()
            p.move(to: CGPoint(x: 0, y: offsetY))
            p.addCurve(
                to: CGPoint(x: mapWidth, y: offsetY + 8),
                control1: CGPoint(x: 100, y: offsetY - 12),
                control2: CGPoint(x: 290, y: offsetY + 18)
            )
            let alpha = 0.12 - Double(i) * 0.015
            ctx.stroke(p, with: .color(Color(red: 0.3, green: 0.65, blue: 0.9).opacity(alpha)), lineWidth: 3)
        }
    }

    // MARK: - 3D Road Path

    private var roadPath: some View {
        Canvas { ctx, _ in
            let positions = TrailViewModel.nodePositions
            for i in 0..<positions.count - 1 {
                let p0 = positions[i]
                let p1 = positions[i + 1]
                let ctrl = CGPoint(x: (p0.x + p1.x) / 2, y: min(p0.y, p1.y) - 28)

                var seg = Path()
                seg.move(to: p0)
                seg.addQuadCurve(to: p1, control: ctrl)

                // Road shadow (bottom layer, offset)
                var shadow = seg
                ctx.translateBy(x: 3, y: 5)
                ctx.stroke(shadow, with: .color(Color.black.opacity(0.28)), style: StrokeStyle(lineWidth: 26, lineCap: .round))
                ctx.translateBy(x: -3, y: -5)

                // Road base (stone/earth color per biome)
                ctx.stroke(seg, with: .color(roadBaseColor(index: i)), style: StrokeStyle(lineWidth: 22, lineCap: .round))

                // Road surface (lighter, center)
                ctx.stroke(seg, with: .color(roadSurfaceColor(index: i)), style: StrokeStyle(lineWidth: 15, lineCap: .round))

                // Road edge highlights
                ctx.stroke(seg, with: .color(Color.white.opacity(0.12)), style: StrokeStyle(lineWidth: 22, lineCap: .round, dash: [1, 0]))

                // Center dashes (white)
                ctx.stroke(seg, with: .color(Color.white.opacity(0.45)), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [10, 14]))
            }
        }
        .frame(width: mapWidth, height: mapHeight)
        .allowsHitTesting(false)
    }

    private func roadBaseColor(index: Int) -> Color {
        switch index {
        case 0...1: return Color(red: 0.28, green: 0.50, blue: 0.18)  // Eden green
        case 2...3: return Color(red: 0.52, green: 0.38, blue: 0.18)  // Patriarchs brown
        case 4...5: return Color(red: 0.62, green: 0.44, blue: 0.18)  // Nomads tan
        case 6...7: return Color(red: 0.55, green: 0.38, blue: 0.15)  // Egypt brown
        case 8...9: return Color(red: 0.68, green: 0.52, blue: 0.16)  // Desert gold
        default:    return Color(red: 0.22, green: 0.48, blue: 0.18)  // Canaan green
        }
    }

    private func roadSurfaceColor(index: Int) -> Color {
        switch index {
        case 0...1: return Color(red: 0.38, green: 0.60, blue: 0.25)
        case 2...3: return Color(red: 0.65, green: 0.50, blue: 0.28)
        case 4...5: return Color(red: 0.75, green: 0.58, blue: 0.28)
        case 6...7: return Color(red: 0.68, green: 0.50, blue: 0.22)
        case 8...9: return Color(red: 0.82, green: 0.66, blue: 0.24)
        default:    return Color(red: 0.30, green: 0.58, blue: 0.24)
        }
    }

    // MARK: - Decorations

    private var decoLayer: some View {
        ZStack(alignment: .topLeading) {
            Group {
                // Canaan
                deco("🌳", x: 52,  y: 130, size: 30)
                deco("🌿", x: 338, y: 155, size: 26)
                deco("🌳", x: 160, y: 205, size: 28)
                deco("✨", x: 202, y: 178, size: 18)
                // Sinai
                deco("⛰️", x: 38,  y: 400, size: 34)
                deco("⛰️", x: 345, y: 430, size: 30)
                deco("✨", x: 198, y: 376, size: 20)
                deco("🌙", x: 248, y: 440, size: 18)
                deco("🌊", x: 155, y: 600, size: 26)
                deco("🌊", x: 288, y: 635, size: 24)
            }
            Group {
                deco("🌊", x: 45,  y: 660, size: 22)
                deco("🐸", x: 198, y: 800, size: 26)
                deco("▲",  x: 40,  y: 775, size: 38, color: Color(red: 0.58, green: 0.38, blue: 0.08))
                deco("▲",  x: 350, y: 815, size: 30, color: Color(red: 0.58, green: 0.38, blue: 0.08))
                deco("🔥", x: 158, y: 970, size: 26)
                deco("🏜️", x: 335, y: 1015, size: 24)
                deco("🌾", x: 44,  y: 1148, size: 26)
                deco("🌾", x: 362, y: 1175, size: 24)
                deco("🏕️", x: 178, y: 1318, size: 26)
                deco("🌙", x: 348, y: 1290, size: 20)
            }
            Group {
                deco("⭐", x: 48,  y: 1510, size: 24)
                deco("🌵", x: 345, y: 1550, size: 26)
                deco("🏛️", x: 192, y: 1690, size: 30)
                deco("🌈", x: 44,  y: 1862, size: 28)
                deco("🕊️", x: 336, y: 1890, size: 24)
                deco("🌺", x: 46,  y: 2048, size: 26)
                deco("🌿", x: 358, y: 2082, size: 24)
                deco("🌳", x: 76,  y: 2232, size: 30)
                deco("🌳", x: 314, y: 2252, size: 28)
                deco("🦁", x: 195, y: 2420, size: 30)
            }
        }
    }

    @ViewBuilder
    private func deco(_ s: String, x: CGFloat, y: CGFloat, size: CGFloat, color: Color = .primary) -> some View {
        Text(s)
            .font(.system(size: size))
            .foregroundColor(color)
            .opacity(0.80)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 2)
            .position(x: x, y: y)
    }

    // MARK: - Nodes

    private var nodesLayer: some View {
        ForEach(vm.nodes.indices, id: \.self) { i in
            TrailNode3D(node: vm.nodes[i]) {
                if vm.nodes[i].status != .locked { selectedNodeIndex = i }
            }
            .position(TrailViewModel.nodePositions[i])
        }
    }

    // MARK: - Character

    private var characterLayer: some View {
        ZStack {
            // Ground shadow (breathes in sync with bob)
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.black.opacity(0.38), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 22
                    )
                )
                .frame(width: 52, height: 14)
                .scaleEffect(x: charShadowScale, y: 1)
                .blur(radius: 3)
                .offset(y: nodeR + pillarH + 16)

            // Glow halo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.yellow.opacity(0.35), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 38
                    )
                )
                .frame(width: 76, height: 76)
                .blur(radius: 6)

            // Character
            ZStack {
                Text("🧑")
                    .font(.system(size: 38))
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 4)
            }
            .offset(y: charBob)
        }
        .animation(.spring(response: 0.8, dampingFraction: 0.65), value: vm.characterNodeIndex)
        .id("character")
    }
}

// MARK: - 3D Node View

struct TrailNode3D: View {
    let node: TrailNodeData
    let onTap: () -> Void

    @State private var pulseRing: CGFloat = 0

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
                // Drop shadow
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color.black.opacity(0.35), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: nodeR * 1.1
                        )
                    )
                    .frame(width: nodeR * 2.4, height: nodeR * 0.55)
                    .blur(radius: 5)
                    .offset(x: 4, y: nodeR + pillarH + 10)

                // Pillar / side face
                RoundedRectangle(cornerRadius: nodeR * 0.35)
                    .fill(
                        LinearGradient(
                            colors: [pillarTop, pillarBottom],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: nodeR * 2 - 4, height: pillarH + nodeR * 0.5)
                    .offset(y: nodeR * 0.5 + pillarH * 0.45)

                // Pulse ring (available only)
                if node.status == .available {
                    Circle()
                        .stroke(faceBaseColor.opacity(0.6 - pulseRing * 0.6), lineWidth: 3)
                        .frame(
                            width:  nodeR * 2 + pulseRing * 28,
                            height: nodeR * 2 + pulseRing * 28
                        )
                }

                // Main face circle
                Circle()
                    .fill(faceGradient)
                    .frame(width: nodeR * 2, height: nodeR * 2)
                    .overlay(
                        Circle()
                            .stroke(rimGradient, lineWidth: 3.5)
                    )
                    .overlay(
                        // Inner highlight (specular)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.white.opacity(0.38), Color.clear],
                                    center: UnitPoint(x: 0.32, y: 0.22),
                                    startRadius: 0,
                                    endRadius: nodeR * 0.85
                                )
                            )
                    )
                    .shadow(color: glowColor.opacity(0.55), radius: 10, x: 0, y: 5)

                // Inner concentric ring
                Circle()
                    .stroke(Color.white.opacity(0.18), lineWidth: 1.5)
                    .frame(width: nodeR * 2 - 10, height: nodeR * 2 - 10)

                // Content
                if node.status == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white.opacity(0.75))
                } else {
                    Text(node.emoji)
                        .font(.system(size: 24))
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)

                    if node.status == .completed {
                        ZStack {
                            Circle().fill(.white).frame(width: 20, height: 20)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(red: 0.12, green: 0.70, blue: 0.22))
                                .font(.system(size: 20))
                        }
                        .offset(x: nodeR - 4, y: -(nodeR - 4))
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: nodeR * 2.8, height: nodeR * 2 + pillarH + 28)
        .overlay(nodeLabel, alignment: .bottom)
        .onAppear {
            if node.status == .available {
                withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
                    pulseRing = 1
                }
            }
        }
    }

    private var nodeLabel: some View {
        Group {
            if node.status != .locked {
                Text(node.title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 90)
                    .offset(y: nodeR + pillarH + 32)
            }
        }
    }

    // MARK: Colors

    private var faceBaseColor: Color {
        switch node.status {
        case .locked:    return Color(red: 0.45, green: 0.45, blue: 0.50)
        case .available: return Color(red: 0.22, green: 0.42, blue: 0.88)
        case .completed: return Color(red: 0.88, green: 0.70, blue: 0.08)
        }
    }

    private var faceGradient: LinearGradient {
        switch node.status {
        case .locked:
            return LinearGradient(
                colors: [Color(red: 0.58, green: 0.58, blue: 0.62), Color(red: 0.34, green: 0.34, blue: 0.38)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .available:
            return LinearGradient(
                colors: [Color(red: 0.42, green: 0.68, blue: 1.0), Color(red: 0.18, green: 0.32, blue: 0.82)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .completed:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.92, blue: 0.42), Color(red: 0.85, green: 0.60, blue: 0.05)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var rimGradient: LinearGradient {
        switch node.status {
        case .locked:
            return LinearGradient(colors: [Color(red: 0.7, green: 0.7, blue: 0.75), Color(red: 0.28, green: 0.28, blue: 0.32)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .available:
            return LinearGradient(colors: [Color.cyan.opacity(0.9), Color(red: 0.1, green: 0.2, blue: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .completed:
            return LinearGradient(colors: [Color.white.opacity(0.9), Color(red: 0.82, green: 0.55, blue: 0.02)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var pillarTop: Color {
        switch node.status {
        case .locked:    return Color(red: 0.36, green: 0.36, blue: 0.40)
        case .available: return Color(red: 0.14, green: 0.28, blue: 0.70)
        case .completed: return Color(red: 0.72, green: 0.48, blue: 0.04)
        }
    }

    private var pillarBottom: Color {
        switch node.status {
        case .locked:    return Color(red: 0.22, green: 0.22, blue: 0.26)
        case .available: return Color(red: 0.08, green: 0.16, blue: 0.44)
        case .completed: return Color(red: 0.48, green: 0.30, blue: 0.02)
        }
    }

    private var glowColor: Color {
        switch node.status {
        case .locked:    return .black
        case .available: return .blue
        case .completed: return Color(red: 1.0, green: 0.82, blue: 0.0)
        }
    }
}
