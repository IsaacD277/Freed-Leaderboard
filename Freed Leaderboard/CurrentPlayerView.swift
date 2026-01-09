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
    @State var currentRoundScore: Int = 0
    @State var customAdd: String = "0"
    @FocusState private var keyboardFocus: Bool
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("\(player.name) is up")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                Spacer()
                
                Text("Current Score: \(player.getScore())")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Text("\(currentRoundScore)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .bold()
                
                Spacer()
                
                HStack(spacing: 20) {
                    QuickAddButton(amount: 50, action: handleScoreChange)
                    QuickAddButton(amount: 100, action: handleScoreChange)
                    QuickAddButton(amount: 200, action: handleScoreChange)
                    QuickAddButton(amount: 300, action: handleScoreChange)
                }
                .padding(.horizontal, 20)
                
                HStack( spacing:20) {
                    
                    QuickAddButton(amount: 400, action: handleScoreChange)
                    QuickAddButton(amount: 500, action: handleScoreChange)
                    QuickAddButton(amount: 600, action: handleScoreChange)
                    QuickAddButton(amount: 750, action: handleScoreChange)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                HStack() {
                    TextField("", text: $customAdd)
                        .onAppear { keyboardFocus = true }
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 20)
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
                            handleScoreChange(amount: Int(customAdd) ?? 0);
                            customAdd = ""
                        }
                        .font(.system(size: 35))
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .background(Color.green)
                        .foregroundStyle(Color.background)
                        .clipShape(Capsule())
                        
                        Button("-") {
                            handleScoreChange(amount: -(Int(customAdd) ?? 0));
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
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomNumberPad(value: $customAdd, roundValue: $currentRoundScore)
                
                Spacer()
                
                HStack() {
                    Button("Back") {
                        switchPlayers(forward: false)
                    }
                    .padding(20)
                    .background(Color.pill)
                    .foregroundStyle(Color.background)
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button("Next") {
                        switchPlayers()
                    }
                    .padding(20)
                    .background(Color.pill)
                    .foregroundStyle(Color.background)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.background)
            .foregroundStyle(Color.accent)
        }
    }
    
    func handleScoreChange(amount: Int) {
        currentRoundScore += amount
    }
    
    func switchPlayers(forward: Bool = true) {
        handleScoreChange(amount: Int(customAdd) ?? 0);
        customAdd = ""
        leaderboardData.addPlayerScore(id: player.id, score: currentRoundScore)
        currentRoundScore = 0
        player = forward ? leaderboardData.getNextPlayer() ?? Player("") : leaderboardData.getPreviousPlayer() ?? Player("")
        forward ? leaderboardData.nextPlayer() : leaderboardData.backPlayer()
        try? localNetwork.broadcastData(leaderboardData)
        leaderboardData.saveLocally()
    }
}


#Preview {
    let leaderboardData = LeaderboardData(players: Player.samplePlayers)
    CurrentPlayerView(player: leaderboardData.players.first ?? Player.example)
        .environment(leaderboardData)
}
