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

    static var example = Player(
        id: UUID.init(),
        name: "John",
        score: 3000,
        history: [0, 800, 600, 0, 1500]
    )
}
