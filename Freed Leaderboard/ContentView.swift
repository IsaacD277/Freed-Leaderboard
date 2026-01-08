//
//  ContentView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @State private var message: String = ""
    @State private var localNetwork: LocalNetworkSessionCoordinator = LocalNetworkSessionCoordinator()
    @State private var showAlert = false
    @State private var alertText = ""
    
    var body: some View {
        NavigationStack {
            GameSetup(localNetwork: $localNetwork)
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
}
