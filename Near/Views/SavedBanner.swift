//
//  SavedBanner.swift
//  Near
//
//  Created by Adnann Muratovic on 21.05.25.
//

import SwiftUI

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
