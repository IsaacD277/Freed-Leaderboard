//
//  Connection.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/7/26.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    @Binding var localNetwork: LocalNetworkSessionCoordinator
    @Binding var peer: MCPeerID?

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(localNetwork.connectedDevices), id: \.self) { peerID in
                        HStack {
                            Text(peerID.displayName)
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
                                peer = peerID
                                print(peer!.displayName)
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
            print("Browsing")
            localNetwork.startAdvertising()
            print("Advertising")
        }
        .onDisappear {
//            localNetwork.stopBrowsing()
//            print("Done browsing")
        }
    }
}

#Preview {
    ContentView()
        .environment(LeaderboardData())
}
