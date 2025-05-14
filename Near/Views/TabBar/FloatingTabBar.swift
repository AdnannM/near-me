//
//  FloatingTabBar.swift
//  Near Me
//
//  Created by Adnann Muratovic on 13.05.25.
//

import SwiftUI

protocol FloatingTabProtocol {
    var symbolImage: String { get }
}

struct FloatingTabBar<
    Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol
>: View where Value.AllCases: RandomAccessCollection {

    @Binding var selection: Value
    var config: FloatingTabConfig
    var content: (Value, CGFloat) -> Content

    init(
        config: FloatingTabConfig = .init(), selection: Binding<Value>,
        @ViewBuilder content: @escaping (Value, CGFloat) -> Content
    ) {
        self.config = config
        self._selection = selection
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                /// New
                SwiftUI.TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.self) { tab in
                        content(tab, 0)
                            .tag(tab)
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                /// Old
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        content(tab, 0)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }

            FloatingTabView(config: config, activeTab: $selection)
                .padding(.horizontal, config.hPadding)
                .padding(.bottom, config.bPadding)
        }
    }
}

private struct FloatingTabView<
    Value: CaseIterable & Hashable & FloatingTabProtocol
>: View where Value.AllCases: RandomAccessCollection {

    var config: FloatingTabConfig
    @Binding var activeTab: Value
    @Namespace private var animation
    @State private var toggleSymbolEffect: [Bool] = Array(
        repeating: false, count: Value.allCases.count)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Value.allCases, id: \.hashValue) { tab in
                let isActive = activeTab == tab
                let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0

                Image(systemName: tab.symbolImage)
                    .font(.title3)
                    .foregroundStyle(
                        isActive ? config.activeTint : config.inactiveTint
                    )
                    .symbolEffect(
                        .bounce.byLayer.down, value: toggleSymbolEffect[index]
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .background {
                        if isActive {
                            Capsule(style: .continuous)
                                .fill(config.activeBackgroundTint.gradient)
                                .matchedGeometryEffect(
                                    id: "ACTIVETAB", in: animation)
                        }
                    }

                    .onTapGesture {
                        activeTab = tab
                        toggleSymbolEffect[index].toggle()
                    }
                    .padding(.vertical, config.insetAmount)
            }
        }
        .padding(.horizontal, config.insetAmount)
        .frame(height: 50)
        .background {
            ZStack {
                if config.isTransluent {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.background)
                }

                Rectangle()
                    .fill(config.backgroundColor)
            }
        }
        .clipShape(.capsule(style: .continuous))
        .animation(config.tabAnimation, value: activeTab)
    }
}

#Preview {
    TabHomeView()
}
