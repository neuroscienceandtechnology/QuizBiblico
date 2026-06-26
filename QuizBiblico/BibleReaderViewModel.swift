import Foundation

@MainActor
class BibleReaderViewModel: ObservableObject {
    @Published var verses: [BibleVerse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cache: [String: [BibleVerse]] = [:]

    func loadChapter(book: BibleBook, chapter: Int) async {
        let key = "\(book.apiName)-\(chapter)"
        if let cached = cache[key] {
            verses = cached
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let urlString = "https://bible-api.com/\(book.apiName)+\(chapter)?translation=almeida"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(BibleAPIResponse.self, from: data)
            let loaded = response.verses.map {
                BibleVerse(id: "\(book.id)-\($0.chapter)-\($0.verse)", chapter: $0.chapter, verse: $0.verse, text: $0.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            cache[key] = loaded
            verses = loaded
        } catch {
            errorMessage = "Não foi possível carregar. Verifique sua conexão."
        }
        isLoading = false
    }
}
