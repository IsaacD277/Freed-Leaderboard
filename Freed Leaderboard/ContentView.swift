//
//  ContentView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/2/26.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @Environment(LocalNetworkSessionCoordinator.self) private var localNetwork
    
    @State private var isConnectingToDevice: Bool = false
    @State private var isSettingUpPlayers: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if leaderboardData.players.isEmpty {
                    EmptyView()
                        .onTapGesture {
                            isSettingUpPlayers = true
                        }
                } else {
                    CurrentPlayerView(player: leaderboardData.players.first ?? Player(""))
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isConnectingToDevice = true
                    } label: {
                        if localNetwork.connectedDevices.count == 0 {
                            Image(systemName: "tv.badge.wifi")
                        } else {
                            Image(systemName: "tv.badge.wifi.fill")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isSettingUpPlayers = true
                    } label: {
                        Image(systemName: "person")
                    }
                }
            }
            .sheet(isPresented: $isConnectingToDevice) {
                NavigationView {
                    ConnectionView()
                }
            }
            .sheet(isPresented: $isSettingUpPlayers) {
                NavigationView {
                    PlayerSetupView()
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
