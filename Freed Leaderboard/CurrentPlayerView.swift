//
//  CurrentPlayerView.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/8/26.
//

import SwiftUI

struct CurrentPlayerView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    
    @State var player: Player
    @State var customAdd: String = "0"
    @FocusState private var keyboardFocus: Bool
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("\(player.name) is up")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                Spacer()
                
                Text("Current Score: \(player.getScore())")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                HStack(spacing: 20) {
                    Text("\(leaderboardData.roundScore)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .bold()
                    
                    
                    
                    if let previousPlayerScore = leaderboardData.getPreviousScore(), previousPlayerScore > 0, leaderboardData.roundScore == 0 {
                        QuickAddButton(amount: previousPlayerScore, action: handleCurrentRoundScoreChange)
                            .frame(width:100)
                    }
                    
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    QuickAddButton(amount: 50, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 100, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 200, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 300, action: handleCurrentRoundScoreChange)
                }
                .padding(.horizontal)
                
                HStack( spacing:20) {
                    
                    QuickAddButton(amount: 400, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 500, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 600, action: handleCurrentRoundScoreChange)
                    QuickAddButton(amount: 750, action: handleCurrentRoundScoreChange)
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack() {
                    TextField("", text: $customAdd)
                        .onAppear { keyboardFocus = true }
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .background(Color.pill)
                        .foregroundStyle(Color.background)
                        .tint(Color.accent)
                        .onChange(of: customAdd) { oldValue, newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            
                            // Convert to Int and back to String to remove leading zeros
                            if let number = Int(filtered) {
                                customAdd = String(number)
                            } else {
                                customAdd = "0" // Fallback for empty or invalid input
                            }
                        }
                        .clipShape(Capsule())
                    
                    VStack(spacing:5) {
                        Button("+") {
                            handleCurrentRoundScoreChange(amount: Int(customAdd) ?? 0);
                            customAdd = ""
                        }
                        .font(.system(size: 35))
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .background(Color.green)
                        .foregroundStyle(Color.background)
                        .clipShape(Capsule())
                        
                        Button("-") {
                            handleCurrentRoundScoreChange(amount: -(Int(customAdd) ?? 0));
                            customAdd = ""
                        }
                        .font(.system(size: 35))
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                        .foregroundStyle(Color.background)
                        .clipShape(Capsule())
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(height: 100)
                .padding(.horizontal)
                
                Spacer()
                
                CustomNumberPad(
                    value: $customAdd,
                    roundValue: Binding(get: { leaderboardData.roundScore }, set: { leaderboardData.roundScore = $0 })
                )
                
                Spacer()
                
                HStack() {
                    
                    if (leaderboardData.round > 1 || leaderboardData.currentPlayerIndex > 0){
                        Button("Back") {
                            handleBackPlayer()
                        }
                        .padding()
                        .background(Color.pill)
                        .foregroundStyle(Color.background)
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button("Next") {
                        handleNextPlayer()
                    }
                    .padding()
                    .background(Color.pill)
                    .foregroundStyle(Color.background)
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.background)
            .foregroundStyle(Color.accent)
        }
    }
    
    func handleCurrentRoundScoreChange(amount: Int) {
        leaderboardData.roundScore += amount
        updateTVData()
    }
    
    func handleBackPlayer() {
        let (previousPlayer, lastScore) = leaderboardData.backPlayer()
        
        // Only update if we got valid data back
        if let previousPlayer = previousPlayer {
            player = previousPlayer
            leaderboardData.roundScore = lastScore ?? 0
        }
        
        updateTVData()
    }
    
    func handleNextPlayer() {
        leaderboardData.addPlayerScore(id: player.id, score: leaderboardData.roundScore)
        customAdd = ""
        leaderboardData.roundScore = 0
            
        // Only update if there's a next player
        if let nextPlayer = leaderboardData.nextPlayer() {
            player = nextPlayer
        }
        
        updateTVData()
    }
    
    func updateTVData() {
        try? localNetwork.broadcastData(leaderboardData)
        leaderboardData.saveLocally()
    }
}


#Preview {
    let leaderboardData = LeaderboardData(players: Player.samplePlayers)
    CurrentPlayerView(player: leaderboardData.players.first ?? Player.example)
        .environment(leaderboardData)
        .environment(LocalNetworkSessionCoordinator())
}

