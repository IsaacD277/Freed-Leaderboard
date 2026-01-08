import SwiftUI

let samplePlayers: [Player] = [
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

let backgroundColor = Color(red: 0.2, green: 0.3, blue: 0.5)      // Deep Blue
let accentColors = Color(red: 1.0, green: 0.7, blue: 0.2)          // Sunny Orange
let pillBackground = Color(red: 0.95, green: 0.95, blue: 0.98)   // Off-White
let dividerColor = accentColors         // Sunny Orange
let textColor = backgroundColor

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
    @Environment(LeaderboardData.self) private var leaderboardData
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
    @State private var leaderboard = LeaderboardData(players: samplePlayers)
    @State private var decodedData : LeaderboardData?
    
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
                        LeaderboardGrid(players: leaderboardData.getLeaderboard())
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
                    CurrentPlayerStats(player: leaderboardData.getCurrentPlayer())
                    
                    Spacer()
                    
                    Text("Running Total: \(leaderboardData.runningTotal)")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(pillBackground)
                        .foregroundColor(textColor)
                        .clipShape(Capsule())
                    
                    if let nextPlayer = leaderboardData.getNextPlayer() {
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
        .onChange(of: localNetwork.leaderboardData) { _, newValue in
            print("RECEIVED")
            let data = newValue
            do {
                decodedData = try JSONDecoder().decode(LeaderboardData.self, from: data)
                if let decodedData {
                    @Bindable var leaderboardData = leaderboardData
                    leaderboardData.players = decodedData.players
                }
            } catch {
                print("Error")
                print(error)
            }
        }
        .onAppear {
            localNetwork.startAdvertising()
            localNetwork.startBrowsing()
        }
        .onDisappear {
            localNetwork.stopAdvertising()
            localNetwork.stopBrowsing()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
}
