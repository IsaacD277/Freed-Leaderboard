import SwiftUI
import MultipeerConnectivity

struct PlayerSetupView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    
    @State private var isResettingScores = false
    @State private var isConnectingToDevice = false
    @State private var newPlayer = Player("")
    @State private var playerName: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(leaderboardData.players) { player in
                    Text(player.name)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: move)
                TextField("New Player", text: $playerName)
            }
            .onSubmit {
                leaderboardData.addPlayer(newPlayer: Player(playerName))
                try? localNetwork.broadcastData(leaderboardData)
                playerName = ""
                leaderboardData.saveLocally()
            }
            .navigationTitle("Add Players")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem {
                    Button {
                        isResettingScores = true
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .sheet(isPresented: $isConnectingToDevice) {
                NavigationView {
                    ConnectionView()
                }
            }
            .confirmationDialog("Reset scores for all players?", isPresented: $isResettingScores) {
                Button("Reset", role: .destructive) {
                    for i in 0..<leaderboardData.players.count {
                        leaderboardData.players[i].resetScore()
                    }
                    leaderboardData.currentPlayerIndex = 0
                    leaderboardData.runningTotal = 0
                    leaderboardData.round = 1
                    try? localNetwork.broadcastData(leaderboardData)
                    leaderboardData.saveLocally()
                }
                Button("Cancel", role: .cancel) {
                    // Do nothing
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        leaderboardData.players.remove(atOffsets: offsets)
        try? localNetwork.broadcastData(leaderboardData)
        leaderboardData.saveLocally()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        leaderboardData.players.move(fromOffsets: source, toOffset: destination)
        try? localNetwork.broadcastData(leaderboardData)
        leaderboardData.saveLocally()
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}
