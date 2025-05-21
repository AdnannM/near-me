//
//  CardInfo.swift
//  Near
//
//  Created by Adnann Muratovic on 16.05.25.
//

import Foundation

struct CardInfo: Identifiable {
    let id = UUID()
    let category: String      
    let title: String
    let description: String?
    let phone: String
    let url: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let country: String
    let coordinates: (Double, Double)
    var isSaved: Bool = false
}

func getCardData(for tab: Tab) -> [CardInfo] {
    switch tab {
    case .food:
        return [
            CardInfo(
                category: "Restaurant",
                title: "Pizza Bar La Strada",
                description: "Cozy pizzeria with local charm and great pizza.",
                phone: "+387 65 059 535",
                url: "https://wevotravel.com/caffe-bar/la-strada/",
                address: "Vidovdanska 17",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7745577, 17.1912788)
            ),
            CardInfo(
                category: "Steakhouse",
                title: "Grill House Banja",
                description: "Traditional Balkan grilled meats and local drinks.",
                phone: "+387 65 123 456",
                url: "https://example.com/grill-banja",
                address: "Kralja Petra I Karađorđevića 55",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7720000, 17.1900000)
            ),
            CardInfo(
                category: "Bistro",
                title: "Urban Bistro",
                description: "Modern cuisine in a stylish downtown setting.",
                phone: "+387 65 654 321",
                url: "https://example.com/urban-bistro",
                address: "Gundulićeva 12",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7750000, 17.1950000)
            )
        ]
    case .store:
        return [
            CardInfo(
                category: "Grocery",
                title: "Local Mart",
                description: "Groceries and daily essentials.",
                phone: "+387 51 101 101",
                url: "https://example.com/local-mart",
                address: "Ulica Svetozara Markovića 15",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7738, 17.1935)
            ),
            CardInfo(
                category: "Electronics",
                title: "Tech Stop",
                description: "Gadgets and accessories.",
                phone: "+387 51 202 202",
                url: "https://example.com/tech-stop",
                address: "Bulevar Vojvode Stepe 45",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7715, 17.1898)
            ),
            CardInfo(
                category: "Bookstore",
                title: "Book Nook",
                description: "Find your next great read.",
                phone: "+387 51 303 303",
                url: "https://example.com/book-nook",
                address: "Aleja Svetog Save 33",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7761, 17.1962)
            )
        ]
    case .gas:
        return [
            CardInfo(
                category: "Gas Station",
                title: "Shell Station",
                description: "Reliable fuel and quick snacks.",
                phone: "+387 51 111 111",
                url: "https://example.com/shell-station",
                address: "Kninska bb",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7690, 17.1850)
            ),
            CardInfo(
                category: "Gas Station",
                title: "GreenFuel",
                description: "Eco-friendly fuel solutions.",
                phone: "+387 51 222 222",
                url: "https://example.com/greenfuel",
                address: "Obilićevo 9",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7708, 17.1874)
            ),
            CardInfo(
                category: "Gas Station",
                title: "QuickPump",
                description: "Fast service, open 24/7.",
                phone: "+387 51 333 333",
                url: "https://example.com/quickpump",
                address: "Slatinska 14",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7755, 17.1823)
            )
        ]
    case .charging:
        return [
            CardInfo(
                category: "EV Charging",
                title: "SuperCharge Point",
                description: "Charge your EV in minutes.",
                phone: "+387 51 444 444",
                url: "https://example.com/supercharge",
                address: "Braće Mažar i Majke Marije 1",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7741, 17.1880)
            ),
            CardInfo(
                category: "EV Charging",
                title: "VoltZone",
                description: "Multiple chargers available.",
                phone: "+387 51 555 555",
                url: "https://example.com/voltzone",
                address: "Ivana Franje Jukića 23",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7730, 17.1942)
            ),
            CardInfo(
                category: "EV Charging",
                title: "EcoCharge",
                description: "Solar-powered EV charging station.",
                phone: "+387 51 666 666",
                url: "https://example.com/ecocharge",
                address: "Ranka Šipke 7",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7700, 17.1901)
            )
        ]
    case .museum:
        return [
            CardInfo(
                category: "Museum",
                title: "Museum of Contemporary Art",
                description: "Explore modern art exhibits and local artists.",
                phone: "+387 51 215 626",
                url: "https://example.com/museum-of-art",
                address: "Trg srpskih junaka 2",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7724, 17.1911)
            ),
            CardInfo(
                category: "Museum",
                title: "Ethnographic Museum",
                description: "Showcasing the cultural heritage of the region.",
                phone: "+387 51 234 567",
                url: "https://example.com/ethno-museum",
                address: "Vuka Karadžića 4",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7733, 17.1895)
            ),
            CardInfo(
                category: "Museum",
                title: "City History Museum",
                description: "Learn about the history of Banja Luka.",
                phone: "+387 51 765 432",
                url: "https://example.com/history-museum",
                address: "Cara Dušana 10",
                city: "Banja Luka",
                state: "Republika Srpska",
                zip: "78000",
                country: "Bosnia and Herzegovina",
                coordinates: (44.7711, 17.1920)
            )
        ]
    }
}
