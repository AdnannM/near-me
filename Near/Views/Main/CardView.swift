//
//  CardView.swift
//  Near
//
//  Created by Adnann Muratovic on 19.05.25.
//

import SwiftUI

struct CardView: View {
    let title: String
    let description: String?
    let height: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let address: String
    let isSaved: Bool  // Now accepts isSaved as a parameter instead of using internal state
    let onSave: () -> Void
    
    init(
        title: String,
        description: String? = nil,
        address: String,
        height: CGFloat = 250,
        cornerRadius: CGFloat = 20,
        isSaved: Bool = false,  // Default to false
        onSave: @escaping () -> Void,
        backgroundColor: Color = .gray.opacity(0.1)
    ) {
        self.title = title
        self.description = description
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.address = address
        self.isSaved = isSaved
        self.onSave = onSave
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)  // Adapts to light/dark mode

                if let description = description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)  // Limit description lines
                }
                Spacer()
                
                HStack(spacing: 6) {
                    // Left capsule tag (icon + address)
                    HStack(spacing: 4) {
                        Image(systemName: "map")
                            .font(.caption)

                        Text(address)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.12))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.blue.opacity(0.25), lineWidth: 0.5)
                    )
                    .foregroundColor(.blue)

                    Spacer()
                    
                    // Right icon button
                    Button {
                        // Just call onSave, the parent will handle toggling the state
                        onSave()
                    } label: {
                        Image(systemName:"bookmark.circle")
                            .font(.title)
                            .padding(8)
                    }
                    .foregroundColor(isSaved ? .blue.opacity(0.25) : .white)
                }
            }
            .padding()
        }
        .frame(height: height)
    }
}
