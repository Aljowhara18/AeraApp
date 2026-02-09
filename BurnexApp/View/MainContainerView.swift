//
//  MainContainerView.swift
//  BurnexApp
//
//  Created by Jojo on 09/02/2026.

import SwiftUI
import AVKit

struct MainContainerView: View {
    @State private var selectedTab = 0
    
    init() {
        // إخفاء التاب بار الأصلي لاستخدام المخصص
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                Color.black.overlay(Text("Analysis Screen").foregroundColor(.white))
                    .tag(1)
                
                Color.black.overlay(Text("Test Screen").foregroundColor(.white))
                    .tag(2)
            }
            
            // التاب بار المخصص
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Custom Tab Bar Components

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) { selectedTab = 0 }
            Spacer()
            TabBarButton(icon: "paperplane.fill", label: "Analysis", isSelected: selectedTab == 1) { selectedTab = 1 }
            Spacer()
            TabBarButton(icon: "pills.fill", label: "Test", isSelected: selectedTab == 2) { selectedTab = 2 }
        }
        .padding(.horizontal, 40)
        .frame(width: 350, height: 75)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .clipShape(Capsule())
        .padding(.bottom, 25)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 22))
                Text(label).font(.caption2)
            }
            .foregroundColor(isSelected ? .purple : .gray)
        }
    }
}

// MARK: - Video Looper (Infinite)

struct VideoLoopPlayer: UIViewControllerRepresentable {
    let fileName: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = UIColor.clear
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else {
            return controller
        }
        
        let player = AVPlayer(url: url)
        controller.player = player
        
        // منع المشغل من إغلاق المقطع عند نهايته
        player.actionAtItemEnd = .none

        // إضافة مراقب لنهاية الفيديو لإعادته للبداية وتشغيله فوراً
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play()
        player.isMuted = true
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

// MARK: - Visual Effects

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
