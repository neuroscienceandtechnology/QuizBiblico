import SwiftUI
import AVFoundation

// MARK: - Main View

struct AudioBibleView: View {
    @StateObject private var vm = AudioBibleViewModel()
    @State private var showBookPicker = false
    @State private var showSetup = false

    var body: some View {
        NavigationStack {
            Group {
                if AudioBibleConfig.isConfigured {
                    playerContent
                } else {
                    setupPrompt
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label("Bíblia em Áudio", systemImage: "headphones")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSetup = true } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 15))
                    }
                }
            }
            .sheet(isPresented: $showBookPicker) {
                AudioBookPickerView(selectedBook: $vm.selectedBook,
                                    selectedChapter: $vm.selectedChapter) {
                    vm.loadChapter()
                }
            }
            .sheet(isPresented: $showSetup) {
                AudioSetupView()
            }
        }
    }

    // MARK: - Player Content

    private var playerContent: some View {
        ZStack {
            playerBackground
            ScrollView {
                VStack(spacing: 0) {
                    artworkSection
                    chapterInfoSection
                    errorBanner
                    progressSection
                    controlsSection
                    speedSection
                    Spacer(minLength: 40)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Background

    private var playerBackground: some View {
        LinearGradient(
            colors: [bgColor.opacity(0.95), bgColor.opacity(0.70), Color(.systemBackground)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var bgColor: Color {
        vm.selectedBook.testament == .old
            ? Color(red: 0.12, green: 0.30, blue: 0.52)
            : Color(red: 0.38, green: 0.18, blue: 0.52)
    }

    // MARK: - Artwork

    private var artworkSection: some View {
        ZStack {
            Circle()
                .fill(bgColor.opacity(0.30))
                .frame(width: 240, height: 240)
                .blur(radius: 24)

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [bgColor, bgColor.opacity(0.75)],
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 192, height: 192)
                    .shadow(color: bgColor.opacity(0.55), radius: 20, x: 0, y: 8)

                VStack(spacing: 6) {
                    Text(vm.selectedBook.testament == .old ? "📜" : "✝️")
                        .font(.system(size: 64))
                    Text("Dramatizada")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.70))
                        .kerning(1.2)
                }
            }

            if vm.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.4)
            }
        }
        .frame(height: 300)
        .padding(.top, 80)
    }

    // MARK: - Chapter info + picker

    private var chapterInfoSection: some View {
        VStack(spacing: 6) {
            Button { showBookPicker = true } label: {
                HStack(spacing: 6) {
                    Text(vm.selectedBook.name)
                        .font(.title2.bold())
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundColor(bgColor)
                }
                .foregroundColor(.primary)
            }

            Text("Capítulo \(vm.selectedChapter)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Bíblia Sagrada Dramatizada")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.80))
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
    }

    // MARK: - Error banner

    @ViewBuilder
    private var errorBanner: some View {
        if let err = vm.errorMessage {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text(err)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(Color.orange.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }

    // MARK: - Waveform + progress

    private var progressSection: some View {
        VStack(spacing: 8) {
            AudioWaveformView(isPlaying: vm.isPlaying, color: bgColor)
                .frame(height: 40)
                .padding(.horizontal, 24)
                .padding(.top, 20)

            ProgressSlider(value: vm.progressFraction) { frac in
                vm.seek(to: frac)
            }
            .padding(.horizontal, 24)

            HStack {
                Text(vm.timeString)
                Spacer()
                Text("-\(vm.remainString)")
            }
            .font(.caption.monospacedDigit())
            .foregroundColor(.secondary)
            .padding(.horizontal, 28)
        }
    }

    // MARK: - Controls

    private var controlsSection: some View {
        HStack(spacing: 0) {
            controlButton(icon: "backward.end.fill", size: 22) { vm.previousChapter() }
            controlButton(icon: "gobackward.15", size: 26) { vm.skipBack() }

            // Play/Pause
            Button { vm.togglePlayPause() } label: {
                ZStack {
                    Circle()
                        .fill(bgColor)
                        .frame(width: 72, height: 72)
                        .shadow(color: bgColor.opacity(0.45), radius: 12, y: 4)
                    if vm.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                            .offset(x: vm.isPlaying ? 0 : 2)
                    }
                }
            }
            .padding(.horizontal, 20)

            controlButton(icon: "goforward.30", size: 26) { vm.skipForward() }
            controlButton(icon: "forward.end.fill", size: 22) { vm.nextChapter() }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private func controlButton(icon: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
    }

    // MARK: - Speed

    private var speedSection: some View {
        HStack(spacing: 6) {
            ForEach([Float(0.75), 1.0, 1.25, 1.5, 2.0], id: \.self) { rate in
                Button {
                    vm.setRate(rate)
                } label: {
                    Text(rateLabel(rate))
                        .font(.system(size: 13, weight: vm.playbackRate == rate ? .bold : .regular, design: .rounded))
                        .foregroundColor(vm.playbackRate == rate ? .white : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(vm.playbackRate == rate ? bgColor : Color(.systemFill))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.top, 20)
    }

    private func rateLabel(_ r: Float) -> String {
        r == 1.0 ? "1×" : r == 0.75 ? "0.75×" : r == 1.25 ? "1.25×" : r == 1.5 ? "1.5×" : "2×"
    }

    // MARK: - Setup prompt

    private var setupPrompt: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "headphones.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.indigo)

            VStack(spacing: 8) {
                Text("Bíblia em Áudio")
                    .font(.title.bold())
                Text("Configure sua chave gratuita da API\nFaith Comes By Hearing para ouvir\na Bíblia Dramatizada em português.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }

            Button { showSetup = true } label: {
                Label("Configurar Agora", systemImage: "key.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

// MARK: - Book Picker

struct AudioBookPickerView: View {
    @Binding var selectedBook: BibleBook
    @Binding var selectedChapter: Int
    let onSelect: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var testament: BibleBook.Testament = .new

    var books: [BibleBook] {
        allBibleBooks.filter { $0.testament == testament }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Testamento", selection: $testament) {
                    Text("Antigo Testamento").tag(BibleBook.Testament.old)
                    Text("Novo Testamento").tag(BibleBook.Testament.new)
                }
                .pickerStyle(.segmented)
                .padding()

                List(books) { book in
                    if book.id == selectedBook.id {
                        chapterPicker(for: book)
                    } else {
                        Button {
                            selectedBook = book
                            selectedChapter = 1
                        } label: {
                            HStack {
                                bookLabel(book)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Escolher Livro").font(.headline)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Reproduzir") {
                        onSelect()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onAppear {
                testament = selectedBook.testament
            }
        }
    }

    private func bookLabel(_ book: BibleBook) -> some View {
        HStack(spacing: 12) {
            Text("\(book.id)")
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(book.testament == .old ? Color.indigo : Color.purple)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(book.name).font(.body)
                Text("\(book.chapters) cap.").font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private func chapterPicker(for book: BibleBook) -> some View {
        DisclosureGroup(isExpanded: .constant(true)) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 6), spacing: 6) {
                ForEach(1...book.chapters, id: \.self) { ch in
                    Button {
                        selectedBook = book
                        selectedChapter = ch
                    } label: {
                        Text("\(ch)")
                            .font(.system(size: 14, weight: selectedChapter == ch ? .bold : .regular))
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(selectedChapter == ch ? Color.indigo : Color(.systemFill))
                            .foregroundColor(selectedChapter == ch ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                }
            }
            .padding(.vertical, 8)
        } label: {
            bookLabel(book)
        }
    }
}

// MARK: - Setup View

struct AudioSetupView: View {
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "fcbh_api_key") ?? ""
    @State private var saved = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "headphones.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.indigo)
                            VStack(alignment: .leading) {
                                Text("Faith Comes By Hearing")
                                    .font(.headline)
                                Text("Bíblia Dramatizada em Português")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Text("Para ouvir a Bíblia Dramatizada, você precisa de uma chave gratuita da API do Faith Comes By Hearing (Bible.is).")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Sobre")
                }

                Section {
                    Link(destination: URL(string: "https://www.faithcomesbyhearing.com/bible-brain/developer-documentation")!) {
                        Label("Registrar e obter chave gratuita", systemImage: "arrow.up.right.square")
                    }
                } header: {
                    Text("Passo 1 — Registrar")
                } footer: {
                    Text("O cadastro é gratuito. Acesse o link e crie sua conta de desenvolvedor.")
                }

                Section {
                    TextField("Cole sua chave de API aqui", text: $apiKey)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Passo 2 — Inserir chave")
                } footer: {
                    Text("Sua chave é salva apenas neste dispositivo.")
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Fileset AT Dramatizado").font(.caption.bold()).foregroundColor(.secondary)
                        Text(AudioBibleConfig.otFilesetId).font(.system(.caption, design: .monospaced))
                        Text("Fileset NT Dramatizado").font(.caption.bold()).foregroundColor(.secondary).padding(.top, 4)
                        Text(AudioBibleConfig.ntFilesetId).font(.system(.caption, design: .monospaced))
                    }
                    .padding(.vertical, 2)
                } header: {
                    Text("Filesets (Versão NVI)")
                } footer: {
                    Text("Para trocar a versão da Bíblia, edite os IDs em AudioBibleConfig.swift.")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Configuração de Áudio").font(.headline)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        UserDefaults.standard.set(apiKey.trimmingCharacters(in: .whitespaces),
                                                   forKey: "fcbh_api_key")
                        saved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { dismiss() }
                    }
                    .fontWeight(.semibold)
                    .disabled(apiKey.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .overlay {
                if saved {
                    VStack {
                        Spacer()
                        Label("Chave salva!", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.bottom, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.spring(), value: saved)
                }
            }
        }
    }
}

// MARK: - Custom Slider

struct ProgressSlider: View {
    let value: Double
    let onSeek: (Double) -> Void
    @GestureState private var isDragging = false
    @State private var dragValue: Double? = nil

    private var display: Double { dragValue ?? value }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemFill))
                    .frame(height: isDragging ? 6 : 4)

                Capsule()
                    .fill(Color.primary.opacity(0.80))
                    .frame(width: geo.size.width * display, height: isDragging ? 6 : 4)

                Circle()
                    .fill(.white)
                    .frame(width: isDragging ? 20 : 14, height: isDragging ? 20 : 14)
                    .shadow(radius: 3)
                    .offset(x: geo.size.width * display - (isDragging ? 10 : 7))
            }
            .animation(.spring(response: 0.25), value: isDragging)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { _, s, _ in s = true }
                    .onChanged { g in
                        dragValue = max(0, min(1, g.location.x / geo.size.width))
                    }
                    .onEnded { g in
                        let f = max(0, min(1, g.location.x / geo.size.width))
                        dragValue = nil
                        onSeek(f)
                    }
            )
        }
        .frame(height: 22)
    }
}

// MARK: - Animated Waveform

struct AudioWaveformView: View {
    let isPlaying: Bool
    let color: Color
    @State private var phase: Double = 0

    private let barCount = 40

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30, paused: !isPlaying)) { tl in
            Canvas { ctx, size in
                let t = isPlaying ? tl.date.timeIntervalSinceReferenceDate : 0
                let bw: CGFloat = (size.width - CGFloat(barCount - 1) * 2) / CGFloat(barCount)
                for i in 0..<barCount {
                    let x = CGFloat(i) * (bw + 2)
                    let wave = sin(Double(i) * 0.4 + t * 4.5)
                    let h = isPlaying
                        ? CGFloat(abs(wave) * 0.65 + 0.1) * size.height
                        : size.height * 0.08
                    let y = (size.height - h) / 2
                    let alpha = 0.45 + abs(wave) * 0.45
                    ctx.fill(
                        Path(roundedRect: CGRect(x: x, y: y, width: bw, height: h), cornerRadius: bw / 2),
                        with: .color(color.opacity(alpha))
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isPlaying)
    }
}
