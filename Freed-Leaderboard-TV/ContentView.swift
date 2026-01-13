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
                        Text("Family Reunion 2026 Edition")
                            .foregroundStyle(.accent)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            
                        Spacer()
                        Text("Please connect an iPhone to control the leaderboard")
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundStyle(.accent)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
                    .background(Color.background)
                    .onAppear {
                        localNetwork.startAdvertising()
                        print("Started Advertising")
                    }
                } else {
                    LeaderboardView()
                        .onAppear {
                            localNetwork.stopAdvertising()
                            print("Stopped Advertising")
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}
