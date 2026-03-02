import SwiftUI
import AVKit

struct HomeView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 1. خلفية التطبيق
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()

                // 2. محتوى الصفحات بناءً على التاب المختار
                Group {
                    if selectedTab == 0 {
                        homeContent
                    } else if selectedTab == 1 {
                        AnalysisView()
                    } else if selectedTab == 2 {
                        TestView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
        }
    }
    
    var homeContent: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 90)

                Text("Your Status Right Now")
                    .font(.system(size: 22))
                    .foregroundColor(.grayApp)
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                
                if viewModel.showStressAlert {
                    glassyAlert
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // منطقة الكرة التفاعلية والأزرار - ممركزة في المنتصف
            ZStack {
                Circle()
                    .foregroundStyle(.ball)
                    .frame(width: 300, height: 300)
                    .cornerRadius(90000)
                
                VideoLoopPlayer(fileName: "Ball2")
                    .blendMode(.luminosity)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
                
                StatFlipButton(stat: viewModel.stats[0], pos: CGPoint(x: 90, y: -100)) {
                    viewModel.flipCard(at: 0)
                }
                
                StatFlipButton(stat: viewModel.stats[1], pos: CGPoint(x: -90, y: -40)) {
                    viewModel.flipCard(at: 1)
                }
                
                StatFlipButton(stat: viewModel.stats[2], pos: CGPoint(x: 90, y: 80)) {
                    viewModel.flipCard(at: 2)
                }
            }
            .offset(y: -20)
            
            Spacer(minLength: 120)
        }
        .animation(.spring(), value: viewModel.showStressAlert)
    }

    var glassyAlert: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))
            Text("Elevated Stress Detected Take a quick check in?")
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 15)
        .frame(width: 330, height: 71)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 0.5))
    }
}

// MARK: - Subviews

struct StatFlipButton: View {
    let stat: StatModel
    let pos: CGPoint
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(stat.isFlipped ? stat.value : stat.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 110, height: 45)
                // استعادة التصميم الزجاجي الأصلي
                .glassEffect(in: .rect(cornerRadius: 100))
                .background(.white.opacity(0.1))
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
        .offset(x: pos.x, y: pos.y)
    }
}

#Preview {
    HomeView()
}
#Preview{
    HomeView()
}
