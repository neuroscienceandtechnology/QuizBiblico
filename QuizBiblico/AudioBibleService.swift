import Foundation

struct AudioChapterResult {
    let streamURL: URL
    let durationHint: String?
}

enum AudioBibleError: Error, LocalizedError {
    case notConfigured
    case networkError(Error)
    case noAudioFound
    case decodingError

    var errorDescription: String? {
        switch self {
        case .notConfigured:   return "Chave de API não configurada."
        case .networkError(let e): return "Erro de rede: \(e.localizedDescription)"
        case .noAudioFound:    return "Áudio não encontrado para este capítulo."
        case .decodingError:   return "Erro ao processar resposta da API."
        }
    }
}

// MARK: - Response models

private struct FilesetChapterResponse: Decodable {
    let data: [FilesetChapterItem]
}

private struct FilesetChapterItem: Decodable {
    let path: String
    let duration: Double?
}

// MARK: - Service

class AudioBibleService {

    static let shared = AudioBibleService()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        session = URLSession(configuration: config)
    }

    func fetchChapterAudio(book: BibleBook, chapter: Int) async throws -> AudioChapterResult {
        guard AudioBibleConfig.isConfigured else { throw AudioBibleError.notConfigured }

        guard let bookCode = AudioBibleConfig.fcbhBookCode[book.id] else {
            throw AudioBibleError.noAudioFound
        }

        let filesetId = AudioBibleConfig.fileset(for: book.testament)
        let urlString = "\(AudioBibleConfig.baseURL)/bibles/filesets/\(filesetId)/\(bookCode)/\(chapter)?v=4&key=\(AudioBibleConfig.apiKey)"

        guard let url = URL(string: urlString) else { throw AudioBibleError.noAudioFound }

        let data: Data
        do {
            let (responseData, _) = try await session.data(from: url)
            data = responseData
        } catch {
            throw AudioBibleError.networkError(error)
        }

        guard let response = try? JSONDecoder().decode(FilesetChapterResponse.self, from: data),
              let first = response.data.first,
              let streamURL = URL(string: first.path) else {
            throw AudioBibleError.noAudioFound
        }

        let dur: String? = first.duration.map { d in
            let m = Int(d) / 60; let s = Int(d) % 60
            return String(format: "%d:%02d", m, s)
        }
        return AudioChapterResult(streamURL: streamURL, durationHint: dur)
    }
}
