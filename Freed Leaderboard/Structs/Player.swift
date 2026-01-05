//
//  Player.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/4/26.
//

import Foundation
import SwiftData

@Model public class leaderboardData {
    public var players: [Player]
    public var runningTotal: Int // Last players score
    public var currentPlayerId: UUID // to determine current player and previous 3 turns

    init(players: [Player], runningTotal: Int, currentPlayerId: UUID) {
        self.players = players
        self.runningTotal = runningTotal
        self.currentPlayerId = currentPlayerId
    }
}

public struct Player: Identifiable {
    public var id: UUID
    public var name: String
    public var score: Int
    public var history: [Int]
    
    init(id: UUID, name: String, score: Int, history: [Int]) {
        self.id = id
        self.name = name
        self.score = score
        self.history = history
    }
}
