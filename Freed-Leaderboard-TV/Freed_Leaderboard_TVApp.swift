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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(leaderboardData)
    }
}
