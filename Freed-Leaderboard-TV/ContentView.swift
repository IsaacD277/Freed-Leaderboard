//
//  ContentView.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
    @State var player: Player = Player(id: UUID.init(), name: "Blank", score: 0, history: [])
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(player.name)
                    Text(player.score, format: .number)
                }
            }
            .navigationTitle("Freed Leaderboard")
        }
        .onChange(of: localNetwork.playerData) { _, newValue in
            let data = newValue
            let decoder = JSONDecoder()
            player = try! decoder.decode(Player.self, from: data!)
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
