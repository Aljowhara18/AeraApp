import SwiftUI
import AVKit
import AVFoundation

struct OverviewWatchView: View {
    @StateObject private var vm = OverviewWatchViewModel()
    
    // الحاوية الثابتة للحلقة/الفيديو
    private let ringContainerHeight: CGFloat = 180
    // تحكم بحجم الفيديو/الحلقة
    private let ringSize: CGFloat = 140

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // العنوان
                    headerSection
                        .padding(.top, 2)
                    
                    // الدائرة مع الفيديو الخلفي (بدون الحلقة)
                    ZStack {
                        Color.clear
                        RingWithFullBackgroundVideo(progress: vm.averageProgress, size: ringSize)
                    }
                    .frame(height: ringContainerHeight)
                    .frame(maxWidth: .infinity)
                    
                    Spacer(minLength: 6)
                    
                    // زر الانتقال
                    navigationButton
                        .padding(.bottom, 2)
                }
                .padding(.horizontal, 8)
            }
            .onAppear {
                vm.requestAndFetch()
            }
        }
    }
}

// MARK: - الدائرة مع الفيديو المطور لـ watchOS (بدون الحلقة)
struct RingWithFullBackgroundVideo: View {
    let progress: Double
    let size: CGFloat
    
    @State private var player: AVPlayer? = {
        guard let url = Bundle.main.url(forResource: "stress_video", withExtension: "mp4") else {
            return nil
        }
        let p = AVPlayer(url: url)
        p.isMuted = true // كتم الصوت ضروري للتشغيل كخلفية
        p.actionAtItemEnd = .none
        return p
    }()
    @State private var endObserver: NSObjectProtocol?

    var body: some View {
        ZStack {
            // الطبقة 1: الفيديو (مع تعطيل التفاعل لمنع ظهور أدوات التحكم)
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true) // لمنع ظهور أزرار التشغيل عند اللمس
                    .allowsHitTesting(false) // يمنع وصول اللمس للفيديو تماماً
                    .onAppear {
                        player.play()
                        
                        // إعادة تشغيل الفيديو تلقائياً (Loop)
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
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .saturation(0) // أبيض وأسود
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.purple.opacity(0.72),
                                        Color.purple.opacity(0.30)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blendMode(.multiply)
                    )
            } else {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: size, height: size)
            }
            
            // الطبقة 2: التدرج الداخلي لتحسين وضوح النص
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.10),
                            Color.black.opacity(0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size - 30, height: size - 30)

            // تمت إزالة الطبقة الخاصة بقوس التقدم (الحلقة)

            // الطبقة 4: النصوص المركزية
            VStack(spacing: -2) {
                Text("\(Int((progress * 100).rounded()))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Average")
                    .font(.system(size: size * 0.09, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

// MARK: - Components Extension
private extension OverviewWatchView {
    var headerSection: some View {
        HStack {
            Text("Overview")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 12)
    }
    
    var navigationButton: some View {
        NavigationLink(destination: AnalysisPagerView()) {
            Text("View All")
                .font(.system(size: 13, weight: .medium))
                .frame(width: 90, height: 30)
                .background(Capsule().fill(Color.white.opacity(0.15)))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    // لا حاجة لإضافة NavigationStack هنا لأنه مدمج داخل العرض
    OverviewWatchView()
}
