//
//  Untitled.swift
//  Near
//
//  Created by Adnann Muratovic on 21.05.25.
//

import Observation

@MainActor
@Observable
final class CardListViewModel {
    var selectedTab: Tab = .food { didSet { loadData() } }
    var cards: [CardViewModel] = []

    init() {
        loadData()
    }

    func loadData() {
        cards = getCardData(for: selectedTab)
            .map(CardViewModel.init)
    }
}
