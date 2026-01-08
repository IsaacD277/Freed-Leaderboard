import Foundation
import SwiftUI

@Observable class LeaderboardData: Codable {
    var players: [Player]
    var runningTotal: Int
    var currentPlayerId: UUID?

//    enum CodingKeys: String, CodingKey {
//        case players, runningTotal, currentPlayerId
//    }
//
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(players, forKey: .players)
//        try container.encode(runningTotal, forKey: .runningTotal)
//        try container.encode(currentPlayerId, forKey: .currentPlayerId)
//    }
//
//    required init(from decoder: Decoder) throws {
//        print("Decoding from LeaderboardData")
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.runningTotal = try container.decode(Int.self, forKey: .runningTotal)
//        self.currentPlayerId = try container.decode(UUID.self, forKey: .currentPlayerId)
//        self.players = try container.decode([Player].self, forKey: .players)
//    }

    init() {
        players = []
        runningTotal = 0
        currentPlayerId = nil
    }

    func delete(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }

    func add(_ player: Player) {
        players.append(player)
    }

//    func exists(_ player: Player) -> Bool {
//        players.contains(where: player)
//    }
}
