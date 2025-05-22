//
//  InfiniteScrollView.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI

struct InfiniteScrollView<Content: View>: View {

    var spacing: CGFloat = 10

    @ViewBuilder var content: Content
    /// View Properties
    @State private var contentSize: CGSize = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    Group(subviews: content) { collection in
                        /// Original Content
                        HStack(spacing: spacing) {
                            ForEach(collection) { view in
                                view
                            }
                        }
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: { newValue in
                            contentSize = .init(
                                width: newValue.width + spacing,
                                height: newValue.height)
                        }
                        /// Repeating Content for creating Infinite(Looping) ScrollView
                        let averageWidth =
                            contentSize.width / CGFloat(collection.count)
                        let repeatingCount =
                            contentSize.width > 0
                            ? Int((size.width / averageWidth).rounded()) + 1 : 1

                        HStack(spacing: spacing) {
                            ForEach(0..<repeatingCount, id: \.self) {
                                repetition in
                                ForEach(collection) { view in
                                    view
                                }

                            }
                        }
                    }
                }
            }
            .background(
                InfiniteScrollHelper(
                    contentSize: $contentSize, declarationRate: .constant(.fast)
                ))
        }
    }
}

#Preview {
    ContentView()
}

private struct InfiniteScrollHelper: UIViewRepresentable {

    @Binding var contentSize: CGSize
    @Binding var declarationRate: UIScrollView.DecelerationRate

    func makeCoordinator() -> Coordinator {
        Coordinator(
            declarationRate: declarationRate,
            contentSize: contentSize
        )
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        DispatchQueue.main.async {
            if let scrollView = view.scrollView {
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.decelerationRate = declarationRate
                scrollView.delegate = context.coordinator
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.declarationRate = declarationRate
        context.coordinator.contentSize = contentSize
    }

    class Coordinator: NSObject, UIScrollViewDelegate {

        var declarationRate: UIScrollView.DecelerationRate
        var contentSize: CGSize

        init(
            declarationRate: UIScrollView.DecelerationRate,
            contentSize: CGSize
        ) {
            self.declarationRate = declarationRate
            self.contentSize = contentSize
        }

        /// Storing default SwiftUI delegate

        weak var defaultDelegate: UIScrollViewDelegate?

        func scrollViewDidScroll(_ scrollView: UIScrollView) {

            scrollView.decelerationRate = declarationRate

            let minX = scrollView.contentOffset.x

            if minX > contentSize.width {
                scrollView.contentOffset.x -= contentSize.width
            }

            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }

            /// Calling default Delegate
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }

        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView, willDecelerate decelerate: Bool
        ) {
            defaultDelegate?.scrollViewDidEndDragging?(
                scrollView, willDecelerate: decelerate)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }

        func scrollViewWillEndDragging(
            _ scrollView: UIScrollView, withVelocity velocity: CGPoint,
            targetContentOffset: UnsafeMutablePointer<CGPoint>
        ) {
            defaultDelegate?.scrollViewWillEndDragging?(
                scrollView,
                withVelocity: velocity,
                targetContentOffset: targetContentOffset)
        }
    }
}


