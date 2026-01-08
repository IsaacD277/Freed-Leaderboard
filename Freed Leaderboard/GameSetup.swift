import SwiftUI
import MultipeerConnectivity

struct GameSetup: View {
    @EnvironmentObject var leaderboardData: LeaderboardData
    @State private var isAddingNewPlayer = false
    @State private var isConnectingToDevice = false
    @State private var newPlayer = Player()
    @State private var peerID: MCPeerID? = nil
    let localNetwork: NSObject

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
                    newPlayer = Player()
                    isAddingNewPlayer = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem {
                Button {
                    // Encodes the LeaderboardData to "Data" type and sends to the session
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let data = try? encoder.encode(leaderboardData)
                    print(String(data: data!, encoding: .utf8) ?? "Had to force unwrap")
                    // try? localNetwork.sendData(peerID: peerID, message: data!)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            ToolbarItem {
                Button {
                    isConnectingToDevice = true
                } label: {
                    Image(systemName: "tv.badge.wifi.fill")
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
                ConnectionView(peer: $peerID)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LeaderboardData())
}
