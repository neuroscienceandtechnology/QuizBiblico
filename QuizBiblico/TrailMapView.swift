import SwiftUI

// MARK: - Constants

private let mapW: CGFloat = 390
private let mapH: CGFloat = 2600
private let NR:   CGFloat = 46

private let bCanaan:     CGFloat = 0
private let bSinai:      CGFloat = 450
private let bEgypt:      CGFloat = 760
private let bPatriarchs: CGFloat = 1190
private let bFlood:      CGFloat = 1680
private let bEden:       CGFloat = 2145

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
                        withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) { charBob = -10 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
            .toolbarBackground(Color(hex: 0x0A4D0A), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: Binding(get: { selectedNodeIndex != nil },
                                        set: { if !$0 { selectedNodeIndex = nil } })) {
                if let i = selectedNodeIndex {
                    TrailStudyView(node: vm.nodes[i], nodeIndex: i) { vm.completeNode(index: i) }
                }
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
            Canvas { ctx, _ in drawRoad(&ctx) }.frame(width: mapW, height: mapH).allowsHitTesting(false)
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
        // Biome base fills
        gradStop(&ctx, y: bEden,       h: mapH-bEden,         c0:Color(hex:0x0A3A0A), c1:Color(hex:0x145A14), c2:Color(hex:0x1E7A1E))
        gradStop(&ctx, y: bFlood,      h: bEden-bFlood,       c0:Color(hex:0x060E2A), c1:Color(hex:0x0C2060), c2:Color(hex:0x163A8A))
        gradStop(&ctx, y: bPatriarchs, h: bFlood-bPatriarchs, c0:Color(hex:0x3A2208), c1:Color(hex:0x5C380E), c2:Color(hex:0x7A5018))
        gradStop(&ctx, y: bEgypt,      h: bPatriarchs-bEgypt, c0:Color(hex:0x7A3008), c1:Color(hex:0xA04010), c2:Color(hex:0xC05818))
        gradStop(&ctx, y: bSinai,      h: bEgypt-bSinai,      c0:Color(hex:0xA07010), c1:Color(hex:0xC89018), c2:Color(hex:0xE0B030))
        gradStop(&ctx, y: bCanaan,     h: bSinai-bCanaan,     c0:Color(hex:0x3CB84A), c1:Color(hex:0x52D060), c2:Color(hex:0x68E878))

        // Smooth 280-px blend zones centered on each biome boundary.
        // Upper color = bottom of the biome above; lower color = top of the biome below.
        let bH: CGFloat = 280
        blendZone(&ctx, y: bSinai,      upper: Color(hex:0x68E878), lower: Color(hex:0xA07010), h: bH)
        blendZone(&ctx, y: bEgypt,      upper: Color(hex:0xE0B030), lower: Color(hex:0x7A3008), h: bH)
        blendZone(&ctx, y: bPatriarchs, upper: Color(hex:0xC05818), lower: Color(hex:0x3A2208), h: bH)
        blendZone(&ctx, y: bFlood,      upper: Color(hex:0x7A5018), lower: Color(hex:0x060E2A), h: bH)
        blendZone(&ctx, y: bEden,       upper: Color(hex:0x163A8A), lower: Color(hex:0x0A3A0A), h: bH)

        // Side vignettes
        ctx.fill(Path(CGRect(x:0,      y:0,width:48,height:mapH)), with:.color(.black.opacity(0.28)))
        ctx.fill(Path(CGRect(x:mapW-48,y:0,width:48,height:mapH)), with:.color(.black.opacity(0.28)))
    }

    private func gradStop(_ ctx: inout GraphicsContext, y:CGFloat, h:CGFloat, c0:Color, c1:Color, c2:Color) {
        let mid = y + h*0.5
        ctx.fill(Path(CGRect(x:0,y:y,width:mapW,height:h*0.5)),
                 with:.linearGradient(Gradient(colors:[c0,c1]),startPoint:CGPoint(x:mapW/2,y:y),endPoint:CGPoint(x:mapW/2,y:mid)))
        ctx.fill(Path(CGRect(x:0,y:mid,width:mapW,height:h*0.5)),
                 with:.linearGradient(Gradient(colors:[c1,c2]),startPoint:CGPoint(x:mapW/2,y:mid),endPoint:CGPoint(x:mapW/2,y:y+h)))
    }

    // Draws a smooth gradient rectangle centered on `y`, fusing the colour above into the colour below.
    private func blendZone(_ ctx: inout GraphicsContext, y: CGFloat, upper: Color, lower: Color, h: CGFloat) {
        let top = y - h / 2
        let grad = Gradient(colors: [upper, lower])
        ctx.fill(Path(CGRect(x: 0, y: top, width: mapW, height: h)),
                 with: .linearGradient(grad,
                                       startPoint: CGPoint(x: mapW/2, y: top),
                                       endPoint:   CGPoint(x: mapW/2, y: top + h)))
    }

    // MARK: ── STORY ART ──────────────────────────────────────────────────────

    private func drawStoryArt(_ ctx: inout GraphicsContext) {
        drawCanaanArt(&ctx)
        drawSinaiArt(&ctx)
        drawEgyptArt(&ctx)
        drawPatriarchsArt(&ctx)
        drawFloodArt(&ctx)
        drawEdenArt(&ctx)
    }

    // ── Canaan: uvas gigantes + muros de Jericó + flores + frutos ──

    private func drawCanaanArt(_ ctx: inout GraphicsContext) {
        drawFlowers(&ctx, zone: 0..<450)
        drawGrapeCluster(&ctx, cx: 318, cy: 155)
        drawFruitTree(&ctx, cx: 315, cy: 415)
        drawJerichoWalls(&ctx, cx: 88, cy: 305)
    }

    private func drawFlowers(_ ctx: inout GraphicsContext, zone: Range<Int>) {
        let seeds: [(Double,Double,UInt32)] = [
            (70,50,0xFF66AA),(280,80,0xFFCC33),(340,230,0xFF4488),
            (55,170,0xFFAA22),(350,350,0xFF66AA),(60,390,0x88FF44),
            (310,310,0xFFDD00),(245,420,0xFF88CC),(170,35,0xAAFF44),
        ]
        for (fx,fy,col) in seeds {
            guard Int(fy) >= zone.lowerBound && Int(fy) < zone.upperBound else { continue }
            let stemC = Color(hex:0x2A8A18)
            var stem = Path()
            stem.move(to:CGPoint(x:fx,y:fy)); stem.addLine(to:CGPoint(x:fx,y:fy-18))
            ctx.stroke(stem,with:.color(stemC),lineWidth:2)
            let fc = Color(hex:col)
            for a in stride(from:0.0,to:360.0,by:72.0) {
                let rad = a * .pi / 180
                let px = fx + cos(rad)*7; let py = fy - 18 + sin(rad)*7
                ctx.fill(Path(ellipseIn:CGRect(x:px-5,y:py-5,width:10,height:8)),with:.color(fc.opacity(0.85)))
            }
            ctx.fill(Path(ellipseIn:CGRect(x:fx-4,y:fy-22,width:8,height:8)),with:.color(Color(hex:0xFFFF88).opacity(0.9)))
        }
    }

    private func drawGrapeCluster(_ ctx: inout GraphicsContext, cx: Double, cy: Double) {
        let positions: [(Double,Double)] = [
            (0,0),(-20,-19),(20,-19),(-10,-38),(10,-38),
            (0,-57),(-20,-57),(20,-57),(-11,-76),(11,-76),(0,-95)
        ]
        let shadow = Color.black.opacity(0.22)
        let grape  = Color(hex:0x5C1A8C)
        let hi     = Color(hex:0xBB88EE)
        // shadow pass
        for (dx,dy) in positions {
            ctx.fill(Path(ellipseIn:CGRect(x:cx+dx-14+3,y:cy+dy-14+3,width:28,height:28)),with:.color(shadow))
        }
        // grape pass
        for (dx,dy) in positions {
            ctx.fill(Path(ellipseIn:CGRect(x:cx+dx-14,y:cy+dy-14,width:28,height:28)),with:.color(grape.opacity(0.92)))
            ctx.fill(Path(ellipseIn:CGRect(x:cx+dx-8, y:cy+dy-11,width:9,  height:7 )),with:.color(hi.opacity(0.45)))
        }
        // vine stem
        var stem = Path()
        stem.move(to:CGPoint(x:cx,y:cy-95))
        stem.addCurve(to:CGPoint(x:cx+28,y:cy-130),
                      control1:CGPoint(x:cx+8, y:cy-110),
                      control2:CGPoint(x:cx+20,y:cy-122))
        ctx.stroke(stem,with:.color(Color(hex:0x3D7A10).opacity(0.9)),lineWidth:4)
        // leaf
        ctx.fill(Path(ellipseIn:CGRect(x:cx+22,y:cy-140,width:22,height:14)),with:.color(Color(hex:0x3D7A10).opacity(0.75)))
    }

    private func drawFruitTree(_ ctx: inout GraphicsContext, cx: Double, cy: Double) {
        let trunkC = Color(hex:0x5C2E00)
        let leafC  = Color(hex:0x1E7A10)
        let fruitC = Color(hex:0xE83020)
        ctx.fill(Path(CGRect(x:cx-6,y:cy-70,width:12,height:70)),with:.color(trunkC.opacity(0.85)))
        for (r,dx,dy) in [(38.0,0.0,0.0),(32.0,-20.0,-15.0),(32.0,20.0,-15.0),(26.0,0.0,-28.0)] {
            ctx.fill(Path(ellipseIn:CGRect(x:cx+dx-r,y:cy+dy-r-38,width:r*2,height:r*2)),with:.color(leafC.opacity(0.80)))
        }
        for (fx,fy) in [(cx-12,cy-65),(cx+10,cy-60),(cx,cy-80),(cx-5,cy-50)] {
            ctx.fill(Path(ellipseIn:CGRect(x:fx-5,y:fy-5,width:10,height:10)),with:.color(fruitC.opacity(0.90)))
        }
    }

    private func drawJerichoWalls(_ ctx: inout GraphicsContext, cx: Double, cy: Double) {
        let sandC = Color(hex:0xC4A660)
        let darkC = Color(hex:0x8B7040)
        // Corner towers
        for tx in [cx-72.0, cx+44.0] {
            ctx.fill(Path(CGRect(x:tx,   y:cy-95,width:30,height:95)),with:.color(sandC.opacity(0.90)))
            ctx.fill(Path(CGRect(x:tx+18,y:cy-95,width:12,height:95)),with:.color(darkC.opacity(0.30)))
            for j in 0..<3 {
                ctx.fill(Path(CGRect(x:tx+Double(j)*9,y:cy-110,width:7,height:16)),with:.color(sandC.opacity(0.90)))
            }
        }
        // Main wall
        ctx.fill(Path(CGRect(x:cx-42,y:cy-60,width:88,height:60)),with:.color(sandC.opacity(0.85)))
        ctx.fill(Path(CGRect(x:cx+20,y:cy-60,width:26,height:60)),with:.color(darkC.opacity(0.25)))
        // Merlons
        for i in 0..<5 {
            ctx.fill(Path(CGRect(x:cx-40+Double(i)*18,y:cy-78,width:11,height:20)),with:.color(sandC.opacity(0.90)))
        }
        // Gate arch
        var gate = Path()
        gate.move(to:CGPoint(x:cx-13,y:cy))
        gate.addLine(to:CGPoint(x:cx-13,y:cy-34))
        gate.addArc(center:CGPoint(x:cx,y:cy-34),radius:13,
                    startAngle:.degrees(180),endAngle:.degrees(0),clockwise:false)
        gate.addLine(to:CGPoint(x:cx+13,y:cy))
        ctx.fill(gate,with:.color(.black.opacity(0.60)))
    }

    // ── Sinai: tábuas + Mar Vermelho se abrindo ──

    private func drawSinaiArt(_ ctx: inout GraphicsContext) {
        drawMountainSinai(&ctx)
        drawStoneTabs(&ctx, cx: 195, cy: 496)
        drawPartedSea(&ctx)
        drawLightningBolts(&ctx)
    }

    private func drawMountainSinai(_ ctx: inout GraphicsContext) {
        let mC = Color(hex:0x6A4410)
        var mt = Path()
        mt.move(to:CGPoint(x:60,y:bEgypt-4))
        mt.addLine(to:CGPoint(x:195,y:bSinai+60))
        mt.addLine(to:CGPoint(x:330,y:bEgypt-4))
        mt.closeSubpath()
        ctx.fill(mt,with:.color(mC.opacity(0.70)))
        var snow = Path()
        snow.move(to:CGPoint(x:172,y:bSinai+78))
        snow.addLine(to:CGPoint(x:195,y:bSinai+60))
        snow.addLine(to:CGPoint(x:218,y:bSinai+78))
        snow.closeSubpath()
        ctx.fill(snow,with:.color(.white.opacity(0.55)))
    }

    private func drawStoneTabs(_ ctx: inout GraphicsContext, cx: Double, cy: Double) {
        let stoneC = Color(hex:0xB0946A)
        let lineC  = Color.black.opacity(0.28)
        for tx in [cx-46.0, cx+6.0] {
            var tab = Path()
            tab.move(to:CGPoint(x:tx,    y:cy))
            tab.addLine(to:CGPoint(x:tx,  y:cy-54))
            tab.addArc(center:CGPoint(x:tx+20,y:cy-54),radius:20,
                       startAngle:.degrees(180),endAngle:.degrees(0),clockwise:false)
            tab.addLine(to:CGPoint(x:tx+40,y:cy))
            tab.closeSubpath()
            ctx.fill(tab,with:.color(stoneC.opacity(0.90)))
            ctx.stroke(tab,with:.color(.black.opacity(0.18)),lineWidth:1.5)
            for row in 0..<4 {
                var ln = Path()
                ln.move(to:CGPoint(x:tx+6, y:cy-44+Double(row)*10))
                ln.addLine(to:CGPoint(x:tx+34,y:cy-44+Double(row)*10))
                ctx.stroke(ln,with:.color(lineC),lineWidth:1.5)
            }
        }
    }

    private func drawPartedSea(_ ctx: inout GraphicsContext) {
        let cy: Double = 722; let cx: Double = 195
        let seaC  = Color(hex:0x1252A0)
        let foamC = Color(hex:0x88CCFF)
        let sandC = Color(hex:0xC8A870)
        let deepC = Color(hex:0x0A3070)
        // Left water wall
        var lw = Path()
        lw.move(to:CGPoint(x:0,y:cy+55))
        lw.addCurve(to:CGPoint(x:cx-52,y:cy-62),
                    control1:CGPoint(x:90, y:cy+35),
                    control2:CGPoint(x:cx-85,y:cy-10))
        lw.addCurve(to:CGPoint(x:cx-38,y:cy-80),
                    control1:CGPoint(x:cx-52,y:cy-62),
                    control2:CGPoint(x:cx-44,y:cy-72))
        lw.addLine(to:CGPoint(x:0,y:cy-80))
        lw.closeSubpath()
        ctx.fill(lw,with:.color(seaC.opacity(0.88)))
        // Right water wall
        var rw = Path()
        rw.move(to:CGPoint(x:mapW,y:cy+55))
        rw.addCurve(to:CGPoint(x:cx+52,y:cy-62),
                    control1:CGPoint(x:mapW-90,y:cy+35),
                    control2:CGPoint(x:cx+85,  y:cy-10))
        rw.addCurve(to:CGPoint(x:cx+38,y:cy-80),
                    control1:CGPoint(x:cx+52,y:cy-62),
                    control2:CGPoint(x:cx+44,y:cy-72))
        rw.addLine(to:CGPoint(x:mapW,y:cy-80))
        rw.closeSubpath()
        ctx.fill(rw,with:.color(seaC.opacity(0.88)))
        // Deep water tones on walls
        var ldepth = Path()
        ldepth.move(to:CGPoint(x:0,y:cy+55)); ldepth.addLine(to:CGPoint(x:50,y:cy+55))
        ldepth.addLine(to:CGPoint(x:50,y:cy-80)); ldepth.addLine(to:CGPoint(x:0,y:cy-80))
        ldepth.closeSubpath()
        ctx.fill(ldepth,with:.color(deepC.opacity(0.40)))
        var rdepth = Path()
        rdepth.move(to:CGPoint(x:mapW,y:cy+55)); rdepth.addLine(to:CGPoint(x:mapW-50,y:cy+55))
        rdepth.addLine(to:CGPoint(x:mapW-50,y:cy-80)); rdepth.addLine(to:CGPoint(x:mapW,y:cy-80))
        rdepth.closeSubpath()
        ctx.fill(rdepth,with:.color(deepC.opacity(0.40)))
        // Foam crests
        for fo in [(cx-52,cy-62),(cx-44,cy-74),(cx+52,cy-62),(cx+44,cy-74)] {
            ctx.fill(Path(ellipseIn:CGRect(x:fo.0-14,y:fo.1-6,width:28,height:12)),with:.color(foamC.opacity(0.55)))
        }
        // Dry sea bed path
        var dry = Path()
        dry.move(to:CGPoint(x:cx-50,y:cy+58))
        dry.addLine(to:CGPoint(x:cx+50,y:cy+58))
        dry.addLine(to:CGPoint(x:cx+36,y:cy-82))
        dry.addLine(to:CGPoint(x:cx-36,y:cy-82))
        dry.closeSubpath()
        ctx.fill(dry,with:.color(sandC.opacity(0.65)))
        // Small people silhouettes crossing
        for px in [cx-18.0, cx, cx+18.0] {
            ctx.fill(Path(ellipseIn:CGRect(x:px-4,y:cy-10,width:8,height:8)),with:.color(.black.opacity(0.45)))
            ctx.fill(Path(CGRect(x:px-2,y:cy-2,width:4,height:14)),with:.color(.black.opacity(0.38)))
        }
    }

    private func drawLightningBolts(_ ctx: inout GraphicsContext) {
        let lc = Color(hex:0xFFFF88)
        for (sx,sy,ex,ey) in [(185.0,bSinai+65.0,173.0,bSinai+92.0),
                               (205.0,bSinai+65.0,218.0,bSinai+92.0)] {
            var b = Path()
            b.move(to:CGPoint(x:sx,y:sy))
            b.addLine(to:CGPoint(x:ex,y:ey))
            ctx.stroke(b,with:.color(lc.opacity(0.80)),lineWidth:2.5)
        }
    }

    // ── Egito: Nilo de sangue + rãs + escuridão + arbusto em chamas ──

    private func drawEgyptArt(_ ctx: inout GraphicsContext) {
        drawDarknessCloud(&ctx)
        drawBloodNile(&ctx)
        drawFrogs(&ctx)
        drawBurningBushStatic(&ctx)
        drawEgyptPylons(&ctx)
    }

    private func drawDarknessCloud(_ ctx: inout GraphicsContext) {
        let dc = Color.black.opacity(0.50)
        ctx.fill(Path(CGRect(x:0,y:bEgypt,width:mapW,height:140)),with:.color(dc))
        // Lighter gradient edge at bottom of darkness
        ctx.fill(Path(CGRect(x:0,y:bEgypt+110,width:mapW,height:55)),
                 with:.linearGradient(Gradient(colors:[.black.opacity(0.50),.clear]),
                                      startPoint:CGPoint(x:mapW/2,y:bEgypt+110),
                                      endPoint:CGPoint(x:mapW/2,y:bEgypt+165)))
    }

    private func drawBloodNile(_ ctx: inout GraphicsContext) {
        let rc  = Color(hex:0xBB0000)
        let rc2 = Color(hex:0xFF4444)
        var river = Path()
        river.move(to:CGPoint(x:0,y:1008))
        river.addCurve(to:CGPoint(x:mapW,y:998),
                       control1:CGPoint(x:110,y:975),
                       control2:CGPoint(x:280,y:1028))
        ctx.stroke(river,with:.color(rc.opacity(0.80)), lineWidth:34)
        ctx.stroke(river,with:.color(rc2.opacity(0.38)),lineWidth:14)
        ctx.stroke(river,with:.color(Color(hex:0xFF8888).opacity(0.25)),lineWidth:5)
    }

    private func drawFrogs(_ ctx: inout GraphicsContext) {
        for (fx,fy) in [(62.0,868.0),(128.0,852.0),(298.0,864.0),(340.0,876.0),(188.0,882.0)] {
            drawFrog(&ctx, cx:fx, cy:fy)
        }
    }

    private func drawFrog(_ ctx: inout GraphicsContext, cx: Double, cy: Double) {
        let gc = Color(hex:0x2E7A28)
        ctx.fill(Path(ellipseIn:CGRect(x:cx-13,y:cy-9, width:26,height:18)),with:.color(gc.opacity(0.80)))
        ctx.fill(Path(ellipseIn:CGRect(x:cx-10,y:cy-20,width:20,height:14)),with:.color(gc.opacity(0.80)))
        ctx.fill(Path(ellipseIn:CGRect(x:cx-10,y:cy-25,width:6,height:6)),with:.color(Color(hex:0xFF8800).opacity(0.85)))
        ctx.fill(Path(ellipseIn:CGRect(x:cx+4, y:cy-25,width:6,height:6)),with:.color(Color(hex:0xFF8800).opacity(0.85)))
        for (lx,ly) in [(-18.0,3.0),(-14.0,9.0),(18.0,3.0),(14.0,9.0)] {
            var leg = Path()
            leg.move(to:CGPoint(x:cx+lx*0.4,y:cy+ly*0.4))
            leg.addLine(to:CGPoint(x:cx+lx,y:cy+ly))
            ctx.stroke(leg,with:.color(gc.opacity(0.75)),lineWidth:3)
        }
    }

    private func drawBurningBushStatic(_ ctx: inout GraphicsContext) {
        let cx = 82.0; let cy = 1100.0
        let bC = Color(hex:0x5A3210)
        for (bx,by) in [(cx-16,cy),(cx,cy-12),(cx+16,cy),(cx-8,cy-22),(cx+8,cy-22)] {
            ctx.fill(Path(ellipseIn:CGRect(x:bx-16,y:by-14,width:32,height:28)),with:.color(bC.opacity(0.72)))
        }
    }

    private func drawEgyptPylons(_ ctx: inout GraphicsContext) {
        let pC = Color(hex:0x7A4E18)
        let lC = Color(hex:0xC89040)
        for (px,pw,ph) in [(42.0,52.0,120.0),(296.0,58.0,100.0)] {
            // Tapered pylon: wide at base, narrow at top
            var py2 = Path()
            py2.move(to:CGPoint(x:px,      y:bPatriarchs-4))
            py2.addLine(to:CGPoint(x:px+8, y:bPatriarchs-4-ph))
            py2.addLine(to:CGPoint(x:px+pw-8,y:bPatriarchs-4-ph))
            py2.addLine(to:CGPoint(x:px+pw, y:bPatriarchs-4))
            py2.closeSubpath()
            ctx.fill(py2,with:.color(pC.opacity(0.72)))
            ctx.fill(Path(CGRect(x:px+pw*0.5,y:bPatriarchs-4-ph,width:pw*0.5,height:ph)),
                     with:.color(lC.opacity(0.22)))
        }
    }

    // ── Patriarcas: sonho de José + escada de Jacó + tendas de Abraão ──

    private func drawPatriarchsArt(_ ctx: inout GraphicsContext) {
        drawJosephDream(&ctx)
        drawJacobLadder(&ctx)
        drawAbrahamTents(&ctx)
        drawWheatSheaves(&ctx)
    }

    private func drawJosephDream(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 1240.0
        // Sun glow rings
        let sunC  = Color(hex:0xFFCC00)
        let glowC = Color(hex:0xFFAA00)
        for ring in 0..<4 {
            let r = 26.0 + Double(ring)*9
            let a = 0.40 - Double(ring)*0.08
            ctx.fill(Path(ellipseIn:CGRect(x:cx-r,y:cy-r,width:r*2,height:r*2)),with:.color(glowC.opacity(a)))
        }
        ctx.fill(Path(ellipseIn:CGRect(x:cx-22,y:cy-22,width:44,height:44)),with:.color(sunC.opacity(0.92)))
        // Sun rays
        for i in 0..<12 {
            let angle = Double(i) * 30.0 * .pi / 180.0
            let x1 = cx + cos(angle)*27; let y1 = cy + sin(angle)*27
            let x2 = cx + cos(angle)*44; let y2 = cy + sin(angle)*44
            var ray = Path(); ray.move(to:CGPoint(x:x1,y:y1)); ray.addLine(to:CGPoint(x:x2,y:y2))
            ctx.stroke(ray,with:.color(sunC.opacity(0.70)),lineWidth:2)
        }
        // Crescent moon (left)
        let mC = Color(hex:0xEEEECC)
        let maskC = Color(hex:0x5C380E) // same as background mid-tone
        let moonX = cx - 90.0; let moonY = cy - 18.0
        ctx.fill(Path(ellipseIn:CGRect(x:moonX-18,y:moonY-18,width:36,height:36)),with:.color(mC.opacity(0.88)))
        ctx.fill(Path(ellipseIn:CGRect(x:moonX-8, y:moonY-18,width:36,height:36)),with:.color(maskC.opacity(0.95)))
        // 11 stars around
        let starC = Color(hex:0xFFFFBB)
        for i in 0..<11 {
            let ang = (Double(i)/11.0*2.0 - 0.25) * .pi
            let sx = cx + cos(ang)*72; let sy = cy + 55 + sin(ang)*28
            ctx.fill(Path(ellipseIn:CGRect(x:sx-5,y:sy-5,width:10,height:10)),with:.color(starC.opacity(0.88)))
            // 4-point star effect
            for sa in [0.0,90.0,180.0,270.0] {
                let sr = sa * .pi/180
                var sl = Path()
                sl.move(to:CGPoint(x:sx,y:sy))
                sl.addLine(to:CGPoint(x:sx+cos(sr)*8,y:sy+sin(sr)*8))
                ctx.stroke(sl,with:.color(starC.opacity(0.40)),lineWidth:1)
            }
        }
    }

    private func drawJacobLadder(_ ctx: inout GraphicsContext) {
        let x1 = 318.0; let y1 = 1492.0; let x2 = 338.0; let y2 = 1295.0
        let ladderC = Color(hex:0xC8A060)
        let glowC   = Color(hex:0xFFEEAA)
        // Glow at top
        for ring in 0..<3 {
            let r = 18.0 + Double(ring)*10
            ctx.fill(Path(ellipseIn:CGRect(x:x2-r,y:y2-r,width:r*2,height:r*2)),
                     with:.color(glowC.opacity(0.18-Double(ring)*0.05)))
        }
        // Ladder rails
        var l1 = Path(); l1.move(to:CGPoint(x:x1-10,y:y1)); l1.addLine(to:CGPoint(x:x2-10,y:y2))
        var l2 = Path(); l2.move(to:CGPoint(x:x1+10,y:y1)); l2.addLine(to:CGPoint(x:x2+10,y:y2))
        ctx.stroke(l1,with:.color(ladderC.opacity(0.80)),lineWidth:3)
        ctx.stroke(l2,with:.color(ladderC.opacity(0.80)),lineWidth:3)
        // Rungs
        let steps = 8
        for i in 0...steps {
            let t = Double(i)/Double(steps)
            let rx = x1 + (x2-x1)*t; let ry = y1 + (y2-y1)*t
            var rung = Path()
            rung.move(to:CGPoint(x:rx-10,y:ry)); rung.addLine(to:CGPoint(x:rx+10,y:ry))
            ctx.stroke(rung,with:.color(ladderC.opacity(0.75)),lineWidth:2.5)
        }
        // Angel silhouettes (simple)
        for (ax,ay) in [(x2-20,y2+25),(x2+15,y2+40)] {
            ctx.fill(Path(ellipseIn:CGRect(x:ax-5,y:ay-5,width:10,height:10)),with:.color(glowC.opacity(0.65)))
            ctx.fill(Path(CGRect(x:ax-2,y:ay+5,width:4,height:12)),with:.color(glowC.opacity(0.55)))
        }
    }

    private func drawAbrahamTents(_ ctx: inout GraphicsContext) {
        let tC = Color(hex:0x8B5E20)
        for (tx,ty,tw) in [(80.0,1650.0,60.0),(155.0,1658.0,44.0)] {
            var tent = Path()
            tent.move(to:CGPoint(x:tx,     y:ty))
            tent.addLine(to:CGPoint(x:tx+tw/2,y:ty-35))
            tent.addLine(to:CGPoint(x:tx+tw,  y:ty))
            tent.closeSubpath()
            ctx.fill(tent,with:.color(tC.opacity(0.75)))
            ctx.fill(Path(CGRect(x:tx+tw*0.4,y:ty-30,width:tw*0.2,height:30)),with:.color(.black.opacity(0.40)))
        }
    }

    private func drawWheatSheaves(_ ctx: inout GraphicsContext) {
        let wC = Color(hex:0xE0B840)
        for (wx,wy) in [(265.0,1288.0),(290.0,1292.0),(315.0,1285.0)] {
            for i in -2...2 {
                var stalk = Path()
                stalk.move(to:CGPoint(x:wx+Double(i)*4,y:wy))
                stalk.addCurve(to:CGPoint(x:wx+Double(i)*6,y:wy-30),
                               control1:CGPoint(x:wx+Double(i)*4,y:wy-15),
                               control2:CGPoint(x:wx+Double(i)*5,y:wy-22))
                ctx.stroke(stalk,with:.color(wC.opacity(0.80)),lineWidth:1.5)
                ctx.fill(Path(ellipseIn:CGRect(x:wx+Double(i)*6-4,y:wy-38,width:8,height:12)),
                         with:.color(wC.opacity(0.85)))
            }
            // Tie
            ctx.stroke(Path(ellipseIn:CGRect(x:wx-10,y:wy-12,width:20,height:8)),
                       with:.color(Color(hex:0x8B6010).opacity(0.70)),lineWidth:2)
        }
    }

    // ── Dilúvio: Arca + arco-íris + pomba + Torre de Babel ──

    private func drawFloodArt(_ ctx: inout GraphicsContext) {
        drawBabelTower(&ctx)
        drawDetailedArk(&ctx)
        drawRainbow(&ctx)
        drawDove(&ctx)
    }

    private func drawBabelTower(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let base = 1858.0
        let bC  = Color(hex:0x8B6914)
        let lC  = Color(hex:0xC89A2A)
        let sdC = Color.black.opacity(0.22)
        for i in 0..<7 {
            let w  = CGFloat(115 - i*14)
            let lv = base - Double(i) * 25.0
            let rect = CGRect(x:CGFloat(cx)-w/2, y:CGFloat(lv)-22, width:w, height:22)
            ctx.fill(Path(rect),with:.color(bC.opacity(0.88)))
            let lRect = CGRect(x:CGFloat(cx),y:CGFloat(lv)-22,width:w/2,height:22)
            ctx.fill(Path(lRect),with:.color(lC.opacity(0.28)))
            var line = Path()
            line.move(to:CGPoint(x:CGFloat(cx)-w/2,y:CGFloat(lv)-22))
            line.addLine(to:CGPoint(x:CGFloat(cx)+w/2,y:CGFloat(lv)-22))
            ctx.stroke(line,with:.color(sdC),lineWidth:1)
        }
        // Flag/flame at top
        let topY = base - 7*25.0 - 18
        ctx.fill(Path(ellipseIn:CGRect(x:CGFloat(cx)-6,y:CGFloat(topY)-14,width:12,height:14)),
                 with:.color(Color(hex:0xFF6600).opacity(0.75)))
    }

    private func drawDetailedArk(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 2060.0
        let hC = Color(hex:0x6B3C10)
        let wC = Color(hex:0x8B4E18)
        let rC = Color(hex:0x5A2E08)
        // Hull with curve
        var hull = Path()
        hull.move(to:CGPoint(x:cx-72,y:cy))
        hull.addCurve(to:CGPoint(x:cx+72,y:cy),
                      control1:CGPoint(x:cx-72,y:cy+36),control2:CGPoint(x:cx+72,y:cy+36))
        hull.addLine(to:CGPoint(x:cx+60,y:cy-14))
        hull.addLine(to:CGPoint(x:cx-60,y:cy-14))
        hull.closeSubpath()
        ctx.fill(hull,with:.color(hC.opacity(0.90)))
        // Planks
        for i in 0..<3 {
            var plank = Path()
            plank.move(to:CGPoint(x:cx-60+Double(i)*5,y:cy-14))
            plank.addLine(to:CGPoint(x:cx-72+Double(i)*4,y:cy))
            ctx.stroke(plank,with:.color(.black.opacity(0.15)),lineWidth:1)
        }
        // Cabin
        ctx.fill(Path(CGRect(x:cx-38,y:cy-44,width:76,height:30)),with:.color(wC.opacity(0.88)))
        ctx.fill(Path(CGRect(x:cx+10,y:cy-44,width:28,height:30)),with:.color(Color(hex:0xA06020).opacity(0.30)))
        // Roof
        var roof = Path()
        roof.move(to:CGPoint(x:cx-42,y:cy-44))
        roof.addLine(to:CGPoint(x:cx,    y:cy-62))
        roof.addLine(to:CGPoint(x:cx+42, y:cy-44))
        roof.closeSubpath()
        ctx.fill(roof,with:.color(rC.opacity(0.88)))
        // Window
        ctx.fill(Path(ellipseIn:CGRect(x:cx-8,y:cy-56,width:16,height:12)),with:.color(Color(hex:0xAADDFF).opacity(0.60)))
    }

    private func drawRainbow(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 1948.0
        let arcData: [(UInt32, Double)] = [
            (0xFF2200,128),(0xFF8800,115),(0xFFDD00,102),
            (0x22CC00,89),(0x0066FF,76),(0x8800CC,63)
        ]
        for (col,r) in arcData {
            var arc = Path()
            arc.addArc(center:CGPoint(x:cx,y:cy), radius:CGFloat(r),
                       startAngle:.degrees(198), endAngle:.degrees(342), clockwise:false)
            ctx.stroke(arc,with:.color(Color(hex:col).opacity(0.75)),lineWidth:9)
        }
    }

    private func drawDove(_ ctx: inout GraphicsContext) {
        let dx = 310.0; let dy = 1990.0
        let dC = Color.white.opacity(0.85)
        var d = Path()
        d.move(to:CGPoint(x:dx,  y:dy))
        d.addCurve(to:CGPoint(x:dx-22,y:dy-8),
                   control1:CGPoint(x:dx-8, y:dy-14),
                   control2:CGPoint(x:dx-18,y:dy-12))
        d.addCurve(to:CGPoint(x:dx,y:dy),
                   control1:CGPoint(x:dx-20,y:dy-4),
                   control2:CGPoint(x:dx-10,y:dy+2))
        d.addCurve(to:CGPoint(x:dx+22,y:dy-8),
                   control1:CGPoint(x:dx+8, y:dy-14),
                   control2:CGPoint(x:dx+18,y:dy-12))
        d.addCurve(to:CGPoint(x:dx,y:dy),
                   control1:CGPoint(x:dx+20,y:dy-4),
                   control2:CGPoint(x:dx+10,y:dy+2))
        ctx.fill(d,with:.color(dC))
        ctx.fill(Path(ellipseIn:CGRect(x:dx-5,y:dy-14,width:10,height:10)),with:.color(dC))
        // Olive branch
        var branch = Path()
        branch.move(to:CGPoint(x:dx-2,y:dy+2))
        branch.addCurve(to:CGPoint(x:dx-16,y:dy+12),
                        control1:CGPoint(x:dx-8,y:dy+2),
                        control2:CGPoint(x:dx-14,y:dy+7))
        ctx.stroke(branch,with:.color(Color(hex:0x2E8A18).opacity(0.80)),lineWidth:2)
        ctx.fill(Path(ellipseIn:CGRect(x:dx-20,y:dy+9,width:8,height:5)),with:.color(Color(hex:0x3AB025).opacity(0.80)))
    }

    // ── Éden: árvore do conhecimento + serpente + luz da Criação ──

    private func drawEdenArt(_ ctx: inout GraphicsContext) {
        drawCreationLight(&ctx)
        drawTreeOfKnowledge(&ctx)
        drawSerpent(&ctx)
        drawAdamEve(&ctx)
    }

    private func drawCreationLight(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 2488.0
        let lC = Color(hex:0xFFEEAA)
        // Radial glow
        for ring in 0..<6 {
            let r = 30.0 + Double(ring)*20
            let a = 0.35 - Double(ring)*0.05
            ctx.fill(Path(ellipseIn:CGRect(x:cx-r,y:cy-r,width:r*2,height:r*2)),with:.color(lC.opacity(a)))
        }
        // Rays
        for i in 0..<16 {
            let angle = Double(i) * (360.0/16.0) * .pi/180
            let x1 = cx+cos(angle)*32; let y1 = cy+sin(angle)*32
            let x2 = cx+cos(angle)*90; let y2 = cy+sin(angle)*90
            var ray = Path(); ray.move(to:CGPoint(x:x1,y:y1)); ray.addLine(to:CGPoint(x:x2,y:y2))
            ctx.stroke(ray,with:.color(lC.opacity(0.35)),lineWidth:2)
        }
        ctx.fill(Path(ellipseIn:CGRect(x:cx-18,y:cy-18,width:36,height:36)),with:.color(Color(hex:0xFFFFDD).opacity(0.95)))
    }

    private func drawTreeOfKnowledge(_ ctx: inout GraphicsContext) {
        let cx = 195.0; let cy = 2295.0
        let trunkC = Color(hex:0x5C2E00)
        let leaf1C = Color(hex:0x0E5A0A)
        let leaf2C = Color(hex:0x168014)
        let fruitC = Color(hex:0xCC1800)
        // Trunk with roots
        var trunk = Path()
        trunk.move(to:CGPoint(x:cx-9,y:cy))
        trunk.addLine(to:CGPoint(x:cx-7,y:cy-80))
        trunk.addLine(to:CGPoint(x:cx+7,y:cy-80))
        trunk.addLine(to:CGPoint(x:cx+9,y:cy))
        trunk.closeSubpath()
        ctx.fill(trunk,with:.color(trunkC.opacity(0.88)))
        // Roots
        for (rx,ry) in [(-25.0,12.0),(25.0,12.0),(-40.0,6.0),(40.0,6.0)] {
            var root = Path()
            root.move(to:CGPoint(x:cx,y:cy))
            root.addCurve(to:CGPoint(x:cx+rx,y:cy+ry),
                          control1:CGPoint(x:cx+rx*0.4,y:cy),
                          control2:CGPoint(x:cx+rx*0.8,y:cy+ry*0.5))
            ctx.stroke(root,with:.color(trunkC.opacity(0.75)),lineWidth:3)
        }
        // Canopy layers
        for (r,dx,dy,c) in [(52.0,0.0,0.0,leaf1C),(44.0,-24.0,-18.0,leaf2C),
                            (44.0,24.0,-18.0,leaf1C),(36.0,0.0,-30.0,leaf2C)] {
            ctx.fill(Path(ellipseIn:CGRect(x:cx+dx-r,y:cy+dy-r-82,width:r*2,height:r*2)),
                     with:.color(c.opacity(0.82)))
        }
        // Forbidden fruit (apples)
        for (fx,fy) in [(cx-18,cy-120),(cx+14,cy-114),(cx-2,cy-140),(cx+8,cy-98)] {
            ctx.fill(Path(ellipseIn:CGRect(x:fx-8,y:fy-8,width:16,height:16)),with:.color(fruitC.opacity(0.92)))
            ctx.fill(Path(ellipseIn:CGRect(x:fx-3,y:fy-11,width:4,height:5)),with:.color(Color(hex:0x3A7A10).opacity(0.75)))
        }
    }

    private func drawSerpent(_ ctx: inout GraphicsContext) {
        let sC = Color(hex:0x2A5A10)
        var s = Path()
        s.move(to:CGPoint(x:220,y:2215))
        s.addCurve(to:CGPoint(x:228,y:2248),
                   control1:CGPoint(x:235,y:2222),control2:CGPoint(x:238,y:2242))
        s.addCurve(to:CGPoint(x:210,y:2268),
                   control1:CGPoint(x:218,y:2254),control2:CGPoint(x:210,y:2264))
        s.addCurve(to:CGPoint(x:225,y:2288),
                   control1:CGPoint(x:210,y:2272),control2:CGPoint(x:222,y:2283))
        ctx.stroke(s,with:.color(sC.opacity(0.75)),lineWidth:6)
        // Head
        ctx.fill(Path(ellipseIn:CGRect(x:215,y:2208,width:14,height:10)),with:.color(sC.opacity(0.80)))
        // Forked tongue
        var t = Path()
        t.move(to:CGPoint(x:222,y:2208))
        t.addLine(to:CGPoint(x:219,y:2201)); t.move(to:CGPoint(x:222,y:2208)); t.addLine(to:CGPoint(x:225,y:2201))
        ctx.stroke(t,with:.color(Color(hex:0xCC2200).opacity(0.75)),lineWidth:1.5)
    }

    private func drawAdamEve(_ ctx: inout GraphicsContext) {
        let sC = Color.black.opacity(0.40)
        for (fx,lx) in [(168.0,172.0),(222.0,218.0)] {
            ctx.fill(Path(ellipseIn:CGRect(x:fx-5,y:2360,width:10,height:10)),with:.color(sC))
            ctx.fill(Path(CGRect(x:fx-3,y:2370,width:6,height:18)),with:.color(sC))
            var leg = Path(); leg.move(to:CGPoint(x:lx,y:2388)); leg.addLine(to:CGPoint(x:lx-4,y:2404))
            leg.move(to:CGPoint(x:lx,y:2388)); leg.addLine(to:CGPoint(x:lx+4,y:2404))
            ctx.stroke(leg,with:.color(sC),lineWidth:2.5)
        }
    }

    // MARK: ── ANIMATED PARTICLES ────────────────────────────────────────────

    private func drawParticles(_ ctx: inout GraphicsContext, t: Double) {
        drawFirefliesAnim(&ctx, t:t)
        drawStarsAnim(&ctx, t:t)
        drawBushFireAnim(&ctx, t:t)
        drawRainAnim(&ctx, t:t)
        drawSandAnim(&ctx, t:t)
        drawLeavesAnim(&ctx, t:t)
    }

    private func drawFirefliesAnim(_ ctx: inout GraphicsContext, t: Double) {
        let glC = Color(hex:0xCCFF44); let coC = Color(hex:0xDDFF66)
        for i in 0..<18 {
            let s = Double(i)*83.6
            let bx = (sin(s*1.4)*0.5+0.5)*Double(mapW-30)+15
            let by = Double(bEden)+(cos(s*0.7)*0.5+0.5)*Double(mapH-bEden-55)+28
            let ex = bx+sin(t*0.9+s)*18; let ey = by+cos(t*0.7+s*1.2)*14
            let a  = max(0, 0.5+sin(t*2.0+s)*0.5); let r = 2.5+sin(s*4.3)
            ctx.fill(Path(ellipseIn:CGRect(x:ex-r*3,y:ey-r*3,width:r*6,height:r*6)),with:.color(glC.opacity(a*0.18)))
            ctx.fill(Path(ellipseIn:CGRect(x:ex-r,  y:ey-r,  width:r*2,height:r*2)),with:.color(coC.opacity(a*0.80)))
        }
    }

    private func drawStarsAnim(_ ctx: inout GraphicsContext, t: Double) {
        for i in 0..<30 {
            let s  = Double(i)*37.2
            let sx = (cos(s*1.1)*0.5+0.5)*Double(mapW-16)+8
            let sy = Double(bPatriarchs)+(sin(s*0.8)*0.5+0.5)*Double(bFlood-bPatriarchs-20)+10
            let a  = 0.28+sin(t*1.2+s*0.9)*0.38; let r = 1.0+sin(s*5.3)*0.6
            ctx.fill(Path(ellipseIn:CGRect(x:sx-r,y:sy-r,width:r*2,height:r*2)),with:.color(.white.opacity(a)))
        }
    }

    private func drawBushFireAnim(_ ctx: inout GraphicsContext, t: Double) {
        let cx = 82.0; let cy = 1086.0
        let fC = Color(hex:0xFF6600); let yC = Color(hex:0xFFDD00)
        for fl in 0..<5 {
            let fd = Double(fl)
            let fx = cx + sin(t*3.5+fd*1.2)*8; let fy = cy - 14 - fd*7
            let h  = 18.0 - fd*2.5
            let a  = 0.75 - fd*0.12
            ctx.fill(Path(ellipseIn:CGRect(x:fx-6,y:fy-h,width:12,height:h*1.6)),with:.color(fC.opacity(a)))
            ctx.fill(Path(ellipseIn:CGRect(x:fx-3,y:fy-h*0.6,width:6,height:h*0.8)),with:.color(yC.opacity(a*0.6)))
        }
    }

    private func drawRainAnim(_ ctx: inout GraphicsContext, t: Double) {
        let rC = Color(hex:0x8CB8FF)
        let rainH = Double(bEden-bFlood)
        for i in 0..<40 {
            let s = Double(i)*29.4; let spd = 190.0+s.truncatingRemainder(dividingBy:90)
            let rx = (cos(s*2.1)*0.5+0.5)*Double(mapW)
            let drop = (t*spd+s*55).truncatingRemainder(dividingBy:rainH+30)
            let ry = Double(bFlood)+drop
            if ry < Double(bEden) {
                var dp = Path(); dp.move(to:CGPoint(x:rx,y:ry)); dp.addLine(to:CGPoint(x:rx-2,y:ry+14))
                ctx.stroke(dp,with:.color(rC.opacity(0.38)),lineWidth:1.2)
            }
        }
    }

    private func drawSandAnim(_ ctx: inout GraphicsContext, t: Double) {
        let sC = Color(hex:0xE6C880)
        for i in 0..<20 {
            let s = Double(i)*63.1; let spd = 14.0+s.truncatingRemainder(dividingBy:10)
            let px = (t*spd+s*22).truncatingRemainder(dividingBy:Double(mapW)+20)-10
            let py = Double(bEgypt)+(cos(s*1.7)*0.5+0.5)*Double(bPatriarchs-bEgypt-20)+10
            let a  = 0.18+sin(t*0.7+s)*0.10
            ctx.fill(Path(ellipseIn:CGRect(x:px,y:py,width:3.5,height:1.8)),with:.color(sC.opacity(a)))
        }
    }

    private func drawLeavesAnim(_ ctx: inout GraphicsContext, t: Double) {
        let lC = Color(hex:0x44C038)
        for i in 0..<12 {
            let s = Double(i)*41.7
            let lx = (sin(s*0.7)*0.5+0.5)*Double(mapW)
            let ly = (cos(s*0.4)*0.5+0.5)*Double(bSinai-60)+30
            let fy = ly+sin(t*0.6+s)*12; let a = 0.55+sin(t*0.8+s)*0.25
            let sz = 5.0+sin(s*3.1)*2.0+2.0
            ctx.fill(Path(ellipseIn:CGRect(x:lx-sz/2,y:fy-sz/2,width:sz,height:sz*0.6)),with:.color(lC.opacity(a)))
        }
    }

    // MARK: ── ROAD ───────────────────────────────────────────────────────────

    private func drawRoad(_ ctx: inout GraphicsContext) {
        let pts = TrailViewModel.nodePositions
        let dR = Color(hex:0xE0B844); let pR = Color(hex:0x9E8560)
        let dI = Color(hex:0xFFDF80); let pI = Color(hex:0xBFAA82)
        for i in 0..<pts.count-1 {
            let a = pts[i]; let b = pts[i+1]
            let ctrl = CGPoint(x:(a.x+b.x)*0.5, y:min(a.y,b.y)-30)
            let done = i < vm.completedCount
            let seg  = quadP(a,ctrl,b)
            ctx.stroke(seg,with:.color(.black.opacity(0.40)),style:StrokeStyle(lineWidth:28,lineCap:.round))
            ctx.stroke(seg,with:.color(done ? dR : pR), style:StrokeStyle(lineWidth:22,lineCap:.round))
            ctx.stroke(seg,with:.color(done ? dI : pI), style:StrokeStyle(lineWidth:12,lineCap:.round))
            ctx.stroke(seg,with:.color(.white.opacity(done ? 0.85 : 0.32)),
                       style:StrokeStyle(lineWidth:2.5,lineCap:.round,dash:[10,13]))
        }
    }

    private func quadP(_ a:CGPoint,_ c:CGPoint,_ b:CGPoint)->Path {
        var p=Path(); p.move(to:a); p.addQuadCurve(to:b,control:c); return p
    }

    // MARK: ── BANNERS ────────────────────────────────────────────────────────

    private var biomeBanners: some View {
        let items: [(String,String,CGFloat)] = [
            ("🍇","TERRA PROMETIDA", bSinai*0.18+22),
            ("📜","SINAI E ÊXODO",   bSinai+24),
            ("🏛️","O EGITO",         bEgypt+24),
            ("⭐","OS PATRIARCAS",   bPatriarchs+24),
            ("🌊","NOÉ E O DILÚVIO", bFlood+24),
            ("🌍","A CRIAÇÃO",       bEden+24),
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

    // MARK: ── NODES + CHARACTER ──────────────────────────────────────────────

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
            Ellipse().fill(.black.opacity(0.22)).frame(width:44,height:9).blur(radius:4).offset(y:NR+12)
            Image(systemName:"arrowtriangle.down.fill").font(.system(size:11,weight:.black))
                .foregroundColor(.white).shadow(color:.black.opacity(0.45),radius:2)
                .offset(y:-(NR+22)+charBob)
            Text("🧑").font(.system(size:40))
                .shadow(color:.black.opacity(0.40),radius:4,x:1,y:3).offset(y:charBob)
        }
        .animation(.spring(response:0.85,dampingFraction:0.62),value:vm.characterNodeIndex)
        .position(vm.characterPosition).id("char")
    }
}

