//
//  CardViewModel.swift
//  Near
//
//  Created by Adnann Muratovic on 21.05.25.
//

import SwiftUI
import MapKit

@MainActor
@Observable
final class CardViewModel: Identifiable,ObservableObject {
    let id: UUID
    let category: String
    let title: String
    let description: String?
    let address: String
    let phoneURL: URL?
    let websiteURL: URL?
    var isSaved: Bool

    init(info: CardInfo) {
        id = info.id
        category = info.category
        title = info.title
        description = info.description
        address = info.address
        phoneURL = URL(string: "tel://\(info.phone)")
        websiteURL = URL(string: info.url)
        isSaved = info.isSaved
    }

    func toggleSaved() {
        isSaved.toggle()
        // TODO: persist via SwiftData later
    }

    func openMap() {
        let geo = CLGeocoder()
        geo.geocodeAddressString(address) { marks, _ in
            guard let coord = marks?.first?.location?.coordinate else { return }
            let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
            item.name = self.title
            item.openInMaps()
        }
    }

    func openWebsite() {
        guard let url = websiteURL else { return }
        UIApplication.shared.open(url)
    }

    func callPhone() {
        guard let url = phoneURL else { return }
        UIApplication.shared.open(url)
    }
}
