//
//  Player.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/4/26.
//

import Foundation

//@Model public class leaderboardData: Codable, ObservableObject {
//    public enum CodingKeys: CodingKey {
//        case _players
//        case _runningTotal
//        case _currentPlayerId
//        case _$backingData
//        case _$observationRegistrar
//    }
//    
//    public var players: [Player]
//    public var runningTotal: Int // Last players score
//    public var currentPlayerId: UUID // to determine current player and previous 3 turns
//}

//public struct Player: Identifiable {
//    public var id: UUID
//    public var name: String
//    public var score: Int
//    public var history: [Int]
//    
//    init(id: UUID, name: String, score: Int, history: [Int]) {
//        self.id = id
//        self.name = name
//        self.score = score
//        self.history = history
//    }
//}

struct Player: Codable, Identifiable {
    var id: UUID
    var name: String
    var score: Int
    var history: [Int]
}

class leaderboardData: Codable {
    var players: [Player]
    var runningTotal: Int 
    var currentPlayerId: UUID
}
