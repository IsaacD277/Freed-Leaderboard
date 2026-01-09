import SwiftUI

struct ContentView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    
    var body: some View {
        NavigationStack {
            VStack {
                if localNetwork.connectedDevices.isEmpty {
                    VStack {
                        Spacer()
                        Text("Freed Leaderboard")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundStyle(.accent)
                        Spacer()
                        Text("Family Reunion 2026 Edition")
                            .foregroundStyle(.accent)
                            .fontWeight(.bold)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(20)
                    .background(Color.background)
                } else {
                    LeaderboardView()
                }
            }
        }
        .onAppear {
            localNetwork.startAdvertising()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers, runningTotal: 500))
        .environment(LocalNetworkSessionCoordinator())
}
