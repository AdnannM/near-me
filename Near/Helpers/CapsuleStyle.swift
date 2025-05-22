//
//  CapsuleStyle.swift
//  Near
//
//  Created by Adnann Muratovic on 22.05.25.
//

import SwiftUI

private struct CapsuleStyle: ViewModifier {
    let baseColor: Color
    let fillOpacity: Double
    let strokeOpacity: Double
    let strokeWidth: CGFloat

    init(
        _ baseColor: Color,
        fillOpacity: Double = 0.12,
        strokeOpacity: Double = 0.25,
        strokeWidth: CGFloat = 0.5
    ) {
        self.baseColor     = baseColor
        self.fillOpacity   = fillOpacity
        self.strokeOpacity = strokeOpacity
        self.strokeWidth   = strokeWidth
    }

    func body(content: Content) -> some View {
        content
            .background(
                Capsule()
                    .fill(baseColor.opacity(fillOpacity))
            )
            .overlay(
                Capsule()
                    .stroke(baseColor.opacity(strokeOpacity),
                            lineWidth: strokeWidth)
            )
            .foregroundColor(baseColor)
    }
}

// MARK: - Ergonomic sugar

extension View {
    /// Apply the reusable capsule decoration.
    /// Usage: `Text("Hi").capsuleStyle(.blue)`
    func capsuleStyle(
        _ color: Color,
        fillOpacity: Double = 0.12,
        strokeOpacity: Double = 0.25,
        strokeWidth: CGFloat = 0.5
    ) -> some View {
        modifier(
            CapsuleStyle(
                color,
                fillOpacity: fillOpacity,
                strokeOpacity: strokeOpacity,
                strokeWidth: strokeWidth
            )
        )
    }
}
