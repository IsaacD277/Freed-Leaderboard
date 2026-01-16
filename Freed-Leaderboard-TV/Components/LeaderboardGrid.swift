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
    
    struct SelectedPlayer: Identifiable, Equatable {
        let id: Player.ID
    }

    @State private var selectedPlayer: SelectedPlayer?
    
    private var numberOfColumns: Int {
        let maxPerColumn = 8
        let calculatedColumns = Int(ceil(Double(players.count) / Double(maxPerColumn)))
        return min(3, calculatedColumns)
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                    LeaderboardPlayerPill(
                        place: index + 1,
                        name: player.name,
                        score: player.getScore(),
                        active: leaderboardData.getCurrentPlayer().id == player.id,
                        onSelect: { selectedPlayer = SelectedPlayer(id: player.id) }
                    )
                }
            }
            .padding(.horizontal, 25)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(item: $selectedPlayer) { selection in
            if let player = players.first(where: { $0.id == selection.id }) {
                PlayerHistoryView(player: player) {
                    selectedPlayer = nil
                }
            }
        }
    }
}

#Preview("Grid - Closed") {
    LeaderboardGrid(players: Player.samplePlayers)
        .environment(LeaderboardData(players: Player.samplePlayers))
}

#Preview("Grid - Full Screen Open") {
    @Previewable @State var selectedPlayer: LeaderboardGrid.SelectedPlayer? = LeaderboardGrid.SelectedPlayer(id: Player.samplePlayers.first!.id)
    
    LeaderboardGrid(players: Player.samplePlayers)
        .environment(LeaderboardData(players: Player.samplePlayers))
        .fullScreenCover(item: $selectedPlayer) { selection in
            if let player = Player.samplePlayers.first(where: { $0.id == selection.id }) {
                PlayerHistoryView(player: player) {
                    selectedPlayer = nil
                }
            }
        }
}
