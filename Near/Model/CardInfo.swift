//
//  CardInfo.swift
//  Near
//
//  Created by Adnann Muratovic on 16.05.25.
//

import Foundation

// Example data for the cards
struct CardInfo: Identifiable {
    let id = UUID()
    let title: String
    let description: String?
}
