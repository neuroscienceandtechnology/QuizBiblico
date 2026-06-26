import SwiftUI

struct BibleChapterView: View {
    let book: BibleBook
    let chapter: Int

    @StateObject private var vm = BibleReaderViewModel()
    @State private var fontSize: CGFloat = 17
    @AppStorage("bibleFontSize") private var savedFontSize: Double = 17

    var body: some View {
        Group {
            if vm.isLoading {
                VStack(spacing: 16) {
                    SwiftUI.ProgressView()
                    Text("Carregando \(book.name) \(chapter)...")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = vm.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Button("Tentar novamente") {
                        Task { await vm.loadChapter(book: book, chapter: chapter) }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(vm.verses) { verse in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(verse.verse)")
                                    .font(.system(size: fontSize - 4, weight: .bold))
                                    .foregroundStyle(.indigo)
                                    .frame(minWidth: 24, alignment: .trailing)
                                Text(verse.text)
                                    .font(.system(size: fontSize))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()

                    HStack(spacing: 24) {
                        if chapter > 1 {
                            NavigationLink(destination: BibleChapterView(book: book, chapter: chapter - 1)) {
                                Label("Anterior", systemImage: "chevron.left")
                            }
                        }
                        Spacer()
                        if chapter < book.chapters {
                            NavigationLink(destination: BibleChapterView(book: book, chapter: chapter + 1)) {
                                Label("Próximo", systemImage: "chevron.right")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("\(book.name) \(chapter)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button { savedFontSize = max(13, savedFontSize - 2); fontSize = savedFontSize } label: {
                        Label("Texto menor", systemImage: "textformat.size.smaller")
                    }
                    Button { savedFontSize = min(28, savedFontSize + 2); fontSize = savedFontSize } label: {
                        Label("Texto maior", systemImage: "textformat.size.larger")
                    }
                } label: {
                    Image(systemName: "textformat.size")
                }
            }
        }
        .task {
            fontSize = CGFloat(savedFontSize)
            await vm.loadChapter(book: book, chapter: chapter)
        }
    }
}
