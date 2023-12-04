//
//  ContentView.swift
//  PartyExplorer
//
//  Created by Rahul Palani on 12/4/23.
//

import SwiftUI

// Create an Identifiable Party object w/ required data
struct Party: Identifiable {
    var id = UUID()
    var name: String
    var bannerImage: String
    var price: Double
    var startDate: Date
    var endDate: Date?
    var attendees: Int
}

// App data class
class AppData: ObservableObject {
    @Published var partyList: [Party]

    init() {
        // Initialize w/ at least 3 randomly generated parties
        partyList = Array(repeating: Party(name: "Sample Party", bannerImage: "sample.jpg", price: 10.0, startDate: Date(), endDate: nil, attendees: 50), count: 3)
        generateRandomParties()
    }

    // Generate a random party
    func generateRandomParty() -> Party {
        let partyNames = ["Party 1", "Party 2", "Party 3", "Party 4", "Party 5"]
        let bannerImages = ["party1.jpg", "party2.jpg", "party3.jpg", "party4.jpg", "party5.jpg"]
        let prices = [5.0, 0.0, 0.0, 10.0, 0.0]

        let randomName = partyNames.randomElement()!
        let randomBannerImage = bannerImages.randomElement()!
        let randomPrice = prices.randomElement()!
        let randomStartDate = Date()

        var endDate: Date? = nil
        if Int.random(in: 0..<2) == 1 {
            let randomEndDateOffset = Int.random(in: 1...30)
            endDate = randomStartDate.addingTimeInterval(TimeInterval(86400 * randomEndDateOffset))
        }

        return Party(
            name: randomName,
            bannerImage: randomBannerImage,
            price: randomPrice,
            startDate: randomStartDate,
            endDate: endDate,
            attendees: Int.random(in: 1...100)
        )
    }

    // Generate multiple random parties
    func generateRandomParties() {
        for _ in 0..<2 {
            partyList.append(generateRandomParty())
        }
    }
}

// SwiftUI main view
struct ContentView: View {
    @StateObject private var appData = AppData()
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search bar for filtering parties
                SearchBar(text: $searchQuery, placeholder: "Search for Parties...")

                // List of party cards
                List {
                    ForEach(appData.partyList.filter {
                        searchQuery.isEmpty || $0.name.localizedCaseInsensitiveContains(searchQuery)
                    }) { party in
                        PartyCard(party: party)
                    }
                }

                // Button to add a new random party
                Button("Add a Random Party") {
                    appData.partyList.append(appData.generateRandomParty())
                }
                .padding()
            }
            .navigationTitle("Party Explorer")
        }
    }
}

// Party card view
struct PartyCard: View {
    var party: Party

    var body: some View {
        NavigationLink(destination: PartyDetailsView(party: party)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(party.name)
                    .font(.headline)
                Text(String(format: "Price: $%.2f", party.price))
                Text("Starts on: \(party.startDate, style: .date)")
                Text("Ends at: \(party.endDate?.description ?? "TBD")")
                Text("Total Attendees: \(party.attendees)")
            }
            .padding()
            .background(Color.black.opacity(0.4))
            .cornerRadius(10)
            .padding(.vertical, 5)
        }
    }
}

// Search bar view
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color.black)
                .cornerRadius(8)

            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding()
    }
}

// Party details view
struct PartyDetailsView: View {
    var party: Party

    var body: some View {
        VStack {
            Text("Details for \(party.name)")
                .font(.title)
                .padding()

            // Display additional details as needed
            Text("Price: $\(party.price)")
            Text("Starts at: \(party.startDate, style: .date)")
            Text("Ends at: \(party.endDate?.description ?? "Ongoing")")
            Text("Total Attendees: \(party.attendees)")

            Spacer()
        }
        .navigationTitle("Party Details")
    }
}
//Allows for preview of App
#Preview {
    ContentView()
}
