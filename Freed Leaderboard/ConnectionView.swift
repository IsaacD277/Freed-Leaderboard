//
//  Connection.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/7/26.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(localNetwork.connectedDevices), id: \.self) { peerID in
                        HStack {
                            Text(peerID.displayName)
                        }
                        .onTapGesture {
                            try? localNetwork.broadcastData(leaderboardData)
                            leaderboardData.saveLocally()
                        }
                    }
                } header: {
                    Text("Connected")
                }
                Section {
                    ForEach(Array(localNetwork.otherDevices), id: \.self) { peerID in
                        HStack {
                            Text(peerID.displayName)
                            Spacer()
                            Button {
                                localNetwork.invitePeer(peerID: peerID)
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                } header: {
                    Text("On my network")
                }
            }
            .navigationTitle("Connect to TV")
        }
        .onAppear {
            localNetwork.startBrowsing()
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}
