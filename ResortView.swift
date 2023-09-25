//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Areej Hussein on 01/02/2023.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    @EnvironmentObject var favorites: Favorites

    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
struct ImageCredit: View {
    let resort: Resort
        var body: some View {
            ZStack {
                Text("Credit:\(resort.imageCredit)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(3)
            }
            .background(.black)
            .opacity(0.4)
            .cornerRadius(6)
            .padding(4)
        }
    }
    
    var body: some View {
        ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(decorative: resort.id)
                            .resizable()
                            .scaledToFit()
                            .overlay(ImageCredit(resort: resort), alignment: .bottomTrailing)
                            Spacer()
                        
                        HStack {
                            if sizeClass == .compact && typeSize > .large {
                                VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                                VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                            } else {
                                ResortDetailsView(resort: resort)
                                SkiDetailsView(resort: resort)
                            }
                        }
                        .padding(.vertical)
                        .background(Color.primary.opacity(0.1))

                        Group {
                            Text(resort.description)
                                .padding(.vertical)

                            Text("Facilities")
                                .font(.headline)

                            HStack {
                                ForEach(resort.facilitTypes) { facility in
                                    Button {
                                        selectedFacility = facility
                                        showingFacility = true
                                    } label: {
                                        facility.icon
                                            .font(.title)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                    }
            
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                if favorites.contains(resort) {
                    favorites.remove(resort)
                } else {
                    favorites.add(resort)
                }
            }
                .buttonStyle(.borderedProminent)
                .padding()
            
                }
                .navigationTitle("\(resort.name), \(resort.country)")
                .navigationBarTitleDisplayMode(.inline)
                .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
                } message: { facility in
                    Text(facility.description)
                }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
            .environmentObject(Favorites())
    }
}
