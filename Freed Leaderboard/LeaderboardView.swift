//
//  LeaderboardView.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/10/26.
//

import SwiftUI




struct LeaderboardView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    
    var body: some View {
        List {
            ForEach(Array(leaderboardData.getLeaderboard().enumerated()), id: \.element.id) { index, player in
                LeaderboardPlayer(player: player, place: index + 1)
            }
        }
    }
}

#Preview {
    LeaderboardView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}

