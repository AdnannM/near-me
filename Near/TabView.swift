//
//  TabView.swift
//  Near Me
//
//  Created by Adnann Muratovic on 13.05.25.
//

import SwiftUI

enum AppTab: String, CaseIterable, FloatingTabProtocol {
    
    case you = "You"
    case nearMe = "Near Me"
    case saved = "Saved"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .you:
            "memories"
        case .nearMe:
            "memories"
        case .saved:
            "memories"
        case .settings:
            "memories"
        }
    }
}

struct TabHomeView: View {
    
    @State private var appTab: AppTab = .you
    
    var body: some View {
        FloatingTabBar(selection: $appTab) { tab, tabBarHeight in
            switch tab {
            case .you:
                YouView()
            case .nearMe:
                Text("Near Me")
            case .saved:
                Text("Saved")
            case .settings:
                Text("Settings")
            }
        }
    }
}

#Preview {
    TabHomeView()
}
