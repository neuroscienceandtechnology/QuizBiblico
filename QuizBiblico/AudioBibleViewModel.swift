import SwiftUI
import AVFoundation
import MediaPlayer
import Combine

@MainActor
class AudioBibleViewModel: ObservableObject {

    // MARK: - Selection
    @Published var selectedBook: BibleBook = allBibleBooks[39]  // Mateus
    @Published var selectedChapter: Int = 1

    // MARK: - Playback state
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var playbackRate: Float = 1.0
    @Published var errorMessage: String? = nil
    @Published var currentStreamURL: URL? = nil

    // MARK: - AVPlayer
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var statusObserver: AnyCancellable?
    private var endObserver: Any?

    var progressFraction: Double {
        guard duration > 0 else { return 0 }
        return min(currentTime / duration, 1)
    }

    var timeString: String   { formatTime(currentTime) }
    var remainString: String { formatTime(max(0, duration - currentTime)) }

    // MARK: - Init / deinit

    init() {
        configureAudioSession()
        setupRemoteCommandCenter()
    }

    nonisolated func cleanup() {
        Task { @MainActor in
            tearDownPlayer()
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
    }

    // MARK: - Load chapter

    func loadChapter() {
        Task { await load() }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        tearDownPlayer()

        do {
            let result = try await AudioBibleService.shared.fetchChapterAudio(
                book: selectedBook, chapter: selectedChapter)
            await play(url: result.streamURL)
        } catch {
            isLoading = false
            errorMessage = (error as? AudioBibleError)?.errorDescription ?? error.localizedDescription
        }
    }

    private func play(url: URL) async {
        currentStreamURL = url
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.rate = playbackRate

        // Observe status
        statusObserver = item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                if status == .readyToPlay {
                    self.isLoading = false
                    let dur = item.asset.duration.seconds
                    if !dur.isNaN && !dur.isInfinite { self.duration = dur }
                    self.player?.play()
                    self.isPlaying = true
                    self.updateNowPlayingInfo()
                } else if status == .failed {
                    self.isLoading = false
                    self.errorMessage = "Falha ao carregar o áudio."
                }
            }

        // Periodic time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            self.currentTime = time.seconds
            if self.duration == 0 {
                let d = self.player?.currentItem?.duration.seconds ?? 0
                if d > 0 && !d.isNaN { self.duration = d }
            }
            self.updateNowPlayingInfoElapsed()
        }

        // End of chapter
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.onChapterEnd()
        }

        player?.play()
    }

    // MARK: - Controls

    func togglePlayPause() {
        guard let player else {
            loadChapter()
            return
        }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
        updateNowPlayingInfo()
    }

    func seek(to fraction: Double) {
        guard let player, duration > 0 else { return }
        let target = CMTime(seconds: fraction * duration, preferredTimescale: 600)
        player.seek(to: target)
        currentTime = fraction * duration
    }

    func skipForward() {
        guard let player else { return }
        let t = CMTime(seconds: min(currentTime + 30, duration), preferredTimescale: 600)
        player.seek(to: t)
    }

    func skipBack() {
        guard let player else { return }
        let t = CMTime(seconds: max(currentTime - 15, 0), preferredTimescale: 600)
        player.seek(to: t)
    }

    func setRate(_ rate: Float) {
        playbackRate = rate
        if isPlaying { player?.rate = rate }
    }

    func nextChapter() {
        if selectedChapter < selectedBook.chapters {
            selectedChapter += 1
        } else {
            guard let idx = allBibleBooks.firstIndex(where: { $0.id == selectedBook.id }),
                  idx + 1 < allBibleBooks.count else { return }
            selectedBook = allBibleBooks[idx + 1]
            selectedChapter = 1
        }
        loadChapter()
    }

    func previousChapter() {
        if selectedChapter > 1 {
            selectedChapter -= 1
        } else {
            guard let idx = allBibleBooks.firstIndex(where: { $0.id == selectedBook.id }),
                  idx > 0 else { return }
            selectedBook = allBibleBooks[idx - 1]
            selectedChapter = selectedBook.chapters
        }
        loadChapter()
    }

    // MARK: - Helpers

    private func onChapterEnd() {
        isPlaying = false
        currentTime = duration
        // Auto-advance to next chapter
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.nextChapter()
        }
    }

    private func tearDownPlayer() {
        if let obs = timeObserver { player?.removeTimeObserver(obs) }
        if let obs = endObserver { NotificationCenter.default.removeObserver(obs) }
        statusObserver = nil
        player?.pause()
        player = nil
        timeObserver = nil
        endObserver = nil
        isPlaying = false
        currentTime = 0
        duration = 0
    }

    private func formatTime(_ t: Double) -> String {
        guard t.isFinite else { return "0:00" }
        let total = Int(t)
        let m = total / 60; let s = total % 60
        return String(format: "%d:%02d", m, s)
    }

    // MARK: - Audio session

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("AudioSession error: \(error)") }
    }

    // MARK: - Remote command center (lock screen)

    private func setupRemoteCommandCenter() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let cc = MPRemoteCommandCenter.shared()

        cc.playCommand.addTarget { [weak self] _ in
            self?.player?.play(); self?.isPlaying = true
            return .success
        }
        cc.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause(); self?.isPlaying = false
            return .success
        }
        cc.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextChapter(); return .success
        }
        cc.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousChapter(); return .success
        }
        cc.skipForwardCommand.preferredIntervals = [NSNumber(value: 30)]
        cc.skipForwardCommand.addTarget { [weak self] _ in
            self?.skipForward(); return .success
        }
        cc.skipBackwardCommand.preferredIntervals = [NSNumber(value: 15)]
        cc.skipBackwardCommand.addTarget { [weak self] _ in
            self?.skipBack(); return .success
        }
        cc.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let e = event as? MPChangePlaybackPositionCommandEvent, let self else { return .commandFailed }
            let frac = self.duration > 0 ? e.positionTime / self.duration : 0
            self.seek(to: frac)
            return .success
        }
    }

    private func updateNowPlayingInfo() {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: "Capítulo \(selectedChapter)",
            MPMediaItemPropertyAlbumTitle: selectedBook.name,
            MPMediaItemPropertyArtist: "Bíblia Sagrada Dramatizada",
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? Double(playbackRate) : 0.0,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
        ]
        if let img = UIImage(systemName: "book.fill") {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { _ in img }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func updateNowPlayingInfoElapsed() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
    }
}
