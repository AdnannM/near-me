//
//  ContentView.swift
//  Near Me
//
//  Created by Adnann Muratovic on 08.05.25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showMainView = false

    var body: some View {
//        Group {
            if showMainView {
                TabHomeView() // Your main app UI
                    .animation(.easeIn, value: showMainView) // <- prevents animation transition
            } else {
                IntroPage(showMain: $showMainView)
                    .animation(.easeIn, value: showMainView) // <- prevents animation transition
            }
//        }
            
    }
}


#Preview {
    ContentView()
}

struct InfiniteScrollView<Content: View>: View {
    
    var spacing: CGFloat = 10
    
    @ViewBuilder var content: Content
    /// View Properties
    @State private var contentSize: CGSize = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    Group(subviews: content) { collection in
                        /// Original Content
                        HStack(spacing: spacing) {
                            ForEach(collection) { view in
                                view
                            }
                        }
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action : { newValue in
                            contentSize = .init(width: newValue.width + spacing, height: newValue.height)
                        }
                        /// Repeating Content for creating Infinite(Looping) ScrollView
                        let averageWidth = contentSize.width / CGFloat(collection.count)
                        let repeatingCount = contentSize.width > 0 ? Int((size.width / averageWidth).rounded()) + 1 : 1

                        HStack(spacing: spacing) {
                            ForEach(0..<repeatingCount, id: \.self) { repetition in
                                ForEach(collection) { view in
                                    view
                                }
                                
                            }
                        }
                    }
                }
            }
            .background(InfiniteScrollHelper(contentSize: $contentSize, declarationRate: .constant(.fast)))
        }
    }
}

#Preview {
    ContentView()
}


fileprivate struct InfiniteScrollHelper: UIViewRepresentable {
    
    @Binding var contentSize: CGSize
    @Binding var declarationRate: UIScrollView.DecelerationRate
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            declarationRate: declarationRate,
            contentSize: contentSize
        )
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let scrollView = view.scrollView {
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.decelerationRate = declarationRate
                scrollView.delegate = context.coordinator
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.declarationRate = declarationRate
        context.coordinator.contentSize = contentSize
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var declarationRate: UIScrollView.DecelerationRate
        var contentSize: CGSize
        
        init(
            declarationRate: UIScrollView.DecelerationRate,
            contentSize: CGSize)
        {
            self.declarationRate = declarationRate
            self.contentSize = contentSize
        }
        
        /// Storing default SwiftUI delegate
        
        weak var defaultDelegate: UIScrollViewDelegate?
        
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            scrollView.decelerationRate = declarationRate
            
            let minX = scrollView.contentOffset.x
            
            if minX > contentSize.width {
                scrollView.contentOffset.x  -= contentSize.width
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }
            
            /// Calling default Delegate
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            defaultDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            defaultDelegate?.scrollViewWillEndDragging?(
                scrollView,
                withVelocity: velocity,
                targetContentOffset: targetContentOffset)
        }
    }
}


extension UIView {
    var scrollView: UIScrollView? {
        if let superview, superview is UIScrollView {
            return superview as? UIScrollView
        }
        
        return superview?.scrollView
    }
}


import SwiftUI

struct TitleTextRender: TextRenderer, Animatable {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let slices = layout.flatMap({ $0 }).flatMap({ $0 })
        
        for (index, slice) in slices.enumerated() {
            let slicesProgressIndex = CGFloat(slices.count) * progress
            let sliceProgress = max(min(slicesProgressIndex / CGFloat(index + 1), 1), 0)
            
            ctx.addFilter(.blur(radius: 5 - (5 * sliceProgress)))
            ctx.opacity = sliceProgress
            ctx.translateBy(x: 0, y: 5 - (5 * sliceProgress))
            ctx.draw(slice, options: .disablesSubpixelQuantization)
        }
    }
}


struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
}

let cards: [Card] = [
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding")
]

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

