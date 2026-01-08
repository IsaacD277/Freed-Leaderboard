//
//  Player.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/4/26.
//

import Foundation

struct Player: Codable, Identifiable {
    var id: UUID
    var name: String
    var score: Int
    var history: [Int]
    
    init(_ name: String = "", score: Int = 0, history: [Int] = []) {
        self.id = UUID.init()
        self.name = name
        self.score = score
        self.history = history
    }

    static var example = Player(
        "John",
        score: 3000,
        history: [0, 800, 600, 0, 1500]
    )
}
