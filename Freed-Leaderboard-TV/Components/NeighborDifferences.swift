//
//  NeighborDifferences.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/12/26.
//

import SwiftUI

struct NeighborDifferences: View {
    
    @Environment(LeaderboardData.self) private var leaderboardData
    
    var body: some View {
        VStack() {
            let player = leaderboardData.getCurrentPlayer()
            let currentPlace = leaderboardData.getPlayerPlace(id: player.id) ?? 0
            
            if let aheadPlayer = leaderboardData.getPlaceAhead(id: player.id) {
                let difference = abs(player.getScore() - aheadPlayer.getScore())
                HStack() {
                    Text("\(currentPlace - 1). \(aheadPlayer.name)")
                    Spacer()
                    Text("+\(difference)")
                        .foregroundColor(Color(red: 46/255, green: 125/255, blue: 50/255))
                        .padding()
                        .background(Color(red: 200/255, green: 230/255, blue: 201/255))
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pill)
                .foregroundColor(Color.background)
                .clipShape(Capsule())
            }
            if let behindPlayer = leaderboardData.getPlaceBehind(id: player.id) {
                let difference = abs(player.getScore() - behindPlayer.getScore())
                HStack() {
                    Text("\(currentPlace + 1). \(behindPlayer.name)")
                    Spacer()
                    Text("-\(difference)")
                        .foregroundColor(Color(red: 165/255, green: 42/255, blue: 42/255)) // Brown-red
                            .padding()
                            .background(Color(red: 255/255, green: 204/255, blue: 203/255)) // Light coral
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pill)
                .foregroundColor(Color.background)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    NeighborDifferences()
        .environment(LeaderboardData(players: Player.samplePlayers))
}
