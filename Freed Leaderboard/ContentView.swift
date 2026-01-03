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
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(localNetwork.connectedDevices), id: \.self) { peerID in
                        HStack {
                            Text(peerID.displayName)
                            Spacer()
                            Button {
                                try? localNetwork.sendHello(peerID: peerID, message: message)
                            } label: {
                                Image(systemName: "paperplane")
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
//            localNetwork.startAdvertising()
            debugPrint(localNetwork.allDevices)
        }
        .onDisappear {
            localNetwork.stopBrowing()
//            localNetwork.stopAdvertising()
        }
    }
}

#Preview {
    ContentView()
}
