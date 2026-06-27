import Foundation

private struct BibleJSONBook: Decodable {
    let chapters: [[String]]
}

@MainActor
class BibleReaderViewModel: ObservableObject {
    @Published var verses: [BibleVerse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private static var bibleBooks: [[[String]]]? = nil
    private static var cache: [String: [BibleVerse]] = [:]

    func loadChapter(book: BibleBook, chapter: Int) async {
        let key = "\(book.id)-\(chapter)"
        if let cached = BibleReaderViewModel.cache[key] {
            verses = cached
            return
        }
        isLoading = true
        errorMessage = nil

        do {
            let allBooks = try loadBibleData()
            let bookIndex = book.id - 1
            guard bookIndex >= 0, bookIndex < allBooks.count else {
                throw BibleError.bookNotFound
            }
            let chapterList = allBooks[bookIndex]
            let chapterIndex = chapter - 1
            guard chapterIndex >= 0, chapterIndex < chapterList.count else {
                throw BibleError.chapterNotFound
            }
            let verseTexts = chapterList[chapterIndex]
            let loaded = verseTexts.enumerated().map { i, text in
                BibleVerse(
                    id: "\(book.id)-\(chapter)-\(i + 1)",
                    chapter: chapter,
                    verse: i + 1,
                    text: text.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
            BibleReaderViewModel.cache[key] = loaded
            verses = loaded
        } catch {
            errorMessage = "Não foi possível carregar o capítulo."
        }
        isLoading = false
    }

    private func loadBibleData() throws -> [[[String]]] {
        if let cached = BibleReaderViewModel.bibleBooks {
            return cached
        }
        guard let url = Bundle.main.url(forResource: "bible_pt", withExtension: "json") else {
            throw BibleError.fileNotFound
        }
        let rawData = try Data(contentsOf: url)
        // Strip UTF-8 BOM (\u{FEFF}) if present before decoding JSON
        var jsonData = rawData
        if let text = String(data: rawData, encoding: .utf8), text.hasPrefix("\u{FEFF}") {
            jsonData = Data(text.dropFirst().utf8)
        }
        let books = try JSONDecoder().decode([BibleJSONBook].self, from: jsonData)
        let result = books.map { $0.chapters }
        BibleReaderViewModel.bibleBooks = result
        return result
    }

    private enum BibleError: Error {
        case fileNotFound, bookNotFound, chapterNotFound
    }
}
