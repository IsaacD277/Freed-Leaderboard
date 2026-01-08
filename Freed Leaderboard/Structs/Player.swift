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
    var history: [Int]
    
    init(_ name: String, history: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.history = history
    }

    func addScore(score: Int) {
        history.append(score)
    }
    
    func removeLastScore() {
        _ = history.popLast()
    }
    
    func getScore() -> Int {
        history.reduce(0, +)
    }
    
    func getLast3Turns() -> [Int] {
        Array(history.suffix(3))
    }

    static var example = Player(
        "John",
        history: [0, 800, 600, 0, 1500]
    )
}
