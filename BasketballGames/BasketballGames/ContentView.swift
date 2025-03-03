//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var date: String
    var opponent: String
    var id: Int
    var team: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [Result]()
    var body: some View {
        NavigationStack {
            List(games, id: \.id) { item in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(item.team) vs. \(item.opponent)")
                        Text(item.date)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(item.score.unc) - \(item.score.opponent)")
                        Text("\(item.isHomeGame ? "Home" : "Away")")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("UNC Basketball Games")
            .task {
                await getData()
            }
        }
    }
    
    func getData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
