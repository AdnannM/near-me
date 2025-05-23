//
//  FloatingTabConfig.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI

struct FloatingTabConfig {
    var activeTint: Color = .white
    var activeBackgroundTint: Color = .blue
    var inactiveTint: Color = .gray
    var tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0)
    var backgroundColor: Color = .gray.opacity(0.1)
    var insetAmount: CGFloat = 6
    var isTransluent: Bool = true
    var hPadding: CGFloat = 15
    var bPadding: CGFloat = 5
}
