import SwiftUI
import MultipeerConnectivity

struct GameSetup: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @State private var isAddingNewPlayer = false
    @State private var isConnectingToDevice = false
    @State private var newPlayer = Player("")
    @State private var peerID: MCPeerID? = nil
    @Binding var localNetwork: LocalNetworkSessionCoordinator

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
                    print(localNetwork.connectedDevices)
                    // Encodes the LeaderboardData to "Data" type and sends to the session
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let data = try? encoder.encode(leaderboardData)
//                    print(String(data: data!, encoding: .utf8) ?? "Had to force unwrap")
                    try? localNetwork.sendData(peerID: peerID!, message: data!)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            ToolbarItem {
                Button {
                    isConnectingToDevice = true
                } label: {
                    if peerID == nil {
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
                ConnectionView(localNetwork: $localNetwork, peer: $peerID)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
}
