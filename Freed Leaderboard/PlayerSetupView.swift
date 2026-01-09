import SwiftUI
import MultipeerConnectivity

struct PlayerSetupView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
//    @State private var isAddingNewPlayer = false
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
            }
            .navigationTitle("Add Players")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
            }
            .sheet(isPresented: $isConnectingToDevice) {
                NavigationView {
                    ConnectionView()
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        leaderboardData.players.remove(atOffsets: offsets)
        try? localNetwork.broadcastData(leaderboardData)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        leaderboardData.players.move(fromOffsets: source, toOffset: destination)
        try? localNetwork.broadcastData(leaderboardData)
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}
