//
//  IntroPage.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI

struct IntroPage: View {
    /// View Properties
    @State private var activeCard: Card? = cards.first
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @State private var initialAnimation: Bool = false
    @State private var titleProgress: CGFloat = 0
    
    @Binding var showMain: Bool
    
    var body: some View {
        
        ZStack {
            /// Ambient Background View
            AmbientBackground()
                .animation(.easeIn(duration: 1), value: activeCard)
            
            VStack(spacing: 40) {
                MainContent()
                TextSection()
            }
            .safeAreaPadding(15)
        }
        
        .onReceive(timer) { _ in
            currentScrollOffset += 0.35
            scrollPosition.scrollTo(x: currentScrollOffset)
        }
        .task {
            try? await Task.sleep(for: .seconds(0.35))
            
            withAnimation(.smooth(duration: 0.75)) {
                initialAnimation = true
            }
            
            withAnimation(.smooth(duration: 2.5, extraBounce: 0).delay(0.3)) {
                titleProgress = 1
            }
        }
    }
    
    @ViewBuilder
    private func MainContent() -> some View {
        InfiniteScrollView {
            ForEach(cards) { card in
                CarouselCardView(card)
            }
        }
        .scrollIndicators(.hidden)
        .scrollPosition($scrollPosition)
        .containerRelativeFrame(.vertical) { value, _ in
            value * 0.45
        }
        .onScrollGeometryChange(for: CGFloat.self) {
            $0.contentOffset.x + $0.contentInsets.leading
        } action: { oldValue, newValue in
            currentScrollOffset = newValue
            
            let activeIndex = Int((currentScrollOffset / 220).rounded()) % cards.count
            activeCard = cards[activeIndex]
        }
        
        .visualEffect { [initialAnimation] content, proxy in
            content
                .offset(y: !initialAnimation ? -(proxy.size.height + 200) : 0)
        }
    }
    
    @ViewBuilder
    private func TextSection() -> some View {
        VStack(spacing: 8) {
            Text("Welcome to")
                .foregroundStyle(.secondary)
                .blurOpacityEffect(initialAnimation)
            Text("Discover Hidden Places")
                .font(.title)
                .foregroundStyle(.white)
                .textRenderer(TitleTextRender(progress: titleProgress))
                .padding(.bottom, 4)
            
            Text("Explore local gems, tech spots, and favorite \ncafes nearby. Let's find something cool \njust around the corner.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.secondary)
                .blurOpacityEffect(initialAnimation)
        }
        
        Button {
            /// cancel timer
            timer.upstream.connect().cancel()
            showMain = true
        } label: {
            Text("Continue")
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 65)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial, in: .capsule)
        }
        .blurOpacityEffect(initialAnimation)
    }
    
    @ViewBuilder
    private func AmbientBackground() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(cards) { card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .frame(width: size.width, height: size.height)
                    /// Show only active card
                        .opacity(activeCard?.id == card.id ? 1 : 0)
                }
                
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .ignoresSafeArea()
            }
            .compositingGroup()
            .blur(radius: 90, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    /// Carousel Card View
    @ViewBuilder
    private func CarouselCardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
        }
        
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
}

#Preview {
    IntroPage(showMain: .constant(true))
}
