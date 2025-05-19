//
//  MainContentView.swift
//  Near
//
//  Created by Adnann Muratovic on 19.05.25.
//

import SwiftUI

struct MainContentView: View {
    private let defaultCardHeight: CGFloat = 250
    private let defaultCardCornerRadius: CGFloat = 20
    
    let cardData: [CardInfo]
    let onSave: (UUID) -> Void   // Changed to accept card ID
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(cardData) { info in
                CardView(
                    title: info.title,
                    description: info.description,
                    address: info.address,  // Use helper function to format address
                    height: defaultCardHeight,
                    cornerRadius: defaultCardCornerRadius,
                    isSaved: info.isSaved,  // Pass the saved state from the data model
                    onSave: { onSave(info.id) },  // Pass the card's ID when saving
                    backgroundColor: .gray.opacity(0.1)
                )
            }
        }
    }
}
