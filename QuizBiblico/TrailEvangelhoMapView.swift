import SwiftUI

// MARK: - Constants

private let mapW: CGFloat = 390
private let mapH: CGFloat = 3200
private let NR:   CGFloat = 50

private let bGloria:     CGFloat = 0
private let bCalvario:   CGFloat = 554
private let bJerusalem:  CGFloat = 935
private let bMinisterio: CGFloat = 1465
private let bGalileia:   CGFloat = 2068
private let bNazare:     CGFloat = 2639

// MARK: - Main View

struct TrailEvangelhoMapView: View {
    @StateObject private var vm = TrailViewModel(trail: .evangelhos)
    @State private var selectedNodeIndex: Int? = nil
    @State private var charBob: CGFloat = 0
    @State private var isWalking: Bool = false
    @State private var walkFacingRight: Bool = true

    var body: some View {
        ZStack(alignment: .top) {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    mapStack.frame(width: mapW, height: mapH)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) { charBob = -10 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation { proxy.scrollTo("echar", anchor: .center) }
                    }
                }
            }
            progressHeader
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Label("Os Evangelhos", systemImage: "sun.max.fill")
                    .font(.headline).foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { vm.resetProgress() } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .toolbarBackground(Color(hex: 0x7A4A00), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: Binding(get: { selectedNodeIndex != nil },
                                    set: { if !$0 { selectedNodeIndex = nil } })) {
            if let i = selectedNodeIndex {
                TrailStudyView(node: vm.nodes[i], nodeIndex: i) { vm.completeNode(index: i) }
            }
        }
    }

    private var mapStack: some View {
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in drawBackground(&ctx) }.frame(width: mapW, height: mapH).allowsHitTesting(false)
            Canvas { ctx, _ in drawStoryArt(&ctx) }.frame(width: mapW, height: mapH).allowsHitTesting(false)
            TimelineView(.animation) { tl in
                Canvas { ctx, _ in drawParticles(&ctx, t: tl.date.timeIntervalSinceReferenceDate) }
                    .frame(width: mapW, height: mapH)
                    .allowsHitTesting(false)
            }
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
                    .fill(i < vm.completedCount ? Color(hex: 0xFFD700) : Color.white.opacity(0.22))
                    .frame(height: 6)
                    .animation(.spring(), value: vm.completedCount)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: ── BACKGROUND ────────────────────────────────────────────────────

    private func drawBackground(_ ctx: inout GraphicsContext) {
        // Glória (top): luminous gold/white
        gradStop(&ctx, y: bGloria,     h: bCalvario-bGloria,
                 c0: Color(hex:0xFFF8E0), c1: Color(hex:0xFFE566), c2: Color(hex:0xFFCC00))
        // Calvário: deep crimson/dark
        gradStop(&ctx, y: bCalvario,   h: bJerusalem-bCalvario,
                 c0: Color(hex:0x1A0505), c1: Color(hex:0x3A0E0E), c2: Color(hex:0x5A1A14))
        // Jerusalém: sandy sandstone
        gradStop(&ctx, y: bJerusalem,  h: bMinisterio-bJerusalem,
                 c0: Color(hex:0xB08840), c1: Color(hex:0xC8A055), c2: Color(hex:0xD4B06A))
        // Ministério: sage green hills
        gradStop(&ctx, y: bMinisterio, h: bGalileia-bMinisterio,
                 c0: Color(hex:0x1A4A10), c1: Color(hex:0x2A6A1A), c2: Color(hex:0x3A8A24))
        // Galileia: deep teal/blue sea
        gradStop(&ctx, y: bGalileia,   h: bNazare-bGalileia,
                 c0: Color(hex:0x052060), c1: Color(hex:0x0A3888), c2: Color(hex:0x1050A8))
        // Nazaré (bottom): warm honey/amber
        gradStop(&ctx, y: bNazare,     h: mapH-bNazare,
                 c0: Color(hex:0x7A4A08), c1: Color(hex:0xA06A18), c2: Color(hex:0xC88A28))

        // Blend zones
        let bH: CGFloat = 280
        blendZone(&ctx, y: bCalvario,   upper: Color(hex:0xFFCC00), lower: Color(hex:0x1A0505), h: bH)
        blendZone(&ctx, y: bJerusalem,  upper: Color(hex:0x5A1A14), lower: Color(hex:0xB08840), h: bH)
        blendZone(&ctx, y: bMinisterio, upper: Color(hex:0xD4B06A), lower: Color(hex:0x1A4A10), h: bH)
        blendZone(&ctx, y: bGalileia,   upper: Color(hex:0x3A8A24), lower: Color(hex:0x052060), h: bH)
        blendZone(&ctx, y: bNazare,     upper: Color(hex:0x1050A8), lower: Color(hex:0x7A4A08), h: bH)

        drawDirtPath(&ctx)
    }

    private func gradStop(_ ctx: inout GraphicsContext, y:CGFloat, h:CGFloat, c0:Color, c1:Color, c2:Color) {
        let mid = y + h*0.5
        ctx.fill(Path(CGRect(x:0,y:y,width:mapW,height:h*0.5)),
                 with:.linearGradient(Gradient(colors:[c0,c1]),startPoint:CGPoint(x:mapW/2,y:y),endPoint:CGPoint(x:mapW/2,y:mid)))
        ctx.fill(Path(CGRect(x:0,y:mid,width:mapW,height:h*0.5)),
                 with:.linearGradient(Gradient(colors:[c1,c2]),startPoint:CGPoint(x:mapW/2,y:mid),endPoint:CGPoint(x:mapW/2,y:y+h)))
    }

    private func blendZone(_ ctx: inout GraphicsContext, y: CGFloat, upper: Color, lower: Color, h: CGFloat) {
        let top = y - h / 2
        ctx.fill(Path(CGRect(x: 0, y: top, width: mapW, height: h)),
                 with: .linearGradient(Gradient(colors: [upper, lower]),
                                       startPoint: CGPoint(x: mapW/2, y: top),
                                       endPoint:   CGPoint(x: mapW/2, y: top + h)))
    }

    // MARK: ── STORY ART ──────────────────────────────────────────────────────

    private func drawStoryArt(_ ctx: inout GraphicsContext) {
        drawNazareArt(&ctx)
        drawGalileiaArt(&ctx)
        drawMinisterioArt(&ctx)
        drawJerusalemArt(&ctx)
        drawCalvarioArt(&ctx)
        drawGloriaArt(&ctx)
    }

    // ── Nazaré: Estrela de Belém, manjedoura, ferramentas de carpinteiro ──

    private func drawNazareArt(_ ctx: inout GraphicsContext) {
        drawBethlehemStar(&ctx)
        drawManger(&ctx)
        drawCarpenterTools(&ctx)
    }

    private func drawBethlehemStar(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 3080.0
        let starC = Color(hex:0xFFFFAA)
        let glowC = Color(hex:0xFFEE66)
        for ring in 0..<5 {
            let r = 18.0 + Double(ring)*14
            ctx.fill(Path(ellipseIn:CGRect(x:cx-r,y:cy-r,width:r*2,height:r*2)),
                     with:.color(glowC.opacity(0.28 - Double(ring)*0.05)))
        }
        ctx.fill(Path(ellipseIn:CGRect(x:cx-12,y:cy-12,width:24,height:24)),with:.color(starC.opacity(0.95)))
        for i in 0..<8 {
            let angle = Double(i) * 45.0 * .pi / 180
            let x1 = cx + cos(angle)*14; let y1 = cy + sin(angle)*14
            let x2 = cx + cos(angle)*48; let y2 = cy + sin(angle)*48
            var ray = Path(); ray.move(to:CGPoint(x:x1,y:y1)); ray.addLine(to:CGPoint(x:x2,y:y2))
            ctx.stroke(ray,with:.color(starC.opacity(0.55)),lineWidth:2.5)
        }
    }

    private func drawManger(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 2870.0
        let woodC = Color(hex:0x6A3A10)
        let strawC = Color(hex:0xD4A830)
        let babyC  = Color(hex:0xF0D0A0)
        // Manger legs
        for lx in [cx-50.0, cx+50.0] {
            ctx.fill(Path(CGRect(x:lx-4,y:cy-10,width:8,height:38)),with:.color(woodC.opacity(0.85)))
        }
        // Manger trough
        ctx.fill(Path(CGRect(x:cx-56,y:cy-28,width:112,height:22)),with:.color(woodC.opacity(0.80)))
        ctx.fill(Path(CGRect(x:cx-48,y:cy-20,width:96,height:10)),with:.color(strawC.opacity(0.75)))
        // Baby
        ctx.fill(Path(ellipseIn:CGRect(x:cx-14,y:cy-46,width:28,height:22)),with:.color(babyC.opacity(0.88)))
        // Swaddling strips
        for i in 0..<3 {
            let wy = cy-40+Double(i)*8
            ctx.stroke(Path(CGRect(x:cx-12,y:wy,width:24,height:6)),
                       with:.color(.white.opacity(0.55)),lineWidth:1.5)
        }
        // Halo
        ctx.stroke(Path(ellipseIn:CGRect(x:cx-18,y:cy-56,width:36,height:20)),
                   with:.color(Color(hex:0xFFDD66).opacity(0.60)),lineWidth:2)
    }

    private func drawCarpenterTools(_ ctx: inout GraphicsContext) {
        let toolC = Color(hex:0x8B5A1A)
        let metalC = Color(hex:0xC0A060)
        // Saw
        var saw = Path()
        saw.move(to:CGPoint(x:54,y:2760))
        saw.addLine(to:CGPoint(x:148,y:2760))
        ctx.stroke(saw,with:.color(metalC.opacity(0.75)),lineWidth:5)
        for i in 0..<8 {
            var tooth = Path()
            let tx = 54.0 + Double(i)*12
            tooth.move(to:CGPoint(x:tx,y:2760)); tooth.addLine(to:CGPoint(x:tx+6,y:2750))
            ctx.stroke(tooth,with:.color(metalC.opacity(0.65)),lineWidth:2)
        }
        ctx.fill(Path(CGRect(x:148,y:2752,width:22,height:16)),with:.color(toolC.opacity(0.80)))
        // Hammer
        ctx.fill(Path(CGRect(x:258,y:2748,width:40,height:18)),with:.color(metalC.opacity(0.80)))
        var handle = Path()
        handle.move(to:CGPoint(x:268,y:2766)); handle.addLine(to:CGPoint(x:258,y:2808))
        ctx.stroke(handle,with:.color(toolC.opacity(0.80)),lineWidth:5)
    }

    // ── Galileia: ondas do mar, peixes, pomba descendo ──

    private func drawGalileiaArt(_ ctx: inout GraphicsContext) {
        drawSeaWaves(&ctx)
        drawFishGroup(&ctx)
        drawDescentDove(&ctx)
    }

    private func drawSeaWaves(_ ctx: inout GraphicsContext) {
        let wC = Color(hex:0x4488CC)
        let wC2 = Color(hex:0x88BBEE)
        for i in 0..<5 {
            let wy = bNazare + 60 + Double(i)*60
            var wave = Path()
            wave.move(to:CGPoint(x:0,y:wy))
            for x in stride(from:0.0, to:390.0, by:30.0) {
                wave.addCurve(to:CGPoint(x:x+30,y:wy),
                              control1:CGPoint(x:x+10,y:wy-14),
                              control2:CGPoint(x:x+20,y:wy+14))
            }
            ctx.stroke(wave,with:.color(wC.opacity(0.35)),lineWidth:2.5)
        }
        // Large wave crest
        var bigWave = Path()
        bigWave.move(to:CGPoint(x:0,y:bGalileia-30))
        bigWave.addCurve(to:CGPoint(x:mapW,y:bGalileia-30),
                         control1:CGPoint(x:100,y:bGalileia-80),
                         control2:CGPoint(x:290,y:bGalileia+20))
        ctx.stroke(bigWave,with:.color(wC2.opacity(0.40)),lineWidth:4)
    }

    private func drawFishGroup(_ ctx: inout GraphicsContext) {
        for (fx,fy,sc) in [(80.0,2480.0,1.0),(155.0,2430.0,0.75),(240.0,2460.0,0.9),
                           (305.0,2390.0,0.65),(100.0,2350.0,0.80)] {
            drawFish(&ctx, cx:fx, cy:fy, scale:sc)
        }
    }

    private func drawFish(_ ctx: inout GraphicsContext, cx: Double, cy: Double, scale: Double) {
        let fC = Color(hex:0xAADDFF)
        let s  = scale
        // Body
        var body = Path()
        body.move(to:CGPoint(x:cx-20*s,y:cy))
        body.addCurve(to:CGPoint(x:cx+20*s,y:cy),
                      control1:CGPoint(x:cx-5*s,y:cy-10*s),
                      control2:CGPoint(x:cx+5*s,y:cy-10*s))
        body.addCurve(to:CGPoint(x:cx-20*s,y:cy),
                      control1:CGPoint(x:cx+5*s,y:cy+10*s),
                      control2:CGPoint(x:cx-5*s,y:cy+10*s))
        ctx.fill(body,with:.color(fC.opacity(0.55)))
        // Tail
        var tail = Path()
        tail.move(to:CGPoint(x:cx+18*s,y:cy))
        tail.addLine(to:CGPoint(x:cx+30*s,y:cy-8*s))
        tail.addLine(to:CGPoint(x:cx+30*s,y:cy+8*s))
        tail.closeSubpath()
        ctx.fill(tail,with:.color(fC.opacity(0.50)))
        // Eye
        ctx.fill(Path(ellipseIn:CGRect(x:cx-14*s,y:cy-4*s,width:5*s,height:5*s)),
                 with:.color(.black.opacity(0.55)))
    }

    private func drawDescentDove(_ ctx: inout GraphicsContext) {
        let dx = 195.0; let dy = 2540.0
        let dC = Color.white.opacity(0.90)
        // Wings spread
        var lwing = Path()
        lwing.move(to:CGPoint(x:dx,y:dy))
        lwing.addCurve(to:CGPoint(x:dx-38,y:dy-18),
                       control1:CGPoint(x:dx-14,y:dy-18),
                       control2:CGPoint(x:dx-30,y:dy-22))
        lwing.addCurve(to:CGPoint(x:dx-18,y:dy+4),
                       control1:CGPoint(x:dx-32,y:dy-8),
                       control2:CGPoint(x:dx-24,y:dy))
        ctx.fill(lwing,with:.color(dC))

        var rwing = Path()
        rwing.move(to:CGPoint(x:dx,y:dy))
        rwing.addCurve(to:CGPoint(x:dx+38,y:dy-18),
                       control1:CGPoint(x:dx+14,y:dy-18),
                       control2:CGPoint(x:dx+30,y:dy-22))
        rwing.addCurve(to:CGPoint(x:dx+18,y:dy+4),
                       control1:CGPoint(x:dx+32,y:dy-8),
                       control2:CGPoint(x:dx+24,y:dy))
        ctx.fill(rwing,with:.color(dC))

        // Body + head
        ctx.fill(Path(ellipseIn:CGRect(x:dx-9,y:dy-5,width:18,height:14)),with:.color(dC))
        ctx.fill(Path(ellipseIn:CGRect(x:dx-6,y:dy-16,width:12,height:12)),with:.color(dC))

        // Rays descending from dove
        let rC = Color(hex:0xFFFFDD)
        for i in 0..<6 {
            let angle = (Double(i)/6.0 - 0.5) * .pi * 0.6
            var ray = Path()
            ray.move(to:CGPoint(x:dx,y:dy+8))
            ray.addLine(to:CGPoint(x:dx+sin(angle)*60,y:dy+8+cos(angle)*50))
            ctx.stroke(ray,with:.color(rC.opacity(0.30)),lineWidth:2)
        }
    }

    // ── Ministério: multidão + monte + pães e peixes ──

    private func drawMinisterioArt(_ ctx: inout GraphicsContext) {
        drawCrowdOnHill(&ctx)
        drawLoavesAndFish(&ctx)
    }

    private func drawCrowdOnHill(_ ctx: inout GraphicsContext) {
        let baseY = bGalileia - 20
        let hillC = Color(hex:0x2A5A14)
        var hill = Path()
        hill.move(to:CGPoint(x:0,y:baseY))
        hill.addCurve(to:CGPoint(x:mapW,y:baseY),
                      control1:CGPoint(x:100,y:baseY-80),
                      control2:CGPoint(x:290,y:baseY-100))
        hill.addLine(to:CGPoint(x:mapW,y:baseY+40)); hill.addLine(to:CGPoint(x:0,y:baseY+40))
        hill.closeSubpath()
        ctx.fill(hill,with:.color(hillC.opacity(0.55)))

        // Crowd silhouettes
        let sC = Color.black.opacity(0.38)
        for (px,py) in [(60.0,baseY-22),(90.0,baseY-18),(120.0,baseY-24),(150.0,baseY-16),
                        (180.0,baseY-28),(220.0,baseY-20),(260.0,baseY-26),(300.0,baseY-18),
                        (330.0,baseY-22),(360.0,baseY-15)] {
            ctx.fill(Path(ellipseIn:CGRect(x:px-4,y:py-9,width:8,height:9)),with:.color(sC))
            ctx.fill(Path(CGRect(x:px-3,y:py,width:6,height:14)),with:.color(sC))
        }
    }

    private func drawLoavesAndFish(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = bGalileia + 200
        let breadC = Color(hex:0xD4A844)
        let fishC  = Color(hex:0xAADDFF)
        // 5 loaves
        for i in 0..<5 {
            let bx = cx - 60 + Double(i)*28
            var loaf = Path()
            loaf.move(to:CGPoint(x:bx-10,y:cy+8))
            loaf.addCurve(to:CGPoint(x:bx+10,y:cy+8),
                          control1:CGPoint(x:bx-10,y:cy-14),
                          control2:CGPoint(x:bx+10,y:cy-14))
            loaf.closeSubpath()
            ctx.fill(loaf,with:.color(breadC.opacity(0.82)))
            ctx.stroke(loaf,with:.color(Color(hex:0xA07820).opacity(0.55)),lineWidth:1)
        }
        // 2 fish
        for (fx,flip) in [(cx-36,1.0),(cx+36,-1.0)] {
            var fish = Path()
            fish.move(to:CGPoint(x:fx-16*flip,y:cy+30))
            fish.addCurve(to:CGPoint(x:fx+16*flip,y:cy+30),
                          control1:CGPoint(x:fx-4*flip,y:cy+18),
                          control2:CGPoint(x:fx+4*flip,y:cy+18))
            fish.addCurve(to:CGPoint(x:fx-16*flip,y:cy+30),
                          control1:CGPoint(x:fx+4*flip,y:cy+42),
                          control2:CGPoint(x:fx-4*flip,y:cy+42))
            ctx.fill(fish,with:.color(fishC.opacity(0.65)))
            var tail2 = Path()
            tail2.move(to:CGPoint(x:fx+14*flip,y:cy+30))
            tail2.addLine(to:CGPoint(x:fx+24*flip,y:cy+22))
            tail2.addLine(to:CGPoint(x:fx+24*flip,y:cy+38))
            tail2.closeSubpath()
            ctx.fill(tail2,with:.color(fishC.opacity(0.55)))
        }
    }

    // ── Jerusalém: muros, ramos de palma, pão e cálice ──

    private func drawJerusalemArt(_ ctx: inout GraphicsContext) {
        drawCityWalls(&ctx)
        drawPalmBranches(&ctx)
        drawBreadAndCup(&ctx)
    }

    private func drawCityWalls(_ ctx: inout GraphicsContext) {
        let wallC = Color(hex:0xC0A050)
        let darkC = Color(hex:0x8A7030)
        let baseY = bJerusalem + 30
        // Main wall
        ctx.fill(Path(CGRect(x:20,y:baseY,width:350,height:55)),with:.color(wallC.opacity(0.72)))
        // Merlons
        for i in 0..<12 {
            ctx.fill(Path(CGRect(x:24+Double(i)*29,y:baseY-16,width:18,height:18)),with:.color(wallC.opacity(0.80)))
        }
        // Gate arch
        var gate = Path()
        gate.move(to:CGPoint(x:178,y:baseY+55))
        gate.addLine(to:CGPoint(x:178,y:baseY+20))
        gate.addArc(center:CGPoint(x:195,y:baseY+20),radius:17,
                    startAngle:.degrees(180),endAngle:.degrees(0),clockwise:false)
        gate.addLine(to:CGPoint(x:212,y:baseY+55))
        ctx.fill(gate,with:.color(.black.opacity(0.55)))
        // Shadow strip
        ctx.fill(Path(CGRect(x:195,y:baseY,width:175,height:55)),with:.color(darkC.opacity(0.22)))
    }

    private func drawPalmBranches(_ ctx: inout GraphicsContext) {
        let lC = Color(hex:0x3A8020)
        let stemC = Color(hex:0x6A4A18)
        for (px,py,dir) in [(44.0,1200.0,1.0),(330.0,1220.0,-1.0),(80.0,1310.0,1.0),(310.0,1330.0,-1.0)] {
            var stem = Path()
            stem.move(to:CGPoint(x:px,y:py))
            stem.addCurve(to:CGPoint(x:px+dir*28,y:py-55),
                          control1:CGPoint(x:px+dir*6,y:py-20),
                          control2:CGPoint(x:px+dir*20,y:py-42))
            ctx.stroke(stem,with:.color(stemC.opacity(0.72)),lineWidth:3)
            // Leaflets
            for i in 0..<5 {
                let t = Double(i)/4.0
                let lx = px + (px+dir*28-px)*t + dir*6
                let ly = py + (py-55-py)*t - 4
                var leaf = Path()
                leaf.move(to:CGPoint(x:lx,y:ly))
                leaf.addLine(to:CGPoint(x:lx+dir*14,y:ly-8))
                ctx.stroke(leaf,with:.color(lC.opacity(0.75)),lineWidth:2.5)
            }
        }
    }

    private func drawBreadAndCup(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 1080.0
        let breadC = Color(hex:0xD4A844)
        let cupC   = Color(hex:0xC08820)
        let glowC  = Color(hex:0xFFE066)

        // Glow behind
        ctx.fill(Path(ellipseIn:CGRect(x:cx-50,y:cy-50,width:100,height:100)),
                 with:.color(glowC.opacity(0.14)))

        // Broken bread loaf
        var loaf = Path()
        loaf.move(to:CGPoint(x:cx-44,y:cy+12))
        loaf.addCurve(to:CGPoint(x:cx-6,y:cy+12),
                      control1:CGPoint(x:cx-44,y:cy-22),control2:CGPoint(x:cx-6,y:cy-22))
        loaf.closeSubpath()
        ctx.fill(loaf,with:.color(breadC.opacity(0.88)))

        var loaf2 = Path()
        loaf2.move(to:CGPoint(x:cx+8,y:cy+12))
        loaf2.addCurve(to:CGPoint(x:cx+44,y:cy+12),
                       control1:CGPoint(x:cx+8,y:cy-22),control2:CGPoint(x:cx+44,y:cy-22))
        loaf2.closeSubpath()
        ctx.fill(loaf2,with:.color(breadC.opacity(0.85)))

        // Chalice/cup
        var cup = Path()
        cup.move(to:CGPoint(x:cx-18,y:cy+20))
        cup.addLine(to:CGPoint(x:cx-12,y:cy+52))
        cup.addLine(to:CGPoint(x:cx-22,y:cy+52))
        cup.addLine(to:CGPoint(x:cx+22,y:cy+52))
        cup.addLine(to:CGPoint(x:cx+12,y:cy+52))
        cup.addLine(to:CGPoint(x:cx+18,y:cy+20))
        cup.closeSubpath()
        ctx.fill(cup,with:.color(cupC.opacity(0.88)))
        // Cup bowl
        ctx.fill(Path(ellipseIn:CGRect(x:cx-20,y:cy+8,width:40,height:18)),with:.color(cupC.opacity(0.88)))
        // Wine glow
        ctx.fill(Path(ellipseIn:CGRect(x:cx-16,y:cy+12,width:32,height:12)),
                 with:.color(Color(hex:0x880018).opacity(0.55)))
    }

    // ── Calvário: cruz, escuridão, véu rasgado ──

    private func drawCalvarioArt(_ ctx: inout GraphicsContext) {
        drawCross(&ctx)
        drawTornVeil(&ctx)
        drawDarkClouds(&ctx)
    }

    private func drawCross(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let baseY = bCalvario + 80
        let cC  = Color(hex:0x3A2808)
        let hiC = Color(hex:0x5A3A10)
        // Vertical beam
        ctx.fill(Path(CGRect(x:cx-9,y:baseY-120,width:18,height:138)),with:.color(cC.opacity(0.90)))
        ctx.fill(Path(CGRect(x:cx+3,y:baseY-120,width:6,height:138)),with:.color(hiC.opacity(0.28)))
        // Horizontal beam
        ctx.fill(Path(CGRect(x:cx-62,y:baseY-90,width:124,height:16)),with:.color(cC.opacity(0.90)))
        ctx.fill(Path(CGRect(x:cx,y:baseY-90,width:62,height:16)),with:.color(hiC.opacity(0.28)))
    }

    private func drawTornVeil(_ ctx: inout GraphicsContext) {
        let vC = Color(hex:0xE8D8A0)
        // Left half of torn veil
        var lv = Path()
        lv.move(to:CGPoint(x:22,y:bCalvario+310))
        lv.addLine(to:CGPoint(x:22,y:bCalvario+180))
        lv.addCurve(to:CGPoint(x:175,y:bCalvario+260),
                    control1:CGPoint(x:80,y:bCalvario+170),
                    control2:CGPoint(x:140,y:bCalvario+230))
        lv.addLine(to:CGPoint(x:175,y:bCalvario+390))
        lv.closeSubpath()
        ctx.fill(lv,with:.color(vC.opacity(0.55)))
        // Right half
        var rv = Path()
        rv.move(to:CGPoint(x:368,y:bCalvario+310))
        rv.addLine(to:CGPoint(x:368,y:bCalvario+180))
        rv.addCurve(to:CGPoint(x:215,y:bCalvario+260),
                    control1:CGPoint(x:310,y:bCalvario+170),
                    control2:CGPoint(x:250,y:bCalvario+230))
        rv.addLine(to:CGPoint(x:215,y:bCalvario+390))
        rv.closeSubpath()
        ctx.fill(rv,with:.color(vC.opacity(0.55)))
    }

    private func drawDarkClouds(_ ctx: inout GraphicsContext) {
        let dC = Color.black.opacity(0.55)
        ctx.fill(Path(CGRect(x:0,y:bCalvario,width:mapW,height:120)),with:.color(dC))
        ctx.fill(Path(CGRect(x:0,y:bCalvario+100,width:mapW,height:60)),
                 with:.linearGradient(Gradient(colors:[.black.opacity(0.55),.clear]),
                                      startPoint:CGPoint(x:mapW/2,y:bCalvario+100),
                                      endPoint:CGPoint(x:mapW/2,y:bCalvario+160)))
    }

    // ── Glória: cruz vazia, sol nascente, raios dourados ──

    private func drawGloriaArt(_ ctx: inout GraphicsContext) {
        drawRisingSun(&ctx)
        drawEmptyCross(&ctx)
        drawGloryRays(&ctx)
    }

    private func drawRisingSun(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 220.0
        let sunC  = Color(hex:0xFFFFCC)
        let glowC = Color(hex:0xFFDD44)
        for ring in 0..<7 {
            let r = 28.0 + Double(ring)*18
            ctx.fill(Path(ellipseIn:CGRect(x:cx-r,y:cy-r,width:r*2,height:r*2)),
                     with:.color(glowC.opacity(0.28 - Double(ring)*0.03)))
        }
        ctx.fill(Path(ellipseIn:CGRect(x:cx-26,y:cy-26,width:52,height:52)),with:.color(sunC.opacity(0.96)))
    }

    private func drawEmptyCross(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let baseY = bCalvario - 60
        let cC = Color(hex:0x8A6020)
        let hiC = Color(hex:0xC8A040)
        ctx.fill(Path(CGRect(x:cx-7,y:baseY-95,width:14,height:108)),with:.color(cC.opacity(0.80)))
        ctx.fill(Path(CGRect(x:cx+2,y:baseY-95,width:5,height:108)),with:.color(hiC.opacity(0.30)))
        ctx.fill(Path(CGRect(x:cx-48,y:baseY-70,width:96,height:13)),with:.color(cC.opacity(0.80)))
        ctx.fill(Path(CGRect(x:cx,y:baseY-70,width:48,height:13)),with:.color(hiC.opacity(0.30)))
        // Golden glow around empty cross
        ctx.fill(Path(ellipseIn:CGRect(x:cx-60,y:baseY-108,width:120,height:128)),
                 with:.color(Color(hex:0xFFEE66).opacity(0.20)))
    }

    private func drawGloryRays(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 220.0
        let rC = Color(hex:0xFFEE88)
        for i in 0..<16 {
            let angle = Double(i) * (360.0/16.0) * .pi/180
            let x1 = cx + cos(angle)*30; let y1 = cy + sin(angle)*30
            let x2 = cx + cos(angle)*120; let y2 = cy + sin(angle)*120
            var ray = Path(); ray.move(to:CGPoint(x:x1,y:y1)); ray.addLine(to:CGPoint(x:x2,y:y2))
            ctx.stroke(ray,with:.color(rC.opacity(0.28)),lineWidth:2)
        }
    }

    // MARK: ── ANIMATED PARTICLES ─────────────────────────────────────────────

    private func drawParticles(_ ctx: inout GraphicsContext, t: Double) {
        drawStarParticles(&ctx, t:t)
        drawSeaSparkles(&ctx, t:t)
        drawGoldenMotes(&ctx, t:t)
        drawGloryShimmer(&ctx, t:t)
        drawCandleFlicker(&ctx, t:t)
    }

    private func drawStarParticles(_ ctx: inout GraphicsContext, t: Double) {
        let sC = Color(hex:0xFFFFBB)
        for i in 0..<25 {
            let s  = Double(i)*41.3
            let sx = (cos(s*1.2)*0.5+0.5)*Double(mapW-12)+6
            let sy = Double(bNazare)+(sin(s*0.9)*0.5+0.5)*Double(mapH-bNazare-30)+15
            let a  = 0.25+sin(t*1.1+s*0.8)*0.35; let r = 1.0+sin(s*4.7)*0.7
            ctx.fill(Path(ellipseIn:CGRect(x:sx-r,y:sy-r,width:r*2,height:r*2)),with:.color(sC.opacity(a)))
        }
    }

    private func drawSeaSparkles(_ ctx: inout GraphicsContext, t: Double) {
        let spC = Color(hex:0xAADDFF)
        for i in 0..<28 {
            let s   = Double(i)*53.1
            let sx  = (sin(s*1.6)*0.5+0.5)*Double(mapW)
            let sy  = Double(bGalileia)+(cos(s*0.7)*0.5+0.5)*Double(bNazare-bGalileia-20)+10
            let spd = 30.0+s.truncatingRemainder(dividingBy:20)
            let phase = (t*spd+s*14).truncatingRemainder(dividingBy:100)
            let a  = max(0, sin(phase/100*2*Double.pi))*0.55
            let r  = 1.5+sin(s*3.4)*0.8
            ctx.fill(Path(ellipseIn:CGRect(x:sx-r,y:sy-r,width:r*2,height:r*2)),with:.color(spC.opacity(a)))
        }
    }

    private func drawGoldenMotes(_ ctx: inout GraphicsContext, t: Double) {
        let mC = Color(hex:0xFFCC44)
        for i in 0..<16 {
            let s   = Double(i)*67.8
            let mx  = (cos(s*0.9)*0.5+0.5)*Double(mapW-20)+10
            let spd = 22.0+s.truncatingRemainder(dividingBy:14)
            let drop = (t*spd+s*40).truncatingRemainder(dividingBy:Double(bNazare-bGalileia)+40)
            let my  = Double(bGalileia)+drop
            if my < Double(bNazare) {
                let a = 0.20+sin(t*1.3+s)*0.12
                ctx.fill(Path(ellipseIn:CGRect(x:mx,y:my,width:4,height:4)),with:.color(mC.opacity(a)))
            }
        }
    }

    private func drawGloryShimmer(_ ctx: inout GraphicsContext, t: Double) {
        let gC = Color(hex:0xFFFF99)
        for i in 0..<20 {
            let s  = Double(i)*29.7
            let gx = (sin(s*1.1)*0.5+0.5)*Double(mapW)
            let gy = (cos(s*0.6)*0.5+0.5)*Double(bCalvario)
            let a  = 0.15+sin(t*1.8+s*1.1)*0.20; let r = 2.0+sin(s*5.2)*1.2
            ctx.fill(Path(ellipseIn:CGRect(x:gx-r,y:gy-r,width:r*2,height:r*2)),with:.color(gC.opacity(a)))
        }
    }

    private func drawCandleFlicker(_ ctx: inout GraphicsContext, t: Double) {
        let fC = Color(hex:0xFF8822); let yC = Color(hex:0xFFDD44)
        // Candle near Jerusalem (Last Supper area)
        for fl in 0..<4 {
            let fd  = Double(fl)
            let fx  = 195.0 + sin(t*4.0+fd*1.3)*5; let fy = 1078.0 - 10 - fd*6
            let h   = 14.0 - fd*2.5; let a = 0.65 - fd*0.13
            ctx.fill(Path(ellipseIn:CGRect(x:fx-5,y:fy-h,width:10,height:h*1.6)),with:.color(fC.opacity(a)))
            ctx.fill(Path(ellipseIn:CGRect(x:fx-3,y:fy-h*0.6,width:6,height:h*0.9)),with:.color(yC.opacity(a*0.55)))
        }
    }

    // MARK: ── DIRT PATH ───────────────────────────────────────────────────────

    private func drawDirtPath(_ ctx: inout GraphicsContext) {
        let pts = TrailViewModel.nodePositions
        let doneEdge   = Color(hex:0xD4A840)
        let doneCenter = Color(hex:0xF0C860)
        let pendEdge   = Color(hex:0xA08030)
        let pendCenter = Color(hex:0xC0A050)
        for i in 0..<pts.count-1 {
            let a = pts[i]; let b = pts[i+1]
            let ctrl = CGPoint(x:(a.x+b.x)*0.5, y:min(a.y,b.y)-20)
            let done = i < vm.completedCount
            let seg  = quadP(a, ctrl, b)
            ctx.stroke(seg, with:.color(.black.opacity(0.18)), style:StrokeStyle(lineWidth:13,lineCap:.round))
            ctx.stroke(seg, with:.color(done ? doneEdge : pendEdge),
                       style:StrokeStyle(lineWidth:11, lineCap:.round))
            ctx.stroke(seg, with:.color(done ? doneCenter : pendCenter),
                       style:StrokeStyle(lineWidth:6, lineCap:.round))
            if done {
                ctx.stroke(seg, with:.color(Color(hex:0xFFE080).opacity(0.60)),
                           style:StrokeStyle(lineWidth:2, lineCap:.round, dash:[6,18]))
            }
        }
    }

    private func quadP(_ a:CGPoint,_ c:CGPoint,_ b:CGPoint)->Path {
        var p=Path(); p.move(to:a); p.addQuadCurve(to:b,control:c); return p
    }

    // MARK: ── BIOME BANNERS ────────────────────────────────────────────────────

    private var biomeBanners: some View {
        let items: [(String,String,CGFloat)] = [
            ("✨","GLÓRIA E RESSURREIÇÃO", bCalvario*0.18+22),
            ("✝️","CALVÁRIO",              bCalvario+24),
            ("🌿","JERUSALÉM",             bJerusalem+24),
            ("⛰️","MINISTÉRIO",            bMinisterio+24),
            ("🐟","GALILEIA",              bGalileia+24),
            ("🌟","NAZARÉ E BELÉM",        bNazare+24),
        ]
        return ZStack(alignment:.topLeading) {
            ForEach(items.indices,id:\.self) { i in
                HStack(spacing:5) {
                    Text(items[i].0).font(.system(size:12))
                    Text(items[i].1).font(.system(size:9,weight:.heavy,design:.rounded)).kerning(1.4).foregroundColor(.white.opacity(0.90))
                }
                .padding(.horizontal,10).padding(.vertical,4)
                .background(Capsule().fill(.black.opacity(0.35)).overlay(Capsule().stroke(.white.opacity(0.20),lineWidth:1)))
                .position(x:mapW/2,y:items[i].2)
            }
        }
    }

    // MARK: ── NODES + CHARACTER ───────────────────────────────────────────────

    private var nodesLayer: some View {
        ZStack(alignment:.topLeading) {
            ForEach(vm.nodes.indices,id:\.self) { i in
                TrailNodeBtn(node:vm.nodes[i]) {
                    if vm.nodes[i].status != .locked { selectedNodeIndex = i }
                }
                .position(TrailViewModel.nodePositions[i])
            }
        }
    }

    private var charLayer: some View {
        ZStack {
            Ellipse()
                .fill(.black.opacity(0.20))
                .frame(width:48, height:10)
                .blur(radius:4)
                .offset(y: 38)
            Image(systemName:"arrowtriangle.down.fill")
                .font(.system(size:11, weight:.black))
                .foregroundColor(.white)
                .shadow(color:.black.opacity(0.45), radius:2)
                .offset(y: -(NR + 22) + charBob)
            ShepherdFigure(isWalking: isWalking, facingRight: walkFacingRight)
                .offset(y: charBob * 0.5)
        }
        .animation(.spring(response:0.85, dampingFraction:0.62), value:vm.characterNodeIndex)
        .position(vm.characterPosition)
        .id("echar")
        .onChange(of: vm.characterNodeIndex) { newIdx in
            let pts = TrailViewModel.nodePositions
            let prevIdx = max(0, newIdx - 1)
            if prevIdx < pts.count && newIdx < pts.count {
                walkFacingRight = pts[newIdx].x >= pts[prevIdx].x
            }
            isWalking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                isWalking = false
            }
        }
    }
}
