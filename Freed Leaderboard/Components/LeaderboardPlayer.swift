//
//  LeaderboardPlayer.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/11/26.
//

import SwiftUI

struct LeaderboardPlayer: View {
    let player: Player
    let place: Int
    @State private var showDetails: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("#\(place) \(player.name)")
                Spacer()
                Text("\(player.getScore())")
                Button {
                    showDetails.toggle()
                } label: {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                }
                
            }

            if (showDetails) {
                PlayerHistory(history: player.history)
            }
        }
    }
}

#Preview {
    LeaderboardPlayer(player: .example, place: 1)
}
