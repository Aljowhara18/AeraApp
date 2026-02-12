import SwiftUI
import AVKit
import AVFoundation
import Combine

// MARK: - ViewModel
final class AnalysisPagerViewModel: ObservableObject {
    @Published var sleepText: String = "0%"
    @Published var hrvText: String = "-- ms"
    @Published var rhrText: String = "-- BPM"
    
    // تأكد من وجود ملف HealthManager في مشروعك
    private let health = HealthManager()
    
    init() {
        requestAndFetch()
    }
    
    func requestAndFetch() {
        health.requestAuthorization { [weak self] (ok: Bool) in
            guard let self = self, ok else { return }
            self.fetchAll()
        }
    }
    
    private func fetchAll() {
        health.fetchSleep { [weak self] (s: String) in
            DispatchQueue.main.async { self?.sleepText = s }
        }
        health.fetchLatestHRV { [weak self] (s: String) in
            DispatchQueue.main.async { self?.hrvText = s }
        }
        health.fetchLatestRHR { [weak self] (s: String) in
            DispatchQueue.main.async { self?.rhrText = s }
        }
    }
}

// MARK: - Main Pager View
struct AnalysisPagerView: View {
    @StateObject private var vm = AnalysisPagerViewModel()
    
    var body: some View {
        TabView {
            // صفحة النوم
            AnalysisPageView(
                title: "Sleep",
                value: vm.sleepText,
                videoTint: .blue
            )
            
            // صفحة HRV
            AnalysisPageView(
                title: "HRV",
                value: vm.hrvText,
                videoTint: .purple
            )
            
            // صفحة RHR
            AnalysisPageView(
                title: "RHR",
                value: vm.rhrText,
                videoTint: .orange
            )
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

// MARK: - Page View (Optimized for watchOS)
struct AnalysisPageView: View {
    let title: String
    let value: String
    let videoTint: Color

    // أحجام مناسبة لشاشة الساعة
    private let titleFont: Font = .system(size: 14, weight: .medium)
    private let valueFont: Font = .system(size: 34, weight: .bold, design: .rounded)
    private let circleSize: CGFloat = 150

    @State private var player: AVPlayer? = {
        guard let url = Bundle.main.url(forResource: "stress_video", withExtension: "mp4") else {
            return nil
        }
        let p = AVPlayer(url: url)
        p.isMuted = true
        return p
    }()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        // الخدعة: تعطيل اللمس يمنع ظهور أزرار التحكم في الساعة
                        .disabled(true)
                        .onAppear {
                            player.play()
                            
                            // تكرار الفيديو (Loop)
                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: player.currentItem,
                                queue: .main
                            ) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                        .frame(width: circleSize, height: circleSize)
                        .clipShape(Circle())
                        // تحويل الفيديو للأبيض والأسود ليقبل التلوين
                        .saturation(0)
                        .overlay(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [videoTint.opacity(0.8), videoTint.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                // دمج اللون مع الفيديو ليصبح الفيديو ملوناً
                                .blendMode(.multiply)
                        )
                }

                // النصوص فوق الفيديو
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
