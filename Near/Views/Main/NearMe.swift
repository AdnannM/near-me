//
//  NearMe.swift
//  Near
//
//  Created by Adnann Muratovic on 15.05.25.
//

import SwiftUI

// 3. The flow of data and state:
// - NearMe view holds the cardDataState array
// - MainContentView passes each card's data to CardView
// - CardView displays the isSaved state (doesn't manage it)
// - When bookmark button is clicked:
//   - CardView calls onSave()
//   - MainContentView passes the card ID to NearMe
//   - NearMe updates the card's isSaved state and shows banner if needed
//   - SwiftUI automatically redraws CardView with the new state

// This structure ensures that the bookmark state persists and the button stays blue
// until explicitly toggled off by the user.

struct SavedBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Saved")
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.top, 10)
        .padding(.horizontal)
    }
}


struct NearMe: View {
    @State private var searchText: String = ""
    @State private var activeTab: Tab = .food
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animation
    @FocusState private var isSearching: Bool
    @State private var showSavedBanner: Bool = false
    @State private var cardDataState: [CardInfo] = []  // State to hold and manage card data

    var body: some View {
        ZStack(alignment: .top) { // Set alignment to .top to position items at the top
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    mainView
                }
                .safeAreaPadding(15)
                .safeAreaInset(edge: .top, spacing: 0) {
                    navigationView
                }
                .animation(
                    .snappy(duration: 0.3, extraBounce: 0), value: isSearching)
            }
            .background(.gray.opacity(0.15))
            .onAppear {
                // Initialize card data state when view appears
                if cardDataState.isEmpty {
                    cardDataState = getCardData(for: activeTab)
                }
            }
            .onChange(of: activeTab) { oldValue, newValue in
                // Update card data when tab changes
                cardDataState = getCardData(for: newValue)
            }
            .zIndex(0) // Set base layer z-index
            
            if showSavedBanner {
                SavedBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10) 
            }
        }
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
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .bottom),
                                removal: .push(from: .top)))
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
                        .shadow(
                            color: .gray.opacity(0.25), radius: 5, x: 0, y: 5
                        )
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
                                    .foregroundStyle(
                                        activeTab == tab
                                            ? (colorScheme == .dark
                                                ? .black : .white)
                                            : Color.primary
                                    )
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(
                                                    id: "ACTIVETAB",
                                                    in: animation)
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
                .scrollIndicators(.hidden)
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
            MainContentView(
                cardData: cardDataState,
                onSave: { cardId in
                    // Find and update the card with the given ID
                    if let index = cardDataState.firstIndex(where: { $0.id == cardId }) {
                        // Toggle the saved state
                        cardDataState[index].isSaved.toggle()
                        
                        // Only show banner if we're saving (not unsaving)
                        if cardDataState[index].isSaved {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showSavedBanner = true
                            }
                            
                            // Auto hide after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    showSavedBanner = false
                                }
                            }
                        }
                    }
                }
            )
        }
    }
}

struct MainContentView: View {
    private let defaultCardHeight: CGFloat = 250
    private let defaultCardCornerRadius: CGFloat = 20
    
    let cardData: [CardInfo]
    let onSave: (UUID) -> Void   // Changed to accept card ID
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(cardData) { info in
                CardView(
                    title: info.title,
                    description: info.description,
                    address: info.address,  // Use helper function to format address
                    height: defaultCardHeight,
                    cornerRadius: defaultCardCornerRadius,
                    isSaved: info.isSaved,  // Pass the saved state from the data model
                    onSave: { onSave(info.id) },  // Pass the card's ID when saving
                    backgroundColor: .gray.opacity(0.1)
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
    let address: String
    let isSaved: Bool  // Now accepts isSaved as a parameter instead of using internal state
    let onSave: () -> Void
    
    init(
        title: String,
        description: String? = nil,
        address: String,
        height: CGFloat = 250,
        cornerRadius: CGFloat = 20,
        isSaved: Bool = false,  // Default to false
        onSave: @escaping () -> Void,
        backgroundColor: Color = .gray.opacity(0.1)
    ) {
        self.title = title
        self.description = description
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.address = address
        self.isSaved = isSaved
        self.onSave = onSave
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
                    .foregroundColor(.primary)  // Adapts to light/dark mode

                if let description = description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)  // Limit description lines
                }
                Spacer()
                
                HStack(spacing: 6) {
                    // Left capsule tag (icon + address)
                    HStack(spacing: 4) {
                        Image(systemName: "map")
                            .font(.caption)

                        Text(address)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.12))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.blue.opacity(0.25), lineWidth: 0.5)
                    )
                    .foregroundColor(.blue)

                    Spacer()
                    
                    // Right icon button
                    Button {
                        // Just call onSave, the parent will handle toggling the state
                        onSave()
                    } label: {
                        Image(systemName:"bookmark.circle")
                            .font(.title)
                            .padding(8)
                    }
                    .foregroundColor(isSaved ? .blue.opacity(0.25) : .white)
                }
            }
            .padding()
        }
        .frame(height: height)
    }
}

#Preview {
    NearMe()
}
