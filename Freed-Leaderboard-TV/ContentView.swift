//
//  ContentView.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @State private var message: String = ""
    @State private var localNetwork = LocalNetworkSessionCoordinator()
    @State private var showAlert = true
    @State private var alertText = ""
    var body: some View {
        NavigationStack {
            VStack {
                Text(message)
            }
            .navigationTitle("Freed Leaderboard")
        }
        .onChange(of: localNetwork.message) { _, newValue in
            message = newValue
        }
        .onAppear {
            localNetwork.startAdvertising()
        }
        .onDisappear {
            localNetwork.stopAdvertising()
        }
    }
}

#Preview {
    ContentView()
}
