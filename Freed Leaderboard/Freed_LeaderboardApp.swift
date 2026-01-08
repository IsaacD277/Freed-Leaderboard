//
//  Freed_LeaderboardApp.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI

@main
struct Freed_LeaderboardApp: App {
    @State private var leaderboardData = LeaderboardData()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(leaderboardData)
    }
}
