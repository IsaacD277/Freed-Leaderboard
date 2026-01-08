//
//  ContentView.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @State private var leaderboardData = LeaderboardData()
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(leaderboardData.players) { player in
                    HStack {
                        Text(player.name)
                        Text(player.score, format: .number)
                    }
                }
            }
            .navigationTitle("Freed Leaderboard")
        }
        .onChange(of: localNetwork.leaderboardData) { _, newValue in
            print("RECEIVED")
            let data = newValue
            let decoder = JSONDecoder()
            print(leaderboardData)
            do {
                leaderboardData = try decoder.decode(LeaderboardData.self, from: data!)
            } catch {
                print(error.localizedDescription)
            }
//            leaderboardData = try! decoder.decode(LeaderboardData.self, from: data!)
            print(leaderboardData)
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
}
