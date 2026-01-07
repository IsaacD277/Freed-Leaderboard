import Foundation

class LeaderboardData: ObservableObject, Codable {
    @Published var players: [Player] = [
        Player(
            id: UUID.init(),
            name: "Isaac",
            score: 500,
            history: [0, 500, 0]),
        Player(
            id: UUID.init(),
            name: "Noah",
            score: 1000,
            history: [0, 500, 500]),
        Player(
            id: UUID.init(),
            name: "Grace",
            score: 750,
            history: [0, 750]),
        Player(
            id: UUID.init(),
            name: "Audrey",
            score: 0,
            history: [0, 0]),
    ]
    var runningTotal: Int 
    var currentPlayerId: UUID

    enum CodingKeys: CodingKey {
        case players, runningTotal, currentPlayerId
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(players, forKey: .players)
        try container.encode(runningTotal, forKey: .runningTotal)
        try container.encode(currentPlayerId, forKey: .currentPlayerId)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        players = try container.decode(Player.self, forKey: .players)
        runningTotal = try container.decode(Int.self, forKey: .runningTotal)
        currentPlayerId = try container.decode(UUID.self, forKey: .currentPlayerId)
    }

    init() { }

    func delete(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }

    func add(_ player: Player) {
        players.append(player)
    }

    func exists(_ player: Player) -> Bool {
        players.contains(player)
    }
}