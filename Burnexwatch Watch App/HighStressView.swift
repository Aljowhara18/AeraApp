import SwiftUI
import AVKit
import AVFoundation

struct HighStressView: View {
    // MARK: - Properties
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "stress_video", withExtension: "mp4")!)
    @State private var endObserver: Any?

    // MARK: - Layout Constants
    // تم تصغير الحجم من 245 إلى 160 لضمان ظهور النصوص بوضوح
    private let circleSize: CGFloat = 140
    private let footerTitleSize: CGFloat = 16
    private let footerSubTitleSize: CGFloat = 10
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // تقليل المسافة أعلى الفيديو
                Spacer(minLength: 8)

                // 1. قسم الفيديو (الكرة المركزية)
                videoSection
                    .frame(maxWidth: .infinity)
                    .padding(.top, -80) // يمكنك جعله -2 أو 2 لضبط أدق

                Spacer()

                // 2. النصوص السفلية مع إضافة Padding سفلي بسيط لرفع الكلام عن الحافة
                footerView
                    .padding(.top, -45)
            }
        }
    }
}

// MARK: - Subviews
private extension HighStressView {
    
    var videoSection: some View {
        ZStack {
            VideoPlayer(player: player)
                .onAppear { setupLoop() }
                .onDisappear {
                    player.pause()
                    removeLoopObserver()
                }
                .frame(width: circleSize, height: circleSize)
                .clipShape(Circle())
                .saturation(0)
                .overlay(
                    Circle()
                        .fill(Color.red.opacity(0.88))
                        .blendMode(.multiply)
                )
                .disabled(true)
        }
    }
    
    var footerView: some View {
        VStack(spacing: 1) { // تقليل المسافة بين الأسطر
            Text("Stress level is high")
                .font(.system(size: footerTitleSize, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Take A Moment To Check In\nWith Yourself")
                .font(.system(size: footerSubTitleSize, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true) // ضمان عدم قص النص
        }
        .padding(.horizontal, 5)
    }
}

// MARK: - Logic
private extension HighStressView {
    func setupLoop() {
        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()

        removeLoopObserver()

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }

    func removeLoopObserver() {
        if let observer = endObserver {
            NotificationCenter.default.removeObserver(observer)
            endObserver = nil
        }
    }
}

#Preview {
    HighStressView()
}
