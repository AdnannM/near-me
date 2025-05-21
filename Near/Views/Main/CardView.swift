//
//  CardView.swift
//  Near
//
//  Created by Adnann Muratovic on 19.05.25.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var vm: CardViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.1))

            // Content
            VStack(alignment: .leading, spacing: 8) {

                categoryTitle

                if let description = vm.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 6) {
                    // Left capsule tag (icon + address)
                    HStack(spacing: 4) {
                        Image(systemName: "map")
                            .font(.caption)

                        Text(vm.address)
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
                    
                    // Open webiste
                    Button { vm.openWebsite() } label: {
                        Image(systemName: "link").font(.caption2)
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

                    // Phone button
                    Button { vm.callPhone() } label: {
                        Image(systemName: "phone.fill").font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.green.opacity(0.12)))
                    .overlay(
                        Capsule().stroke(
                            Color.green.opacity(0.25), lineWidth: 0.5)
                    )
                    .foregroundColor(.green)
                }
            }
            .padding()
        }
        .frame(height: 220)
    }

    // Category title
    private var categoryTitle: some View {
        HStack {
            Text(vm.category)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.orange.opacity(0.12))
                )
                .overlay(
                    Capsule()
                        .stroke(Color.orange.opacity(0.25), lineWidth: 0.5)
                )
                .foregroundColor(.orange)

            Text(vm.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)  // Adapts to light/dark mode

            Spacer()

            // Right icon button
            Button {
                vm.toggleSaved()
            } label: {
                Image(systemName: "bookmark.circle")
                    .font(.title)
            }
            .foregroundColor(vm.isSaved ? .blue.opacity(0.25) : .white)
        }
    }
}

