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
//            let scrollViewHeight =
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
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(width: .infinity, height: 250)
                .cornerRadius(20)
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(width: .infinity, height: 250)
                .cornerRadius(20)
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(width: .infinity, height: 250)
                .cornerRadius(20)
        }
    }
}


#Preview {
    NearMe()
}


//struct CustomScrollTargetBehaviour: ScrollTargetBehavior {
//    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
//        if target.rect.minY < 70 {
//            if target.rect.maxY < 35 {
//                target.rect.origin = .zero
//            } else {
//                target.rect.origin = .init(x: 0, y: 70)
//            }
//        }
//    }
//
//}

enum Tab: String, CaseIterable {
    case food = "Food"
    case store = "Store"
    case gas = "Gas"
    case charging = "Charging"
}
