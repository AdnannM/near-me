//
//  NearMe.swift
//  Near
//
//  Created by Adnann Muratovic on 15.05.25.
//

import SwiftUI

struct NearMe: View {
    
    @State private var searchText: String = ""
    @State private var activeTab: Tab = .food
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animation
    @FocusState private var isSearching: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                mainView
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                navigationView
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        }
        .background(.gray.opacity(0.15))
    }
    
    /// Navigation
    @ViewBuilder
    var navigationView: some View {
        GeometryReader { proxy in
            
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let progress = isSearching ? 1 : max(min(-minY / 70, 1), 0)
            
            VStack(spacing: 10) {
                
                Text("Near Me")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search Near Me", text: $searchText)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button {
                            isSearching = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15))
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .padding(.vertical, 8)
                                    .foregroundStyle(activeTab == tab ? (colorScheme == .dark ? .black : .white) : Color.primary)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 50)
            }
            .padding(.top, 25)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.horizontal, 15)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    /// Main View
    @ViewBuilder
    var mainView: some View {
        VStack(spacing: 12) {
            MainContentView(cardData: getCardData(for: activeTab))
        }
    }
    
    func getCardData(for tab: Tab) -> [MainContentView.CardInfo] {
        switch tab {
        case .food:
            return [
                .init(title: "Pizza Palace", description: "Delicious cheesy pizzas made fresh."),
                .init(title: "Sushi Central", description: "Fresh sushi and sashimi every day."),
                .init(title: "Burger Barn", description: "Juicy burgers with crispy fries.")
            ]
        case .store:
            return [
                .init(title: "Local Mart", description: "Groceries and daily essentials."),
                .init(title: "Tech Stop", description: "Gadgets and accessories."),
                .init(title: "Book Nook", description: "Find your next great read.")
            ]
        case .gas:
            return [
                .init(title: "Shell Station", description: "Reliable fuel and quick snacks."),
                .init(title: "GreenFuel", description: "Eco-friendly fuel solutions."),
                .init(title: "QuickPump", description: "Fast service, open 24/7.")
            ]
        case .charging:
            return [
                .init(title: "SuperCharge Point", description: "Charge your EV in minutes."),
                .init(title: "VoltZone", description: "Multiple chargers available."),
                .init(title: "EcoCharge", description: "Solar-powered EV charging station.")
            ]
        }
    }
}

struct MainContentView: View {

    private let defaultCardHeight: CGFloat = 250
    private let defaultCardCornerRadius: CGFloat = 20
    let cardData: [CardInfo]

    // Example data for the cards
    struct CardInfo: Identifiable {
        let id = UUID()
        let title: String
        let description: String?
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(cardData) { info in
                CardView(
                    title: info.title,
                    description: info.description,
                    height: defaultCardHeight,
                    cornerRadius: defaultCardCornerRadius
                )
            }
        }
    }
}

struct CardView: View {
    let title: String
    let description: String?
    let height: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color

    init(title: String,
         description: String? = nil,
         height: CGFloat = 250,
         cornerRadius: CGFloat = 20,
         backgroundColor: Color = .gray.opacity(0.1)) {
        self.title = title
        self.description = description
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Adapts to light/dark mode

                if let description = description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3) // Limit description lines
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: height)
    }
}

#Preview {
    NearMe()
}

