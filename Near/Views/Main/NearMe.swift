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

struct NearMe: View {

    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animation
    @FocusState private var isSearching: Bool

    @State private var showSavedBanner: Bool = false
    @State private var cardDataState: [CardInfo] = []
    @State private var searchText: String = ""
    @State private var activeTab: Tab = .food
    @State private var listVM = CardListViewModel()

    var body: some View {
        ZStack(alignment: .top) {
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
            .zIndex(0)  // Set base layer z-index

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
            ForEach(listVM.cards) { vm in
                CardView(vm: vm)
                    .onChange(of: vm.isSaved) {
                        if vm.isSaved {
                            withAnimation { showSavedBanner = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                withAnimation { showSavedBanner = false }
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NearMe()
}
