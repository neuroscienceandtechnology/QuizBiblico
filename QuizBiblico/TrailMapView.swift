import SwiftUI

// MARK: - Layout constants

private let mapW: CGFloat = 390
private let mapH: CGFloat = 2600
private let NR:   CGFloat = 46

// MARK: - Biome boundaries (y from top)

private let bCanaan:     CGFloat = 0
private let bSinai:      CGFloat = 450
private let bEgypt:      CGFloat = 760
private let bPatriarchs: CGFloat = 1190
private let bFlood:      CGFloat = 1680
private let bEden:       CGFloat = 2145

// MARK: - Biome colours (hex-based)

private let cCanaan   = Color(rgb: 0x1E8B1E)
private let cSinaiTop = Color(rgb: 0xD9A81A)
private let cSinaiBot = Color(rgb: 0xB88014)
private let cEgyptTop = Color(rgb: 0xC75A10)
private let cEgyptBot = Color(rgb: 0x99420A)
private let cPatTop   = Color(rgb: 0x8C6030)
private let cPatBot   = Color(rgb: 0x6B4220)
private let cFloodTop = Color(rgb: 0x10348C)
private let cFloodBot = Color(rgb: 0x071F66)
private let cEdenTop  = Color(rgb: 0x0D6B0D)
private let cEdenBot  = Color(rgb: 0x074207)

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
                        mapStack.frame(width: mapW, height: mapH)
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) {
                            charBob = -10
                        }
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
                        .font(.headline).foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { vm.resetProgress() } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .toolbarBackground(Color(rgb: 0x0A4D0A), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: Binding(get: { selectedNodeIndex != nil },
                                        set: { if !$0 { selectedNodeIndex = nil } })) {
                if let i = selectedNodeIndex {
                    TrailStudyView(node: vm.nodes[i], nodeIndex: i) { vm.completeNode(index: i) }
                }
            }
        }
    }

    // MARK: Map layers

    private var mapStack: some View {
        ZStack(alignment: .topLeading) {
            staticBg
            TimelineView(.animation) { tl in
                animatedLayer(t: tl.date.timeIntervalSinceReferenceDate)
            }
            pathLayer
            staticDeco
            biomeBanners
            nodesLayer
            charLayer
        }
    }

    // MARK: Progress header

    private var progressHeader: some View {
        HStack(spacing: 3) {
            ForEach(0..<12, id: \.self) { i in
                Capsule()
                    .fill(i < vm.completedCount ? Color(rgb: 0xFFD700) : Color.white.opacity(0.20))
                    .frame(height: 6)
                    .animation(.spring(), value: vm.completedCount)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: Static background

    private var staticBg: some View {
        Canvas { ctx, _ in drawStaticBg(&ctx) }
            .frame(width: mapW, height: mapH)
            .allowsHitTesting(false)
    }

    private func drawStaticBg(_ ctx: inout GraphicsContext) {
        gradRect(&ctx, y: bEden,       h: mapH - bEden,         top: cEdenTop,  bot: cEdenBot)
        gradRect(&ctx, y: bFlood,      h: bEden - bFlood,       top: cFloodTop, bot: cFloodBot)
        gradRect(&ctx, y: bPatriarchs, h: bFlood - bPatriarchs, top: cPatTop,   bot: cPatBot)
        gradRect(&ctx, y: bEgypt,      h: bPatriarchs - bEgypt, top: cEgyptTop, bot: cEgyptBot)
        gradRect(&ctx, y: bSinai,      h: bEgypt - bSinai,      top: cSinaiTop, bot: cSinaiBot)
        gradRect(&ctx, y: bCanaan,     h: bSinai - bCanaan,     top: cCanaan,   bot: cCanaan)
        ctx.fill(Path(CGRect(x: 0,       y: 0, width: 50,  height: mapH)), with: .color(.black.opacity(0.22)))
        ctx.fill(Path(CGRect(x: mapW-50, y: 0, width: 50,  height: mapH)), with: .color(.black.opacity(0.22)))
    }

    private func gradRect(_ ctx: inout GraphicsContext, y: CGFloat, h: CGFloat, top: Color, bot: Color) {
        let rect = CGRect(x: 0, y: y, width: mapW, height: h)
        let grad = Gradient(colors: [top, bot])
        ctx.fill(Path(rect), with: .linearGradient(grad,
                                                    startPoint: CGPoint(x: mapW / 2, y: y),
                                                    endPoint:   CGPoint(x: mapW / 2, y: y + h)))
    }

    // MARK: Animated layer

    private func animatedLayer(t: Double) -> some View {
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in drawWaves(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawCanaan(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawSinai(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawEgypt(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawPatriarchs(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawFlood(&ctx, t: t) }.frame(width: mapW, height: mapH)
            Canvas { ctx, _ in drawEden(&ctx, t: t) }.frame(width: mapW, height: mapH)
        }
        .frame(width: mapW, height: mapH)
        .allowsHitTesting(false)
    }

    // --- Wavy biome transitions ---

    private func drawWaves(_ ctx: inout GraphicsContext, t: Double) {
        waveBand(&ctx, y: bSinai,      topC: cSinaiTop, amp: 20, period: 0.030, t: t, speed: 0.50)
        waveBand(&ctx, y: bEgypt,      topC: cEgyptTop, amp: 22, period: 0.026, t: t, speed: 0.40)
        waveBand(&ctx, y: bPatriarchs, topC: cPatTop,   amp: 24, period: 0.024, t: t, speed: 0.38)
        waveBand(&ctx, y: bFlood,      topC: cFloodTop, amp: 26, period: 0.028, t: t, speed: 0.42)
        waveBand(&ctx, y: bEden,       topC: cEdenTop,  amp: 22, period: 0.032, t: t, speed: 0.45)
    }

    private func waveBand(_ ctx: inout GraphicsContext, y: CGFloat, topC: Color,
                          amp: Double, period: Double, t: Double, speed: Double) {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: y))
        var x: Double = 0
        while x <= Double(mapW) + 4 {
            let wy: Double = Double(y)
                + sin(x * period       + t * speed)       * amp
                + cos(x * period * 1.7 + t * speed * 0.6) * amp * 0.4
            path.addLine(to: CGPoint(x: x, y: wy))
            x += 3
        }
        path.addLine(to: CGPoint(x: mapW, y: y - 62))
        path.addLine(to: CGPoint(x: 0,    y: y - 62))
        path.closeSubpath()
        ctx.fill(path, with: .color(topC.opacity(0.72)))
    }

    // --- Canaan: floating leaves + birds ---

    private func drawCanaan(_ ctx: inout GraphicsContext, t: Double) {
        let leafBase = Color(rgb: 0x44C038)
        for i in 0..<14 {
            let s:  Double = Double(i) * 41.7
            let lx: Double = (sin(s * 0.7) * 0.5 + 0.5) * Double(mapW)
            let ly: Double = (cos(s * 0.4) * 0.5 + 0.5) * Double(bSinai - 60) + 30
            let fy: Double = ly + sin(t * 0.6 + s) * 12
            let a:  Double = 0.55 + sin(t * 0.8 + s) * 0.25
            let sz: Double = 5.0 + sin(s * 3.1) * 2.0 + 2.0
            let r   = CGRect(x: lx - sz/2, y: fy - sz/2, width: sz, height: sz * 0.6)
            ctx.fill(Path(ellipseIn: r), with: .color(leafBase.opacity(a)))
        }
        for i in 0..<5 {
            let s:   Double = Double(i) * 77.3
            let spd: Double = 22.0 + s.truncatingRemainder(dividingBy: 14)
            let bx:  Double = (t * spd + s * 60).truncatingRemainder(dividingBy: Double(mapW) + 60) - 30
            let by:  Double = 55.0 + Double(i) * 54
            let wing: Double = sin(t * 4 + s) * 5
            var bird = Path()
            bird.move(to:     CGPoint(x: bx - 8, y: by - wing))
            bird.addCurve(to: CGPoint(x: bx,     y: by),
                          control1: CGPoint(x: bx - 4, y: by - wing + 4),
                          control2: CGPoint(x: bx - 2, y: by))
            bird.addCurve(to: CGPoint(x: bx + 8, y: by - wing),
                          control1: CGPoint(x: bx + 2, y: by),
                          control2: CGPoint(x: bx + 4, y: by - wing + 4))
            ctx.stroke(bird, with: .color(.black.opacity(0.55)), lineWidth: 1.5)
        }
    }

    // --- Sinai: twinkling stars + fire glow ---

    private func drawSinai(_ ctx: inout GraphicsContext, t: Double) {
        for i in 0..<28 {
            let s:  Double = Double(i) * 53.9
            let sx: Double = (sin(s * 1.3) * 0.5 + 0.5) * Double(mapW - 20) + 10
            let sy: Double = Double(bSinai) + (cos(s * 0.9) * 0.5 + 0.5) * Double(bEgypt - bSinai - 30) + 15
            let a:  Double = 0.4 + sin(t * 1.5 + s) * 0.4
            let r:  Double = 1.5 + sin(s * 7.1) * 0.8
            ctx.fill(Path(ellipseIn: CGRect(x: sx - r, y: sy - r, width: r * 2, height: r * 2)),
                     with: .color(Color.white.opacity(a)))
        }
        let px: Double = Double(mapW) * 0.5
        let py: Double = Double(bEgypt) - 62.0
        let fireColor  = Color(rgb: 0xFF8800)
        for ring in 0..<3 {
            let rn:   Double = Double(ring)
            let glow: Double = (28.0 + rn * 14) + sin(t * 3.2 + rn) * 8
            let a:    Double = (0.18 - rn * 0.05) + sin(t * 2.8 + rn) * 0.06
            let gr = CGRect(x: px - glow, y: py - glow * 0.55, width: glow * 2, height: glow * 1.1)
            ctx.fill(Path(ellipseIn: gr), with: .color(fireColor.opacity(a)))
        }
    }

    // --- Egypt: sand particles ---

    private func drawEgypt(_ ctx: inout GraphicsContext, t: Double) {
        let sandColor = Color(rgb: 0xE6C880)
        for i in 0..<24 {
            let s:   Double = Double(i) * 63.1
            let spd: Double = 14.0 + s.truncatingRemainder(dividingBy: 10)
            let px:  Double = (t * spd + s * 22).truncatingRemainder(dividingBy: Double(mapW) + 20) - 10
            let py:  Double = Double(bEgypt) + (cos(s * 1.7) * 0.5 + 0.5) * Double(bPatriarchs - bEgypt - 20) + 10
            let a:   Double = 0.18 + sin(t * 0.7 + s) * 0.10
            ctx.fill(Path(ellipseIn: CGRect(x: px, y: py, width: 3.5, height: 1.8)),
                     with: .color(sandColor.opacity(a)))
        }
    }

    // --- Patriarchs: night stars + campfire ---

    private func drawPatriarchs(_ ctx: inout GraphicsContext, t: Double) {
        let fireColor = Color(rgb: 0xFF7200)
        let cfx: Double = 195.0
        let cfy: Double = Double(bFlood) - 85.0
        for ring in 0..<3 {
            let rn: Double = Double(ring)
            let gl: Double = (16.0 + rn * 10) + sin(t * 4.5 + rn * 1.3) * 6
            let a:  Double = (0.20 - rn * 0.06) + sin(t * 3.8 + rn) * 0.08
            ctx.fill(Path(ellipseIn: CGRect(x: cfx - gl, y: cfy - gl * 0.5, width: gl * 2, height: gl)),
                     with: .color(fireColor.opacity(a)))
        }
        for i in 0..<32 {
            let s:  Double = Double(i) * 37.2
            let sx: Double = (cos(s * 1.1) * 0.5 + 0.5) * Double(mapW - 16) + 8
            let sy: Double = Double(bPatriarchs) + (sin(s * 0.8) * 0.5 + 0.5) * Double(bFlood - bPatriarchs - 20) + 10
            let a:  Double = 0.28 + sin(t * 1.2 + s * 0.9) * 0.38
            let r:  Double = 1.0 + sin(s * 5.3) * 0.6
            ctx.fill(Path(ellipseIn: CGRect(x: sx - r, y: sy - r, width: r * 2, height: r * 2)),
                     with: .color(Color.white.opacity(a)))
        }
    }

    // --- Flood: rain + surface ripples ---

    private func drawFlood(_ ctx: inout GraphicsContext, t: Double) {
        let rainColor   = Color(rgb: 0x8CB8FF)
        let rippleColor = Color(rgb: 0x6699FF)
        let rainH: Double = Double(bEden - bFlood)
        for i in 0..<40 {
            let s:    Double = Double(i) * 29.4
            let rx:   Double = (cos(s * 2.1) * 0.5 + 0.5) * Double(mapW)
            let spd:  Double = 190.0 + s.truncatingRemainder(dividingBy: 90)
            let drop: Double = (t * spd + s * 55).truncatingRemainder(dividingBy: rainH + 30)
            let ry:   Double = Double(bFlood) + drop
            if ry < Double(bEden) {
                var dp = Path()
                dp.move(to:    CGPoint(x: rx,     y: ry))
                dp.addLine(to: CGPoint(x: rx - 2, y: ry + 14))
                ctx.stroke(dp, with: .color(rainColor.opacity(0.38)), lineWidth: 1.2)
            }
        }
        for i in 0..<6 {
            let ry: Double = Double(bEden) - 18.0 - Double(i) * 13
            var rp = Path()
            rp.move(to: CGPoint(x: 0, y: ry))
            var xx: Double = 0
            while xx <= Double(mapW) {
                let wy: Double = ry + sin(xx * 0.06 + t * 1.8 + Double(i) * 0.75) * 4.5
                rp.addLine(to: CGPoint(x: xx, y: wy))
                xx += 4
            }
            ctx.stroke(rp, with: .color(rippleColor.opacity(0.24)), lineWidth: 1.8)
        }
    }

    // --- Eden: fireflies ---

    private func drawEden(_ ctx: inout GraphicsContext, t: Double) {
        let glowC = Color(rgb: 0xCCFF44)
        let coreC = Color(rgb: 0xDDFF66)
        for i in 0..<20 {
            let s:   Double = Double(i) * 83.6
            let fbx: Double = (sin(s * 1.4) * 0.5 + 0.5) * Double(mapW - 30) + 15
            let fby: Double = Double(bEden) + (cos(s * 0.7) * 0.5 + 0.5) * Double(mapH - bEden - 55) + 28
            let ex:  Double = fbx + sin(t * 0.9 + s) * 18
            let ey:  Double = fby + cos(t * 0.7 + s * 1.2) * 14
            let a:   Double = max(0, 0.5 + sin(t * 2.0 + s) * 0.5)
            let r:   Double = 2.5 + sin(s * 4.3)
            ctx.fill(Path(ellipseIn: CGRect(x: ex - r*3, y: ey - r*3, width: r*6, height: r*6)),
                     with: .color(glowC.opacity(a * 0.18)))
            ctx.fill(Path(ellipseIn: CGRect(x: ex - r,   y: ey - r,   width: r*2, height: r*2)),
                     with: .color(coreC.opacity(a * 0.80)))
        }
    }

    // MARK: Path (road between nodes)

    private var pathLayer: some View {
        Canvas { ctx, _ in drawPath(&ctx) }
            .frame(width: mapW, height: mapH)
            .allowsHitTesting(false)
    }

    private func drawPath(_ ctx: inout GraphicsContext) {
        let pts = TrailViewModel.nodePositions
        let doneRoad  = Color(rgb: 0xE0B844)
        let pendRoad  = Color(rgb: 0x9E8560)
        let doneInner = Color(rgb: 0xFFDF80)
        let pendInner = Color(rgb: 0xBFAA82)
        for i in 0..<pts.count - 1 {
            let a    = pts[i]
            let b    = pts[i + 1]
            let ctrl = CGPoint(x: (a.x + b.x) * 0.5, y: min(a.y, b.y) - 30)
            let done = i < vm.completedCount
            let seg  = quadPath(a, ctrl, b)
            let roadC  = done ? doneRoad  : pendRoad
            let innerC = done ? doneInner : pendInner
            let dashA: Double = done ? 0.85 : 0.32
            ctx.stroke(seg, with: .color(.black.opacity(0.38)),
                       style: StrokeStyle(lineWidth: 28, lineCap: .round))
            ctx.stroke(seg, with: .color(roadC),
                       style: StrokeStyle(lineWidth: 22, lineCap: .round))
            ctx.stroke(seg, with: .color(innerC),
                       style: StrokeStyle(lineWidth: 12, lineCap: .round))
            ctx.stroke(seg, with: .color(.white.opacity(dashA)),
                       style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [10, 13]))
        }
    }

    private func quadPath(_ a: CGPoint, _ c: CGPoint, _ b: CGPoint) -> Path {
        var p = Path(); p.move(to: a); p.addQuadCurve(to: b, control: c); return p
    }

    // MARK: Static decorations

    private var staticDeco: some View {
        Canvas { ctx, _ in drawDeco(&ctx) }
            .frame(width: mapW, height: mapH)
            .allowsHitTesting(false)
    }

    private func drawDeco(_ ctx: inout GraphicsContext) {
        hill(&ctx, cx: 75,  cy: 425, rx: 95, ry: 58, c: Color(rgb: 0x0D6B0D).opacity(0.55))
        hill(&ctx, cx: 315, cy: 440, rx: 85, ry: 50, c: Color(rgb: 0x0D6B0D).opacity(0.50))
        mountain(&ctx, cx: 195, cy: bEgypt - 5,        w: 135, h: 95, c: Color(rgb: 0x7A5214).opacity(0.62))
        pyramid(&ctx,  cx: 58,  cy: bPatriarchs - 8,   w: 95,  h: 72, c: Color(rgb: 0x7F5418).opacity(0.55))
        pyramid(&ctx,  cx: 330, cy: bPatriarchs - 18,  w: 72,  h: 56, c: Color(rgb: 0x7F5418).opacity(0.45))
        ark(&ctx, cx: 195, cy: bEden - 26, c: Color(rgb: 0x5A3210).opacity(0.62))
        let groundC = Color(rgb: 0x0B5E0B).opacity(0.78)
        ctx.fill(Path(CGRect(x: 0, y: mapH - 20, width: mapW, height: 20)), with: .color(groundC))
    }

    private func hill(_ ctx: inout GraphicsContext, cx: CGFloat, cy: CGFloat,
                      rx: CGFloat, ry: CGFloat, c: Color) {
        var p = Path()
        p.move(to: CGPoint(x: cx - rx, y: cy))
        p.addCurve(to:     CGPoint(x: cx + rx, y: cy),
                   control1: CGPoint(x: cx - rx * 0.5, y: cy - ry * 1.8),
                   control2: CGPoint(x: cx + rx * 0.5, y: cy - ry * 1.8))
        p.closeSubpath()
        ctx.fill(p, with: .color(c))
    }

    private func mountain(_ ctx: inout GraphicsContext, cx: CGFloat, cy: CGFloat,
                          w: CGFloat, h: CGFloat, c: Color) {
        var bd = Path()
        bd.move(to: CGPoint(x: cx - w/2, y: cy))
        bd.addLine(to: CGPoint(x: cx,     y: cy - h))
        bd.addLine(to: CGPoint(x: cx+w/2, y: cy))
        bd.closeSubpath()
        ctx.fill(bd, with: .color(c))
        var sn = Path()
        sn.move(to: CGPoint(x: cx - 20, y: cy - h * 0.70))
        sn.addLine(to: CGPoint(x: cx,     y: cy - h))
        sn.addLine(to: CGPoint(x: cx + 20, y: cy - h * 0.70))
        sn.closeSubpath()
        ctx.fill(sn, with: .color(.white.opacity(0.55)))
    }

    private func pyramid(_ ctx: inout GraphicsContext, cx: CGFloat, cy: CGFloat,
                         w: CGFloat, h: CGFloat, c: Color) {
        var bd = Path()
        bd.move(to: CGPoint(x: cx - w/2, y: cy))
        bd.addLine(to: CGPoint(x: cx,     y: cy - h))
        bd.addLine(to: CGPoint(x: cx+w/2, y: cy))
        bd.closeSubpath()
        ctx.fill(bd, with: .color(c))
        var lt = Path()
        lt.move(to: CGPoint(x: cx,     y: cy - h))
        lt.addLine(to: CGPoint(x: cx+w/2, y: cy))
        lt.addLine(to: CGPoint(x: cx,     y: cy))
        lt.closeSubpath()
        ctx.fill(lt, with: .color(.white.opacity(0.13)))
    }

    private func ark(_ ctx: inout GraphicsContext, cx: CGFloat, cy: CGFloat, c: Color) {
        var hull = Path()
        hull.move(to: CGPoint(x: cx - 58, y: cy))
        hull.addQuadCurve(to: CGPoint(x: cx + 58, y: cy), control: CGPoint(x: cx, y: cy + 30))
        hull.addLine(to: CGPoint(x: cx + 50, y: cy - 12))
        hull.addLine(to: CGPoint(x: cx - 50, y: cy - 12))
        hull.closeSubpath()
        ctx.fill(hull, with: .color(c))
        var cabin = Path()
        cabin.addRect(CGRect(x: cx - 30, y: cy - 34, width: 60, height: 22))
        ctx.fill(cabin, with: .color(c.opacity(0.80)))
        var roof = Path()
        roof.move(to: CGPoint(x: cx - 34, y: cy - 34))
        roof.addLine(to: CGPoint(x: cx,      y: cy - 50))
        roof.addLine(to: CGPoint(x: cx + 34, y: cy - 34))
        roof.closeSubpath()
        ctx.fill(roof, with: .color(c))
    }

    // MARK: Biome banners

    private var biomeBanners: some View {
        let items: [(String, String, CGFloat)] = [
            ("🏹", "TERRA PROMETIDA", bSinai  * 0.18 + 24),
            ("📜", "SINAI E ÊXODO",   bSinai  + 26),
            ("🏛️", "O EGITO",         bEgypt  + 26),
            ("⭐", "OS PATRIARCAS",   bPatriarchs + 26),
            ("🌊", "NOÉ E O DILÚVIO", bFlood  + 26),
            ("🌍", "A CRIAÇÃO",       bEden   + 26),
        ]
        return ZStack(alignment: .topLeading) {
            ForEach(items.indices, id: \.self) { i in
                HStack(spacing: 5) {
                    Text(items[i].0).font(.system(size: 12))
                    Text(items[i].1)
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .kerning(1.4)
                        .foregroundColor(.white.opacity(0.90))
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(Capsule().fill(.black.opacity(0.32))
                    .overlay(Capsule().stroke(.white.opacity(0.18), lineWidth: 1)))
                .position(x: mapW / 2, y: items[i].2)
            }
        }
    }

    // MARK: Nodes

    private var nodesLayer: some View {
        ZStack(alignment: .topLeading) {
            ForEach(vm.nodes.indices, id: \.self) { i in
                TrailNodeBtn(node: vm.nodes[i]) {
                    if vm.nodes[i].status != .locked { selectedNodeIndex = i }
                }
                .position(TrailViewModel.nodePositions[i])
            }
        }
    }

    // MARK: Character

    private var charLayer: some View {
        ZStack {
            Ellipse().fill(.black.opacity(0.22))
                .frame(width: 44, height: 9).blur(radius: 4).offset(y: NR + 12)
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.45), radius: 2)
                .offset(y: -(NR + 22) + charBob)
            Text("🧑").font(.system(size: 40))
                .shadow(color: .black.opacity(0.40), radius: 4, x: 1, y: 3)
                .offset(y: charBob)
        }
        .animation(.spring(response: 0.85, dampingFraction: 0.62), value: vm.characterNodeIndex)
        .position(vm.characterPosition)
        .id("char")
    }
}

// MARK: - Node button

struct TrailNodeBtn: View {
    let node:  TrailNodeData
    let onTap: () -> Void
    @State private var ringScale: CGFloat = 1.0
    @State private var ringAlpha: CGFloat = 0.8

    private var baseColor: Color {
        switch node.status {
        case .locked:    return Color(rgb: 0x4D5260)
        case .available: return Color(rgb: 0x1A5FD9)
        case .completed: return Color(rgb: 0xD18008)
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if node.status == .available {
                    Circle().stroke(baseColor.opacity(ringAlpha), lineWidth: 3)
                        .frame(width: NR*2+20, height: NR*2+20).scaleEffect(ringScale)
                }
                Circle().fill(.white.opacity(0.15)).frame(width: NR*2+8, height: NR*2+8)
                Circle()
                    .fill(LinearGradient(colors: [baseColor.opacity(0.88), baseColor],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: NR*2, height: NR*2)
                    .shadow(color: baseColor.opacity(0.55), radius: 12, x: 0, y: 5)
                    .shadow(color: .black.opacity(0.30),    radius:  5, x: 0, y: 3)
                Circle()
                    .fill(RadialGradient(colors: [.white.opacity(0.32), .clear],
                                         center: UnitPoint(x: 0.28, y: 0.20),
                                         startRadius: 0, endRadius: NR * 0.88))
                    .frame(width: NR*2, height: NR*2)
                if node.status == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.65))
                } else {
                    Text(node.emoji).font(.system(size: 30))
                }
                if node.status == .completed {
                    ZStack {
                        Circle().fill(.white).frame(width: 23, height: 23)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color(rgb: 0x1A9E30))
                    }
                    .offset(x: NR - 3, y: -(NR - 3))
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: NR*2+24, height: NR*2+24)
        .overlay(alignment: .bottom) {
            if node.status != .locked {
                Text(node.title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.72), radius: 3, x: 0, y: 1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 90)
                    .offset(y: NR + 28)
            }
        }
        .onAppear {
            guard node.status == .available else { return }
            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                ringScale = 1.60; ringAlpha = 0
            }
        }
    }
}

// MARK: - Colour helper

extension Color {
    init(rgb hex: UInt32) {
        self.init(red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >>  8) & 0xFF) / 255,
                  blue:  Double( hex        & 0xFF) / 255)
    }
}
