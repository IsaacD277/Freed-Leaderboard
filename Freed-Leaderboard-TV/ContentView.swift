//
//  ContentView.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
    @State private var decodedData : LeaderboardData?

    var body: some View {
        NavigationStack {
            List {
                ForEach(leaderboardData.players) { player in
                    HStack {
                        Text(player.name)
                        Text(player.score, format: .number)
                    }
                }
                Button("Click me") {
                    print(leaderboardData.players)
                }
            }
            .navigationTitle("Freed Leaderboard")
        }
        .onChange(of: localNetwork.leaderboardData) { _, newValue in
            print("RECEIVED")
            let data = newValue
//            print("DATA BELOW")
            print(String(data: data, encoding: .utf8)!)
//            print("DATA ABOVE")
//            let decoder = JSONDecoder()
            do {
                print("Decoding...")
                decodedData = try JSONDecoder().decode(LeaderboardData.self, from: data)
                print("Decoding Successful:")
                if let decodedData {
                    print("Inside")
                    @Bindable var leaderboardData = leaderboardData
                    leaderboardData.players = decodedData.players
                }
            } catch {
                print("Error")
                print(error)
            }
//            leaderboardData = try! decoder.decode(LeaderboardData.self, from: data!)
//            print(decodedData)
        }
        .onAppear {
            localNetwork.startAdvertising()
            localNetwork.startBrowsing()
        }
        .onDisappear {
            localNetwork.stopAdvertising()
            localNetwork.stopBrowsing()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
}
