import SwiftUI

struct TrailSelectionView: View {
    @State private var genesisProgress: Int = 0
    @State private var evangelhoProgress: Int = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    trailCard(
                        destination: AnyView(TrailMapView()),
                        title: "Gênesis ao Josué",
                        subtitle: "Antigo Testamento",
                        description: "Do início da criação à conquista da Terra Prometida — 12 etapas pela fundação da fé.",
                        emoji: "🌍",
                        colors: [Color(hex: 0x0A4D0A), Color(hex: 0x1A7A1A)],
                        nodeCount: 12,
                        completedCount: genesisProgress,
                        accentColor: Color(hex: 0x3CB84A)
                    )
                    trailCard(
                        destination: AnyView(TrailEvangelhoMapView()),
                        title: "Os Evangelhos",
                        subtitle: "Novo Testamento",
                        description: "Do anúncio do nascimento de Jesus à Grande Comissão — 12 etapas pela vida de Cristo.",
                        emoji: "✝️",
                        colors: [Color(hex: 0x7A4A00), Color(hex: 0xC07A10)],
                        nodeCount: 12,
                        completedCount: evangelhoProgress,
                        accentColor: Color(hex: 0xFFCC00)
                    )
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 18)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label("Trilhas", systemImage: "map.fill")
                        .font(.headline)
                }
            }
            .onAppear { refreshProgress() }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Trilhas do Conhecimento")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text("Escolha sua jornada bíblica")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 24)
    }

    private func trailCard<D: View>(
        destination: D,
        title: String,
        subtitle: String,
        description: String,
        emoji: String,
        colors: [Color],
        nodeCount: Int,
        completedCount: Int,
        accentColor: Color
    ) -> some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                // Header gradient strip
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 110)
                    HStack(alignment: .bottom, spacing: 14) {
                        Text(emoji)
                            .font(.system(size: 54))
                            .shadow(radius: 4)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(subtitle)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white.opacity(0.75))
                                .textCase(.uppercase)
                                .kerning(1.2)
                            Text(title)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        }
                        Spacer()
                        progressBadge(completed: completedCount, total: nodeCount, accent: accentColor)
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 14)
                }

                // Description + progress bar
                VStack(alignment: .leading, spacing: 12) {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("\(completedCount) de \(nodeCount) etapas")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.primary)
                            Spacer()
                            if completedCount == nodeCount {
                                Label("Concluída!", systemImage: "checkmark.seal.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(accentColor)
                            } else if completedCount > 0 {
                                Text("Em andamento")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color(.systemFill))
                                    .frame(height: 8)
                                Capsule()
                                    .fill(accentColor)
                                    .frame(width: nodeCount > 0 ? geo.size.width * CGFloat(completedCount) / CGFloat(nodeCount) : 0, height: 8)
                                    .animation(.spring(), value: completedCount)
                            }
                        }
                        .frame(height: 8)
                    }

                    HStack {
                        Label("\(nodeCount) etapas", systemImage: "map")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(completedCount == 0 ? "Começar" : completedCount == nodeCount ? "Revisar" : "Continuar")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(colors.first ?? .blue)
                    }
                }
                .padding(18)
                .background(Color(.secondarySystemGroupedBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private func progressBadge(completed: Int, total: Int, accent: Color) -> some View {
        VStack(spacing: 1) {
            Text("\(completed)")
                .font(.title.bold())
                .foregroundColor(.white)
            Text("/\(total)")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.70))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.black.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func refreshProgress() {
        genesisProgress    = TrailViewModel.savedCompletedCount(for: .genesis)
        evangelhoProgress  = TrailViewModel.savedCompletedCount(for: .evangelhos)
    }
}
