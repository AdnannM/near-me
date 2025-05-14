//
//  TealGlassBackground.swift
//  Near Me
//
//  Created by Adnann Muratovic on 08.05.25.
//

import SwiftUI

struct TealGlassBackground: View {
    var body: some View {
        ZStack {
            // Deep teal base color
            Color(red: 0.01, green: 0.12, blue: 0.15)
                .opacity(0.85)
            
            // Glass material effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.1)
        }
        .blur(radius: 220)
    }
}
