import SwiftUI

struct GameSetup: View {
    @environmentObject var leaderboardData: LeaderboardData
    @State private var isAddingNewPlayer = false
    @State private var newPlayer = Player()

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
        }
        .sheet(isPresented: $isAddingNewPlayer) {
            NavigationView {
                PlayerEditor(player: $newPlayer, isNew: true)
            }
        }
    }
}

#Preview {
    GameSetup()
}