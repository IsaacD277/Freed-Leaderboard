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
    @State private var isConnected = false

    
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
//                                    .task(delaySend)
                                isConnected.toggle()
//                                try? await Task.sleep(nanoseconds: 1_000)
//                                try? localNetwork.sendData(peerID: peerID, message: leaderboardData)
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
//        .onChange(of: isConnected) {
//            Task {
//                await delaySend()
//            }
//        }
    }
    
//    private func delaySend() async {
//        print("Inside the delayed send")
//        try? await Task.sleep(for: .milliseconds(100))
//        print("after sleep")
//        try? localNetwork.broadcastData(leaderboardData)
//        print("After send")
//    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData(players: Player.samplePlayers))
        .environment(LocalNetworkSessionCoordinator())
}
