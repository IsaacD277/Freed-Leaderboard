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
    
    private var player: Player {
        leaderboardData.getCurrentPlayer()
    }
    @State var customAdd: String = "0"
    @State var task: Task<Void, Never>? = nil  // reference to the task
    @State var isRunning: Bool = false
    @FocusState private var keyboardFocus: Bool
    @State private var roundPickerOpen: Bool = false
    
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
                            self.task?.cancel()
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
                            self.task?.cancel()
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
                .onAutoAdd {
                    self.task?.cancel()
                    
                    self.task = Task {
                        do {
                            try await Task.sleep(nanoseconds: 1_500_000_000)
                            handleCurrentRoundScoreChange(amount: Int(customAdd) ?? 0);
                            customAdd = ""
                        } catch is CancellationError {
                            print("Task was cancelled")
                        } catch {
                            print("ooops! \(error)")
                        }
                    }
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    
                    // Left side
                    HStack {
                        if (leaderboardData.round > 1 || leaderboardData.currentPlayerIndex > 0){
                            Button("Back") {
                                handleBackPlayer()
                            }
                            .padding()
                            .background(Color.pill)
                            .foregroundStyle(Color.background)
                            .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Middle
                    Button {
                        roundPickerOpen.toggle()
                    } label: {
                        Text("Round \(leaderboardData.round)")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Right side
                    HStack {
                        Button("Next") {
                            handleNextPlayer()
                        }
                        .padding()
                        .background(Color.pill)
                        .foregroundStyle(Color.background)
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.background)
            .foregroundStyle(Color.accent)
            .sheet(isPresented: $roundPickerOpen) {
                VStack {
                    Text("Select Round")
                        .font(.headline)
                        .padding()
                    
                    Picker("Round", selection: Binding(get: { leaderboardData.round }, set: { leaderboardData.round = $0 })) {
                        ForEach(1...max(1, leaderboardData.getHighestRoundNumber()), id: \.self) { i in
                            Text("Round \(i)").tag(i)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
                .presentationDetents([.fraction(0.3)])
            }
        }
        .onAppear {
            loadRoundScore()
        }
        .onChange(of: leaderboardData.currentPlayerIndex) { _, _ in
            loadRoundScore()
            updateTVData()
        }
        .onChange(of: leaderboardData.round) { _, _ in
            loadRoundScore()
            updateTVData()
        }
    }
    
    private func loadRoundScore() {
        leaderboardData.roundScore = leaderboardData.getPlayerRoundScore(id: player.id) ?? 0
        customAdd = ""
        updateTVData()
    }
    
    private func handleCurrentRoundScoreChange(amount: Int) {
        leaderboardData.roundScore += amount
        updateTVData()
    }
    
    private func handleBackPlayer() {
        _ = leaderboardData.backPlayer()
    }
    
    private func handleNextPlayer() {
        leaderboardData.addPlayerScore(id: player.id, score: leaderboardData.roundScore)
        _ = leaderboardData.nextPlayer()

        
    }
    
    private func updateTVData() {
        try? localNetwork.broadcastData(leaderboardData)
        leaderboardData.saveLocally()
    }
}


#Preview {
    let leaderboardData = LeaderboardData(players: Player.samplePlayers)
    CurrentPlayerView()
        .environment(leaderboardData)
        .environment(LocalNetworkSessionCoordinator())
}

