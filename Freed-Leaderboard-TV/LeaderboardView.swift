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
                    Text("Freed Leaderboard")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.accent)
                        .padding(.vertical, 20)
                        .background(Color.background)
                    
                    ScrollView(showsIndicators: true) {
                        LeaderboardGrid(players: leaderboardData.getLeaderboard())
                            .frame(width: geometry.size.width * 2/3)
                    }
                    .background(Color.background)
                }
                .background(Color.background)
                
                // Divider
                Rectangle()
                    .fill(Color.accent)
                    .frame(width: 6)
                
                // Column 2 - Current Player
                VStack(spacing: 20) {
                    CurrentPlayerStats(player: leaderboardData.getCurrentPlayer())
                    
                    Spacer()
                    
                    Text("Running Total: \(leaderboardData.runningTotal)")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.pill)
                        .foregroundColor(Color.background)
                        .clipShape(Capsule())
                    
                    if let nextPlayer = leaderboardData.getNextPlayer() {
                        VStack(spacing: 10) {
                            Text("Next up:")
                                .font(.headline)
                                .foregroundColor(Color.accent)
                            
                            Text(nextPlayer.name)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color.pill)
                                .foregroundColor(Color.background)
                                .clipShape(Capsule())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(20)
                .background(Color.background)
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
                    leaderboardData.runningTotal = decodedData.runningTotal
                    leaderboardData.round = decodedData.round
                    leaderboardData.currentPlayerIndex = decodedData.currentPlayerIndex
                }
            } catch {
                print("Error")
                print(error)
            }
        }
        .onAppear {
            localNetwork.startAdvertising()
            localNetwork.startBrowsing()
        }
        .onDisappear {
            localNetwork.stopAdvertising()
            localNetwork.stopBrowsing()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers, runningTotal: 500))
        .environment(LocalNetworkSessionCoordinator())
}

