//
//  Extension+View.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI

/// A View extension that applies a blur, opacity, and scale effect based on a boolean condition.
///
/// This modifier is  for animating transitions by making a view
/// appear and disappear smoothly with a blur and scale effect.
///
/// - Parameter show: A Boolean value that determines whether the view
///   should be fully visible (`true`) or blurred and faded out (`false`).
/// - Returns: A modified view with applied blur, opacity, and scale transformations.
extension View {
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}


extension UIView {
    var scrollView: UIScrollView? {
        if let superview, superview is UIScrollView {
            return superview as? UIScrollView
        }

        return superview?.scrollView
    }
}
