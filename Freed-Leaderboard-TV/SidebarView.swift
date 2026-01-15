//
//  SidebarView.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/12/26.
//

import SwiftUI

struct SidebarView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    
    var body: some View {
        
        VStack(spacing: 20) {
            if (leaderboardData.players.isEmpty) {
                Text("No Users")
                    .font(.system(size: 60))
                    .bold()
                    .foregroundColor(Color.accent)
                    .padding(.bottom)
            } else {
                CurrentPlayerStats(player: leaderboardData.getCurrentPlayer(),
                                   round: leaderboardData.round)
                
                NeighborDifferences()
                
                Spacer()
                
                VStack(spacing: 16) {
                    if let previousScore = leaderboardData.getPreviousScore() {
                        Text("Previous Score: \(previousScore)")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundColor(Color.accent)
                    }
                    
                    Text("Round Score: \(leaderboardData.roundScore)")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundColor(Color.accent)
                        .padding(.bottom)
                }
                
                if let nextPlayer = leaderboardData.getNextPlayer() {
                    Text("Next up: \(nextPlayer.name)")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.background)
                        .padding(.vertical)
                        .background(Color.pill)
                        .foregroundColor(Color.background)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color.background)
    }
}


#Preview {
    SidebarView()
        .environment(LeaderboardData(players: Player.samplePlayers))
}

#Preview {
    SidebarView()
        .environment(LeaderboardData(players: []))
}
