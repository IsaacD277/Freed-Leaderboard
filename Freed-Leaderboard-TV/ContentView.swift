import SwiftUI

let backgroundColor = Color(red: 0.2, green: 0.3, blue: 0.5)      // Deep Blue
let accentColors = Color(red: 1.0, green: 0.7, blue: 0.2)          // Sunny Orange
let pillBackground = Color(red: 0.95, green: 0.95, blue: 0.98)   // Off-White
let dividerColor = accentColors         // Sunny Orange
let textColor = backgroundColor

struct ContentView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
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
        .environment(LeaderboardData(players: Player.samplePlayers, runningTotal: 500))
}
