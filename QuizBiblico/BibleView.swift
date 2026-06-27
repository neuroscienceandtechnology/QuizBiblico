import SwiftUI

struct BibleView: View {
    @State private var searchText = ""
    @State private var selectedTestament: Testament = .old

    enum Testament: String, CaseIterable {
        case old = "Antigo Testamento"
        case new = "Novo Testamento"
    }

    var filteredBooks: [BibleBook] {
        let books = allBibleBooks.filter {
            selectedTestament == .old ? $0.testament == .old : $0.testament == .new
        }
        if searchText.isEmpty { return books }
        return books.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Testamento", selection: $selectedTestament) {
                    ForEach(Testament.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)
                .padding()

                List(filteredBooks) { book in
                    NavigationLink(destination: BibleChapterListView(book: book)) {
                        HStack {
                            Text("\(book.id)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(book.testament == .old ? Color.indigo : Color.purple)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(book.name).font(.body.bold())
                                Text("\(book.chapters) capítulos")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .searchable(text: $searchText, prompt: "Buscar livro")
                .listStyle(.plain)

            }
            .navigationTitle("Bíblia Sagrada")
        }
    }
}

struct BibleChapterListView: View {
    let book: BibleBook

    var body: some View {
        List(1...book.chapters, id: \.self) { chapter in
            NavigationLink(destination: BibleChapterView(book: book, chapter: chapter)) {
                Label("Capítulo \(chapter)", systemImage: "text.alignleft")
            }
        }
        .navigationTitle(book.name)
        .navigationBarTitleDisplayMode(.large)
    }
}
