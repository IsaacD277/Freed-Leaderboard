//
//  LeaderboardView.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/9/26.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    @State private var decodedData : LeaderboardData?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Column 1 - Leaderboard
                VStack(spacing: 0) {
                    Text("Freed Leaderboard - Round \(leaderboardData.round)")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.accent)
                        .padding(.vertical)
                        .background(Color.background)
                    
                    LeaderboardGrid(players: leaderboardData.getLeaderboard())
                }
                .frame(width: geometry.size.width * 2/3)
                .background(Color.background)
                
                
                // Divider
                Rectangle()
                    .fill(Color.accent)
                    .frame(width: 6)
                
                // Column 2
                SidebarView()
                    .padding(.vertical)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
        .onChange(of: localNetwork.leaderboardData) { _, newValue in
            let data = newValue
            do {
                decodedData = try JSONDecoder().decode(LeaderboardData.self, from: data)
                if let decodedData {
                    @Bindable var leaderboardData = leaderboardData
                    leaderboardData.players = decodedData.players
                    leaderboardData.roundScore = decodedData.roundScore
                    leaderboardData.round = decodedData.round
                    leaderboardData.currentPlayerIndex = decodedData.currentPlayerIndex
                }
            } catch {
                print("Error")
                print(error)
            }
        }
    }
}

#Preview {
    LeaderboardView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}

