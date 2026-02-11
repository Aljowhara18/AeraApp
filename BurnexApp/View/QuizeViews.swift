//
//  QuizeViews.swift
//  najla
//
//  Created by Najla Almuqati on 21/08/1447 AH.
//

import SwiftUI
import AVKit

struct QuestionCard: View { let text: String; @Binding var selected: Int?; let options = ["Never", "Rarely", "Sometimes", "Often", "Always"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            // نص السؤال - خليته يأخذ مساحة أكبر فوق
            Text(text)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
            
            // خيارات الإجابة
            VStack(alignment: .leading, spacing: 28) {
                ForEach(0..<options.count, id: \.self) { index in
                    Button(action: { selected = index }) {
                        HStack(spacing: 18) {
                            // تصميم الـ Radio Button المطابق للصورة
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                    .frame(width: 26, height: 26)
                                
                                if selected == index {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 14, height: 14)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                        .frame(width: 26, height: 26)
                                }
                            }
                            
                            Text(options[index])
                                .font(.system(size: 20))
                                .foregroundColor(selected == index ? .white : .white.opacity(0.5))
                            
                            Spacer()
                        }
                    }
                }
            }
            // سبيسر داخلي عشان يدفع الخيارات لفوق ويخلي الكارد يبدو أطول
            Spacer(minLength: 20)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 40)
        // تحديد حجم الكارد (الشيت)
        .frame(maxWidth: .infinity)
        .frame(height: 520) // هذا الرقم يتحكم في طول الكارد ليصبح مثل الشيت
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.white.opacity(0.06)) // شفافية خفيفة جداً
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

// هذا الكود هو المحرك الذي يشغل فيديو الكرة بشكل مستمر (Loop)
struct QuizVideoLoopPlayer: UIViewControllerRepresentable {
    let fileName: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else { return controller }
        
        let player = AVPlayer(url: url)
        controller.player = player
        player.actionAtItemEnd = .none
        player.isMuted = true
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
