//
//  ContentView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GameSetup()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
        .environment(LocalNetworkSessionCoordinator())
}
