import Foundation
import SwiftUI

@Observable class LeaderboardData: Codable, Equatable {
    var players: [Player]
    var roundScore: Int
    var currentPlayerIndex: Int
    var round: Int
    
    init(players: [Player] = []) {
        self.players = players
        self.roundScore = 0
        self.currentPlayerIndex = 0
        self.round = 1
    }
    
    func addPlayer(newPlayer: Player) {
        let highestRound = getHighestRoundNumber()
        var player = newPlayer
        
        // ensure new player has filled in zeros for all rounds missed
        while player.history.count < highestRound {
            player.addScore(score: 0, at: player.history.count)
        }
        players.append(player)
    }
    
    func removePlayer(id: UUID) {
        players.removeAll {$0.id == id }
    }
    
    func clearRoundScore() {
        roundScore = 0
    }
    
    func getPreviousScore() -> Int? {
        guard !players.isEmpty else { return nil }
        guard round > 0 else { return nil }
        let previousPlayer = getPreviousPlayer()
        let targetIndex: Int
        if currentPlayerIndex == 0 {
            // If we're at the first player, previous player's relevant round is (round - 2)
            targetIndex = round - 2
        } else {
            // Otherwise, previous player's relevant round is (round - 1)
            targetIndex = round - 1
        }
        guard let prev = previousPlayer, targetIndex >= 0 else { return nil }
        return prev.score(at: targetIndex)
        
    }
    
    func getPlayerPlace(id: UUID) -> Int? {
        let leaderboard = getLeaderboard()
        guard let index = leaderboard.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return index + 1
    }
    
    func getPlaceAhead (id: UUID) -> Player? {
        guard let playerPlace = getPlayerPlace(id: id) else { return nil }
        // Places are 1-based; the player ahead is at index (playerPlace - 2)
        let leaderboard = getLeaderboard()
        let aheadIndex = playerPlace - 2
        guard aheadIndex >= 0 && aheadIndex < leaderboard.count else { return nil }
        return leaderboard[aheadIndex]
    }
    
    func getPlaceBehind (id: UUID) -> Player? {
        guard let playerPlace = getPlayerPlace(id: id) else { return nil }
        // Places are 1-based; the player behind is at index (playerPlace)
        let leaderboard = getLeaderboard()
        let behindIndex = playerPlace
        guard behindIndex >= 0 && behindIndex < leaderboard.count else { return nil }
        return leaderboard[behindIndex]
    }
    
    func nextPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
            incrementRound()
        }
        return players[currentPlayerIndex]
    }
    
    
    // gets the previous players score for that round and returns the (player, value)
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
        
        let lastScore = players[currentPlayerIndex].score(at: round-1)
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
        guard !(currentPlayerIndex == 0 && round == 1) else { return nil }
        let prevIndex = currentPlayerIndex == 0 ? players.count - 1 : currentPlayerIndex - 1
        return players[prevIndex]
    }
    
    func getLeaderboard() -> [Player] {
        players.sorted { lhs, rhs in
            lhs.getScore() > rhs.getScore()
        }
    }
    
    func addPlayerScore(id: UUID, score: Int, round: Int? = nil) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            let targetRound = round ?? self.round
            players[index].addScore(score: score, at: targetRound - 1)
        }
    }
    
    func popPlayerLastScore(id: UUID) -> Int? {
        if let index = players.firstIndex(where: { $0.id == id }) {
            let lastScore = players[index].popLastScore()
            return lastScore 
        }
        return nil
    }
    
    func getPlayerRoundScore(id: UUID, round: Int? = nil) -> Int? {
        if let index = players.firstIndex(where: { $0.id == id }) {
            let targetRound = round ?? self.round
            let player = players[index]
            let targetIndex = targetRound - 1

            guard targetIndex >= 0, targetIndex < player.history.count else {
                return nil // or return 0 if you want a default
            }

            return player.score(at: targetIndex)
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
    
    func resetGame() {
        self.players = []
        self.roundScore = 0
        self.currentPlayerIndex = 0
        self.round = 1
    }
    
    private func incrementRound() {
        round += 1
        let targetIndex = round - 1
        
        // Ensure ALL players have entries up to and including the new round
        for i in players.indices {
            while players[i].history.count <= targetIndex {
                players[i].addScore(score: 0, at: players[i].history.count)
            }
        }
    }
    
    func getHighestRoundNumber() -> Int {
        guard !players.isEmpty else { return 0 }
        return players.map { $0.history.count }.max() ?? 0
    }
    
    static func == (lhs: LeaderboardData, rhs: LeaderboardData) -> Bool {
        return lhs.players == rhs.players && lhs.currentPlayerIndex == rhs.currentPlayerIndex && lhs.round == rhs.round && lhs.roundScore == rhs.roundScore
    }
}

