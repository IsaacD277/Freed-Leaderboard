//
//  Player.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/4/26.
//

import Foundation

struct Player: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    private(set) var history: [Int]
    
    init(_ name: String, history: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.history = history
    }

    mutating func addScore(score: Int, at index: Int? = nil) {
        if let index = index {
            guard index >= 0 && index <= history.count else {
                print("Warning: Index out of bounds")
                return
            }
            if index == history.count {
                // If index equals count, we're appending to the end
                history.append(score)
            } else {
                // Otherwise, we're replacing an existing element
                history[index] = score
            }
        } else {
            history.append(score)
        }
    }
    
    mutating func popLastScore() -> Int? {
        let lastScore = history.popLast()
        return lastScore
    }
    
    func score(at index: Int) -> Int? {
        guard index >= 0 && index < history.count else {
            return nil
        }
        return history[index]
    }
    
    mutating func resetScore() {
        history = []
    }
    
    func getScore() -> Int {
        history.reduce(0, +)
    }
    
    func getLast3Turns() -> [Int] {
        Array(history.suffix(3))
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.history == rhs.history
    }

    static var example = Player(
        "John",
        history: [0, 800, 600, 0, 1500]
    )
    
    static var samplePlayers: [Player] = [
        Player("Emma", history: [180, 165, 190, 21012, 522, 2302]),
        Player("Liam", history: [145, 198, 167, 203, 188, 188]),
        Player("Olivia", history: [175, 155, 185, 195, 160, 175]),
        Player("Sophia", history: [142, 178, 156, 189, 171, 162]),
        Player("Jackson", history: [168, 145, 172, 183, 149, 150]),
        Player("Ava", history: [155, 138, 165, 178, 143, 144]),
        Player("Lucas", history: [149, 132, 158, 171, 136, 145]),
        Player("Mia", history: [143, 127, 151, 164, 129, 142]),
        Player("Ethan", history: [138, 122, 146, 159, 124, 145]),
    ]
}
