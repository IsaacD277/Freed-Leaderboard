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

    func delete(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }

    func add(_ player: Player) {
        players.append(player)
    }

    func exists(_ player: Player) {
        players.contains(player)
    }
}