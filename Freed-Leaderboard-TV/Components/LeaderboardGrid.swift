//
//  LeaderboardGrid.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/8/26.
//

import Foundation
import SwiftUI

struct LeaderboardGrid: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    let players: [Player]
    
    private var numberOfColumns: Int {
        let maxPerColumn = 8
        let calculatedColumns = Int(ceil(Double(players.count) / Double(maxPerColumn)))
        return min(3, calculatedColumns)
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                LeaderboardPlayerPill(
                    place: index + 1,
                    name: player.name,
                    score: player.getScore(),
                    active: leaderboardData.getCurrentPlayer().id == player.id
                )
            }
        }
        .padding()
    }
}

#Preview {
    LeaderboardGrid(players: Player.samplePlayers)
        .environment(LeaderboardData(players: Player.samplePlayers))
}
