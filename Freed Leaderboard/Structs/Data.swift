import Foundation
import SwiftUI

@Observable class LeaderboardData: Codable, Equatable {
    var players: [Player]
    var runningTotal: Int
    var currentPlayerIndex: Int
    var round: Int
    
    init(players: [Player] = [], runningTotal: Int = 0) {
        self.players = players
        self.runningTotal = runningTotal
        self.currentPlayerIndex = 0
        self.round = 1
    }
    
    func addPlayer(newPlayer: Player) {
        players.append(newPlayer)
    }
    func removePlayer(id: UUID) {
        players.removeAll {$0.id == id }
    }
    
    func clearRunningTotal() {
        runningTotal = 0
    }
    
    func nextPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
            round += 1
        }
        return players[currentPlayerIndex]
    }
    
    
    // pops the previous players last score and returns the (player, value)
    func backPlayer() -> (Player?, Int?) {
        guard !players.isEmpty else { return (nil, nil) }
        if currentPlayerIndex == 0 {
            if round > 1 {
                round -= 1
                currentPlayerIndex = players.count - 1
            }
        } else {
            currentPlayerIndex -= 1
        }
        
        let lastScore = players[currentPlayerIndex].popLastScore()
        let previousPlayer = players[currentPlayerIndex]
        
        return (previousPlayer, lastScore)
    }
    
    func getCurrentPlayer() -> Player {
        let player: Player
        if currentPlayerIndex >= 0 && currentPlayerIndex < players.count {
            player = players[currentPlayerIndex]
        } else {
            player = Player("")
            currentPlayerIndex = 0
        }
        return player
    }
    
    func getNextPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        let nextIndex = (currentPlayerIndex + 1) % players.count
        return players[nextIndex]
    }
    
    func getPreviousPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        let prevIndex = currentPlayerIndex == 0 ? players.count - 1 : currentPlayerIndex - 1
        return players[prevIndex]
    }
    
    func getLeaderboard() -> [Player] {
        players.sorted { lhs, rhs in
            lhs.getScore() > rhs.getScore()
        }
    }
    
    func addPlayerScore(id: UUID, score: Int) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            players[index].addScore(score: score)
            runningTotal = score
        }
    }
    
    func popPlayerLastScore(id: UUID) -> Int? {
        if let index = players.firstIndex(where: { $0.id == id }) {
            let lastScore = players[index].popLastScore()
            return lastScore 
        }
        return nil
    }
    
    func getPlayerByIndex(_ index: Int) -> Player? {
        guard !players.isEmpty else { return nil }
        return players[index]
    }
    
    func saveLocally() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: "leaderboardData")
        }
    }
    
    static func == (lhs: LeaderboardData, rhs: LeaderboardData) -> Bool {
        return lhs.players == rhs.players && lhs.currentPlayerIndex == rhs.currentPlayerIndex && lhs.round == rhs.round && lhs.runningTotal == rhs.runningTotal
    }
}
