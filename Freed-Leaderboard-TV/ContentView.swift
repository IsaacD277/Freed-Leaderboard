import SwiftUI

let samplePlayers: [Player] = [
    Player(name: "Emma", history: [180, 165, 190, 21012, 522, 2302]),
    Player(name: "Liam", history: [145, 198, 167, 203, 188, 188]),
    Player(name: "Olivia", history: [175, 155, 185, 195, 160, 175]),
    Player(name: "Sophia", history: [142, 178, 156, 189, 171, 162]),
    Player(name: "Jackson", history: [168, 145, 172, 183, 149, 150]),
    Player(name: "Ava", history: [155, 138, 165, 178, 143, 144]),
    Player(name: "Lucas", history: [149, 132, 158, 171, 136, 145]),
    Player(name: "Mia", history: [143, 127, 151, 164, 129, 142]),
    Player(name: "Ethan", history: [138, 122, 146, 159, 124, 145]),
]

// Color Palette
let backgroundColor = Color(red: 0.35, green: 0.25, blue: 0.55)   // Royal Purple (background)
let accentColors = Color(red: 1.0, green: 0.8, blue: 0.2)          // Bright Yellow (accents)
let pillBackground = Color(red: 0.95, green: 0.92, blue: 1.0)     // Light Lavender (pill background)
let dividerColor = Color(red: 1.0, green: 0.8, blue: 0.2)         // Bright Yellow (divider)
let textColor = Color(red: 0.2, green: 0.15, blue: 0.4)           // Dark Purple (text on pills)

class Player: Codable, Identifiable {
    var id: UUID
    var name: String
    private var history: [Int]
    
    init(name: String, history: [Int] = []) {
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
}

class LeaderboardData: Codable {
    private(set) var players: [Player]
    private(set) var runningTotal: Int
    private var currentPlayerIndex: Int
    private var round: Int

    init(players: [Player] = [], runningTotal: Int = 0) {
        self.players = players
        self.runningTotal = runningTotal
        self.currentPlayerIndex = 0
        self.round = 1
    }
    
    func addPlayer(newPlayer: Player) {
        players.append(newPlayer)
    }
    func removePlayer(id: UUID) {
        players.removeAll {$0.id == id }
    }
    
    func clearRunningTotal() {
        runningTotal = 0
    }
    
    func nextPlayer() {
        guard !players.isEmpty else { return }
        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
            round += 1
        }
    }
    
    func backPlayer() {
        guard !players.isEmpty else { return }
        if currentPlayerIndex == 0 {
            if round > 1 {
                round -= 1
            }
            currentPlayerIndex = players.count - 1
        } else {
            currentPlayerIndex -= 1
        }
    }
    
    func getCurrentPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        return players[currentPlayerIndex]
    }
    
    func getNextPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        let nextIndex = (currentPlayerIndex + 1) % players.count
        return players[nextIndex]
    }
    
    func getPreviousPlayer() -> Player? {
        guard !players.isEmpty else { return nil }
        let prevIndex = currentPlayerIndex == 0 ? players.count - 1 : currentPlayerIndex - 1
        return players[prevIndex]
    }
    
    func getLeaderboard() -> [Player] {
        players.sorted { lhs, rhs in
            lhs.getScore() > rhs.getScore()
        }
    }
    
    func addPlayerScore(id: UUID, score: Int) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            players[index].addScore(score: score)
        }
    }
}

struct LeaderboardPlayerPill: View {
    let place: Int
    let name: String
    let score: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("#\(place)")
                .font(.headline)
                .lineLimit(1)
                .bold()
                .layoutPriority(2)
            
            Text(name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(0)
            
            Text("\(score)")
                .font(.headline)
                .lineLimit(1)
                .bold()
                .monospacedDigit()
                .layoutPriority(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(.horizontal, 20)
        .background(pillBackground)
        .foregroundColor(textColor)
        .clipShape(Capsule())
    }
}

struct LeaderboardGrid: View {
    let players: [Player]
    
    private var numberOfColumns: Int {
        let maxPerColumn = 8
        let calculatedColumns = Int(ceil(Double(players.count) / Double(maxPerColumn)))
        return min(3, calculatedColumns)
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
                  
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                LeaderboardPlayerPill(
                    place: index + 1,
                    name: player.name,
                    score: player.getScore()
                )
            }
        }
        .padding(20)
    }
}

struct CurrentPlayerStats: View {
    let player: Player?

    var body: some View {
        Group {
            if let player {
                VStack(spacing: 15) {
                    Text("\(player.name) is up!")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(pillBackground)
                        .foregroundColor(textColor)
                        .clipShape(Capsule())
                    
                    Text("Score: \(player.getScore())")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(pillBackground)
                        .foregroundColor(textColor)
                        .clipShape(Capsule())

                    Text("Previous 3 Turns:")
                        .font(.headline)
                        .foregroundColor(accentColors)
                        .padding(.top, 10)
                    
                    HStack(spacing: 15) {
                        ForEach(Array(player.getLast3Turns()), id: \.self) { l in
                            Text("\(l)")
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(pillBackground)
                                .foregroundColor(textColor)
                                .clipShape(Capsule())
                        }
                    }
                }
            } else {
                Text("No User")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(pillBackground)
                    .foregroundColor(textColor)
                    .clipShape(Capsule())
            }
        }
    }
}

struct ContentView: View {
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
    @State private var leaderboard = LeaderboardData(players: samplePlayers)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Column 1 - Leaderboard
                VStack(spacing: 0) {
                    Text("Freed Leaderboard")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(accentColors)
                        .padding(.vertical, 20)
                        .background(backgroundColor)
                    
                    ScrollView(showsIndicators: true) {
                        LeaderboardGrid(players: leaderboard.getLeaderboard())
                            .frame(width: geometry.size.width * 2/3)
                    }
                    .background(backgroundColor)
                }
                .background(backgroundColor)
                
                // Divider
                Rectangle()
                    .fill(dividerColor)
                    .frame(width: 6)
                
                // Column 2 - Current Player
                VStack(spacing: 20) {
                    CurrentPlayerStats(player: leaderboard.getCurrentPlayer())
                    
                    Spacer()
                    
                    Text("Running Total: \(leaderboard.runningTotal)")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(pillBackground)
                        .foregroundColor(textColor)
                        .clipShape(Capsule())
                    
                    if let nextPlayer = leaderboard.getNextPlayer() {
                        VStack(spacing: 10) {
                            Text("Next up:")
                                .font(.headline)
                                .foregroundColor(accentColors)
                            
                            Text(nextPlayer.name)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(pillBackground)
                                .foregroundColor(textColor)
                                .clipShape(Capsule())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(20)
                .background(backgroundColor)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
        .onChange(of: localNetwork.message) { _, newValue in
            message = newValue
        }
        .onAppear {
            localNetwork.startAdvertising()
        }
        .onDisappear {
            localNetwork.stopAdvertising()
        }
    }
}

#Preview {
    ContentView()
}
