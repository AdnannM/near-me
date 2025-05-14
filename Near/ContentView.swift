//
//  ContentView.swift
//  Near Me
//
//  Created by Adnann Muratovic on 08.05.25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var showMainView = false

    var body: some View {
        if showMainView {
            TabHomeView()
                .animation(.easeIn, value: showMainView)
        } else {
            IntroPage(showMain: $showMainView)
                .animation(.easeIn, value: showMainView)
        }
    }
}

#Preview {
    ContentView()
}
