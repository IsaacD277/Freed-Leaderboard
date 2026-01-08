import Foundation
import SwiftUI

@Observable class LeaderboardData: Codable {
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
    
    func nextPlayer() {
        guard !players.isEmpty else { return }
        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
            round += 1
        }
    }
    
    func backPlayer() {
        guard !players.isEmpty else { return }
        if currentPlayerIndex == 0 {
            if round > 1 {
                round -= 1
            }
            currentPlayerIndex = players.count - 1
        } else {
            currentPlayerIndex -= 1
        }
    }
    
    func getCurrentPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        return players[currentPlayerIndex]
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
        }
    }
}
