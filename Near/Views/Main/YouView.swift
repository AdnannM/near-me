//
//  YouView.swift
//  Near
//
//  Created by Adnann Muratovic on 14.05.25.
//

import SwiftUI
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

struct YouView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.772181, longitude: 17.191),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var restaurants: [IdentifiableMapItem] = []
    @State private var selectedItem: IdentifiableMapItem? = nil

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(restaurants) { item in
                Annotation(item.mapItem.name ?? "Place", coordinate: item.mapItem.placemark.coordinate) {
                    Button(action: {
                        selectedItem = item
                    }) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
        .onAppear {
            searchNearbyRestaurants()
        }
        .sheet(item: $selectedItem) { item in
            VStack(spacing: 16) {
                Text(item.mapItem.name ?? "Unknown")
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 4) {
                    Text("📍 Address: \(item.mapItem.placemark.title ?? "N/A")")
                    Text("📞 Phone: \(item.mapItem.phoneNumber ?? "N/A")")
                    Text("🌍 Website: \(item.mapItem.url?.absoluteString ?? "N/A")")
                    Text("🗺️ City: \(item.mapItem.placemark.locality ?? "N/A")")
                    Text("🏙️ State: \(item.mapItem.placemark.administrativeArea ?? "N/A")")
                    Text("📮 ZIP: \(item.mapItem.placemark.postalCode ?? "N/A")")
                    Text("🇨🇴 Country: \(item.mapItem.placemark.country ?? "N/A")")
                    Text("🧭 Coords: \(item.mapItem.placemark.coordinate.latitude), \(item.mapItem.placemark.coordinate.longitude)")
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.4), .medium])
        }
    }

    private func searchNearbyRestaurants() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.772181, longitude: 17.191),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurants"
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }

            if let mapItems = response?.mapItems {
                for item in mapItems {
                    print("Name: \(item.name ?? "Unknown")")
                    print("Phone: \(item.phoneNumber ?? "N/A")")
                    print("URL: \(item.url?.absoluteString ?? "No URL")")
                    print("Address: \(item.placemark.title ?? "No address")")
                    print("City: \(item.placemark.locality ?? "N/A")")
                    print("State: \(item.placemark.administrativeArea ?? "N/A")")
                    print("ZIP: \(item.placemark.postalCode ?? "N/A")")
                    print("Country: \(item.placemark.country ?? "N/A")")
                    print("Coordinates: \(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)")
                    print("---------")
                }

                restaurants = mapItems.map { IdentifiableMapItem(mapItem: $0) }
            }
        }
    }
}

#Preview {
    YouView()
}
