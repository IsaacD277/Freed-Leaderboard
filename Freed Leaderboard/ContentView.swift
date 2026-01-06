//
//  ContentView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = false
    @State private var alertText = ""
    // let player = Player(id: UUID.init(), name: "Noah", score: 5100, history: [2500, 0, 2600])
    // @State private var players: [Player] = []
    
    var body: some View {
        NavigationStack {
            List {
//                Section {
//                    Button("Add Player") {
//                    
//                    }
//                }
                Section {
                    ForEach(Array(localNetwork.connectedDevices), id: \.self) { peerID in
                        HStack {
                            Text(peerID.displayName)
                            Spacer()
//                            Button {
//                                try? localNetwork.sendHello(peerID: peerID, message: message)
//                            } label: {
//                                Image(systemName: "paperplane")
//                            }
                            Button {
                                let encoder = JSONEncoder()
                                encoder.outputFormatting = .prettyPrinted
                                
                                let player1 = Player(id: UUID.init(), name: "Noah", score: 5100, history: [2499, 0, 2600])
                                let player2 = Player(id: UUID.init(), name: "Isaac", score: 5099, history: [2500, 0, 2600])
                                let player3 = Player(id: UUID.init(), name: "Grace", score: 7500, history: [2500, 2400, 2600])
                                let player3 = Player(id: UUID.init(), name: "Audrey", score: 7501, history: [2500, 2401, 2600])
                                
                                let currentLeaderboard = leaderboardData(players: [player1, player2, player3])
                                
                                let data = try? encoder.encode(currentLeaderboard)
                                print(String(data: data!, encoding: .utf8) ?? "Had to force unwrap")
                                try? localNetwork.sendData(peerID: peerID, message: data!)
                            } label: {
                                Image(systemName: "paperplane.fill")
                            }
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
                Section {
                    TextField("Send a message", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Freed Controller")
        }
        .onChange(of: localNetwork.message) { _, newValue in
            alertText = newValue
            showAlert = true
        }
        .alert("Received a message", isPresented: $showAlert) {
            
        } message: {
            Text(alertText)
        }
        .onAppear {
            localNetwork.startBrowsing()
            localNetwork.startAdvertising()
            debugPrint(localNetwork.allDevices)
        }
        .onDisappear {
            localNetwork.stopBrowsing()
            localNetwork.stopAdvertising()
        }
    }
}

#Preview {
    ContentView()
}
