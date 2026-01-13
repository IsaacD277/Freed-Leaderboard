//
//  Freed_Leaderboard_TVApp.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI

@main
struct Freed_Leaderboard_TVApp: App {
    @State private var leaderboardData = LeaderboardData()
    @State private var localNetwork = LocalNetworkSessionCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        .environment(leaderboardData)
        .environment(localNetwork)
    }
}
