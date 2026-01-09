import SwiftUI
import MultipeerConnectivity

struct GameSetup: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    @State private var isAddingNewPlayer = false
    @State private var isConnectingToDevice = false
    @State private var newPlayer = Player("")

    var body: some View {
        List {
            ForEach(leaderboardData.players) { player in
                Text(player.name)
            }
        }
        .navigationTitle("Game Setup")
        .toolbar {
            ToolbarItem {
                Button {
                    newPlayer = Player("")
                    isAddingNewPlayer = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem {
                Button {
                    try? localNetwork.broadcastData(leaderboardData)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            ToolbarItem {
                Button {
                    isConnectingToDevice = true
                } label: {
                    if localNetwork.connectedDevices.count == 0 {
                        Image(systemName: "tv.badge.wifi")
                    } else {
                        Image(systemName: "tv.badge.wifi.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingNewPlayer) {
            NavigationView {
                PlayerEditor(player: $newPlayer, isNew: true)
            }
        }
        .sheet(isPresented: $isConnectingToDevice) {
            NavigationView {
                ConnectionView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
        .environment(LocalNetworkSessionCoordinator())
}