/// A View extension that applies a blur, opacity, and scale effect based on a boolean condition.
///
/// This modifier is  for animating transitions by making a view
/// appear and disappear smoothly with a blur and scale effect.
///
/// - Parameter show: A Boolean value that determines whether the view
///   should be fully visible (`true`) or blurred and faded out (`false`).
/// - Returns: A modified view with applied blur, opacity, and scale transformations.
extension View {
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}


import SwiftUI

struct MainTabView: View {
    @State private var sectionTab: Tab = .home

    var body: some View {
        TabView(selection: $sectionTab) {
            ForEach(Tab.allCases) { tab in
                tab.view
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
        // Set the appearance of the Tab Bar
        .onAppear {
            // Configure TabBar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            // Optional: Customize background color
            appearance.backgroundColor = UIColor.systemBackground
            
            // Set the selected item color
            let itemAppearance = UITabBarItemAppearance(style: .stacked)
            itemAppearance.normal.iconColor = UIColor.gray
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            itemAppearance.selected.iconColor = UIColor.blue  // Change this to .red for red tabs
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.blue]  // Change this to .red for red tabs
            
            appearance.stackedLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .tint(.blue) // This works in conjunction with the UIKit settings above
    }
}

// Your existing Tab enum
enum Tab: Int, CaseIterable, Identifiable {
    case home, search, favorites, settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .favorites: return "heart"
        case .settings: return "gear"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            YouView()
        case .search:
            Text("Search View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .favorites:
            Text("Favorites View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
        case .settings:
            Text("Settings View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


import SwiftUI
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

struct YouView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.772181, longitude: 17.191),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var restaurants: [IdentifiableMapItem] = []
    @State private var selectedItem: IdentifiableMapItem? = nil

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(restaurants) { item in
                Annotation(item.mapItem.name ?? "Place", coordinate: item.mapItem.placemark.coordinate) {
                    Button(action: {
                        selectedItem = item
                    }) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
        .onAppear {
            searchNearbyRestaurants()
        }
        .sheet(item: $selectedItem) { item in
            VStack(spacing: 16) {
                Text(item.mapItem.name ?? "Unknown")
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 4) {
                    Text("📍 Address: \(item.mapItem.placemark.title ?? "N/A")")
                    Text("📞 Phone: \(item.mapItem.phoneNumber ?? "N/A")")
                    Text("🌍 Website: \(item.mapItem.url?.absoluteString ?? "N/A")")
                    Text("🗺️ City: \(item.mapItem.placemark.locality ?? "N/A")")
                    Text("🏙️ State: \(item.mapItem.placemark.administrativeArea ?? "N/A")")
                    Text("📮 ZIP: \(item.mapItem.placemark.postalCode ?? "N/A")")
                    Text("🇨🇴 Country: \(item.mapItem.placemark.country ?? "N/A")")
                    Text("🧭 Coords: \(item.mapItem.placemark.coordinate.latitude), \(item.mapItem.placemark.coordinate.longitude)")
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.4), .medium])
        }
    }

    private func searchNearbyRestaurants() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.772181, longitude: 17.191),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "shops"
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }

            if let mapItems = response?.mapItems {
                for item in mapItems {
                    print("Name: \(item.name ?? "Unknown")")
                    print("Phone: \(item.phoneNumber ?? "N/A")")
                    print("URL: \(item.url?.absoluteString ?? "No URL")")
                    print("Address: \(item.placemark.title ?? "No address")")
                    print("City: \(item.placemark.locality ?? "N/A")")
                    print("State: \(item.placemark.administrativeArea ?? "N/A")")
                    print("ZIP: \(item.placemark.postalCode ?? "N/A")")
                    print("Country: \(item.placemark.country ?? "N/A")")
                    print("Coordinates: \(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)")
                    print("---------")
                }

                restaurants = mapItems.map { IdentifiableMapItem(mapItem: $0) }
            }
        }
    }
}

#Preview {
    YouView()
}

