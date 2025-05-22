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
                main
                Spacer()
                buttomTitle
            }
            .padding()
        }
        .frame(height: 220)
    }

    /// Navigation - Category title & save button
    private var categoryTitle: some View {
        HStack {
            Text(vm.category)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .capsuleStyle(.orange)

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
    
    /// Main  - Description
    @ViewBuilder
    private var main: some View {
        if let description = vm.description, !description.isEmpty {
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    /// Bottom - Adress website & call button
    private var buttomTitle: some View {
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
            .capsuleStyle(.blue)
            
            // Open webiste
            Button { vm.openWebsite() } label: {
                Image(systemName: "link").font(.caption2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .capsuleStyle(.blue)
            Spacer()

            // Phone button
            Button { vm.callPhone() } label: {
                Image(systemName: "phone.fill").font(.caption2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .capsuleStyle(.green)
        }
    }
}


