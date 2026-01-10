//
//  Freed_LeaderboardApp.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI

@main
struct Freed_LeaderboardApp: App {
    @State private var leaderboardData: LeaderboardData
    @State private var localNetwork: LocalNetworkSessionCoordinator = LocalNetworkSessionCoordinator()
    
    init() {
        func decodeLeaderboardData() -> LeaderboardData {
            let rawData = UserDefaults.standard.data(forKey: "leaderboardData")
            guard let data = rawData else {
                return LeaderboardData()
            }
            
            do {
                let decodedData = try JSONDecoder().decode(LeaderboardData.self, from: data)
                return decodedData
            } catch {
                return LeaderboardData()
            }
        }
        leaderboardData = decodeLeaderboardData()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(leaderboardData)
        .environment(localNetwork)
    }
    

}
