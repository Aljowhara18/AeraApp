import SwiftUI
import AVKit
import AVFoundation
import Combine

// MARK: - ViewModel
final class AnalysisPagerViewModel: ObservableObject {
    @Published var sleepText: String = "0%"
    @Published var hrvText: String = "-- ms"
    @Published var rhrText: String = "-- BPM"
    
    private let health = HealthManager()
    
    init() {
        requestAndFetch()
    }
    
    func requestAndFetch() {
        health.requestAuthorization { [weak self] ok in
            guard let self = self, ok else { return }
            self.fetchAll()
        }
    }
    
    private func fetchAll() {
        health.fetchSleep { [weak self] s in
            DispatchQueue.main.async { self?.sleepText = s }
        }
        health.fetchLatestHRV { [weak self] s in
            DispatchQueue.main.async { self?.hrvText = s }
        }
        health.fetchLatestRHR { [weak self] s in
            DispatchQueue.main.async { self?.rhrText = s }
        }
    }
}

// MARK: - Main Pager View
struct AnalysisPagerView: View {
    @StateObject private var vm = AnalysisPagerViewModel()
    
    var body: some View {
        TabView {
            AnalysisPageView(
                title: "Sleep",
                value: vm.sleepText,
                videoTint: colorForSleep(vm.sleepText)
            )
            AnalysisPageView(
                title: "HRV",
                value: vm.hrvText,
                videoTint: colorForHRV(vm.hrvText)
            )
            AnalysisPageView(
                title: "RHR",
                value: vm.rhrText,
                videoTint: colorForRHR(vm.rhrText)
            )
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
    
    // MARK: - Color Rules
    // Sleep text like "75%"
    private func colorForSleep(_ text: String) -> Color {
        let pct = extractNumber(from: text) ?? 0
        return pct >= 75 ? .green : .red
    }
    // HRV text like "45 ms"
    private func colorForHRV(_ text: String) -> Color {
        let hrv = extractNumber(from: text) ?? 0
        return hrv >= 40 ? .green : .red
    }
    // RHR text like "62 BPM"
    private func colorForRHR(_ text: String) -> Color {
        let bpm = extractNumber(from: text) ?? 0
        return bpm >= 80 ? .red : .green
    }
    // Extract first number in a string
    private func extractNumber(from text: String) -> Double? {
        let digits = text.compactMap { $0.isNumber || $0 == "." ? $0 : nil }
        return Double(String(digits))
    }
}

// MARK: - Page View (Optimized for watchOS)
struct AnalysisPageView: View {
    let title: String
    let value: String
    let videoTint: Color

    // Sizes appropriate for Apple Watch
    private let titleFont: Font = .system(size: 14, weight: .medium)
    private let valueFont: Font = .system(size: 34, weight: .bold, design: .rounded)
    private let circleSize: CGFloat = 150

    @State private var player: AVPlayer? = {
        guard let url = Bundle.main.url(forResource: "stress_video", withExtension: "mp4") else {
            return nil
        }
        let p = AVPlayer(url: url)
        p.isMuted = true
        p.actionAtItemEnd = .none
        return p
    }()
    @State private var endObserver: NSObjectProtocol?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                if let player {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .onAppear {
                            player.play()
                            endObserver = NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: player.currentItem,
                                queue: .main
                            ) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                        .onDisappear {
                            if let endObserver {
                                NotificationCenter.default.removeObserver(endObserver)
                                self.endObserver = nil
                            }
                            player.pause()
                        }
                        .frame(width: circleSize, height: circleSize)
                        .clipShape(Circle())
                        .saturation(0)
                        .overlay(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [videoTint.opacity(0.85), videoTint.opacity(0.45)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blendMode(.multiply)
                        )
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [videoTint.opacity(0.85), videoTint.opacity(0.45)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: circleSize, height: circleSize)
                }

                VStack(spacing: 2) {
                    Text(title)
                        .font(titleFont)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(value)
                        .font(valueFont)
                        .foregroundColor(.white)
                }
                .offset(y: -5)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AnalysisPagerView()
}