// MARK: - Node Button

struct TrailNodeBtn: View {
    let node: TrailNodeData
    let onTap: () -> Void
    @State private var ringScale: CGFloat = 1.0
    @State private var ringAlpha: CGFloat = 0.8

    private var baseColor: Color {
        switch node.status {
        case .locked:    return Color(hex:0x4D5260)
        case .available: return Color(hex:0x1A5FD9)
        case .completed: return Color(hex:0xD18008)
        }
    }

    var body: some View {
        Button(action:onTap) {
            ZStack {
                if node.status == .available {
                    Circle().stroke(baseColor.opacity(ringAlpha),lineWidth:3)
                        .frame(width:NR*2+20,height:NR*2+20).scaleEffect(ringScale)
                }
                Circle().fill(.white.opacity(0.15)).frame(width:NR*2+8,height:NR*2+8)
                Circle().fill(LinearGradient(colors:[baseColor.opacity(0.88),baseColor],
                                             startPoint:.topLeading,endPoint:.bottomTrailing))
                    .frame(width:NR*2,height:NR*2)
                    .shadow(color:baseColor.opacity(0.55),radius:12,x:0,y:5)
                    .shadow(color:.black.opacity(0.28),radius:5,x:0,y:3)
                Circle().fill(RadialGradient(colors:[.white.opacity(0.32),.clear],
                                             center:UnitPoint(x:0.28,y:0.20),
                                             startRadius:0,endRadius:NR*0.88))
                    .frame(width:NR*2,height:NR*2)
                if node.status == .locked {
                    Image(systemName:"lock.fill").font(.system(size:22,weight:.semibold)).foregroundStyle(.white.opacity(0.65))
                } else {
                    Text(node.emoji).font(.system(size:30))
                }
                if node.status == .completed {
                    ZStack {
                        Circle().fill(.white).frame(width:23,height:23)
                        Image(systemName:"checkmark.circle.fill").font(.system(size:23)).foregroundColor(Color(hex:0x1A9E30))
                    }.offset(x:NR-3,y:-(NR-3))
                }
            }
        }
        .buttonStyle(.plain).frame(width:NR*2+24,height:NR*2+24)
        .overlay(alignment:.bottom) {
            if node.status != .locked {
                Text(node.title).font(.system(size:10,weight:.bold,design:.rounded))
                    .foregroundColor(.white).shadow(color:.black.opacity(0.72),radius:3,x:0,y:1)
                    .multilineTextAlignment(.center).lineLimit(2).frame(width:90).offset(y:NR+28)
            }
        }
        .onAppear {
            guard node.status == .available else { return }
            withAnimation(.easeOut(duration:1.5).repeatForever(autoreverses:false)) { ringScale=1.60; ringAlpha=0 }
        }
    }
}

// MARK: - Color helper

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >>  8) & 0xFF) / 255
        let b = Double( hex        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
