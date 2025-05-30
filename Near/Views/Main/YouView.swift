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
            VStack(spacing: 15) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.mapItem.name ?? "Unknown")
                            .font(.title2.bold())
                        // City, State, Country line below title
                        Text("\(item.mapItem.placemark.locality ?? ""), \(item.mapItem.placemark.administrativeArea ?? ""), \(item.mapItem.placemark.country ?? "")")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Button(action: {
                        selectedItem = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 5)
                
                // Action Buttons
                HStack(spacing: 10) {
                    Button(action: {
                        // TODO: Add directions action
                    }) {
                        Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                            .font(.callout.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.blue)
                            }
                    }
                    
                    Button(action: {
                        // TODO: Add share action
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up.fill")
                            .font(.callout.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.green)
                            }
                    }
                }
                
                // Additional Details
                ScrollView { // Wrap details in ScrollView if they might exceed sheet height
                    VStack(alignment: .leading, spacing: 10) { // Spacing between detail items
                        // Full Address
                        if let address = item.mapItem.placemark.title {
                            Label {
                                Text(address)
                                    .font(.callout)
                            } icon: {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background)
                                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                            }
                        }
                        
                        // Phone Number
                        if let phone = item.mapItem.phoneNumber {
                            Label {
                                Text(phone)
                                    .font(.callout)
                            } icon: {
                                Image(systemName: "phone.fill")
                                    .foregroundStyle(.green)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background)
                                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                            }
                        }
                        
                        // Website URL
                        if let url = item.mapItem.url?.absoluteString {
                            Label {
                                Text(url)
                                    .font(.callout)
                            } icon: {
                                Image(systemName: "globe")
                                    .foregroundStyle(.orange)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background)
                                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                            }
                        }
                        
                        // ZIP Code
                        if let zip = item.mapItem.placemark.postalCode {
                            Label {
                                Text(zip)
                                    .font(.callout)
                            } icon: {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(.purple)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background)
                                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                            }
                        }
                        
                        // Coordinates
                        Label {
                            Text(String(format: "%.6f, %.6f", item.mapItem.placemark.coordinate.latitude, item.mapItem.placemark.coordinate.longitude))
                                .font(.callout)
                        } icon: {
                            Image(systemName: "map.fill") // Using map.fill for coords
                                .foregroundStyle(.red)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.background)
                                .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                        }
                    }
                }
                
                Spacer() // Push content to top
                
            }
            .padding()
            .background(.ultraThinMaterial)
            .presentationDetents([.fraction(0.4), .medium])
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(20)
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
                    if let cat = item.pointOfInterestCategory {
                        let fullName = cat.rawValue
                        if fullName.hasPrefix("MKPOICategory"),
                           let range = fullName.range(of: "MKPOICategory") {
                            let cleanName = fullName[range.upperBound...].capitalized
                            print("Category: \(cleanName)")
                        } else {
                            print("Category: \(fullName.capitalized)")
                        }
                    } else {
                        print("Category: N/A")
                    }
                    
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
