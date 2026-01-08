//
//  ContentView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @EnvironmentObject var leaderboardData: LeaderboardData
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = false
    @State private var alertText = ""
    
    var body: some View {
        NavigationStack {
            GameSetup(localNetwork: localNetwork)
        }
        .onAppear {
            localNetwork.startBrowsing()
        }
        .onDisappear {
            localNetwork.stopBrowsing()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LeaderboardData())
}
