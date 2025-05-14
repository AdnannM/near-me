//
//  Card.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
}

let cards: [Card] = [
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding"),
    .init(image: "onboarding")
]
