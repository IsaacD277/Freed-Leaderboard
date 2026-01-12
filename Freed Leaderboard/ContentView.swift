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
    @State private var isViewingLeaderboard : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if leaderboardData.players.isEmpty {
                    EmptyView()
                        .onTapGesture {
                            isSettingUpPlayers = true
                        }
                } else {
                    if (isViewingLeaderboard) {
                        LeaderboardView()
                    } else {
                        CurrentPlayerView(player: leaderboardData.getCurrentPlayer())
                    }
                }
            }
            .toolbar {
                ToolbarItem{
                    Button {
                        isViewingLeaderboard.toggle()
                    } label: {
                        isViewingLeaderboard ? Image(systemName: "dice"): Image(systemName: "list.number")
                    }
                }
                ToolbarItem {
                    Button {
                        isConnectingToDevice = true
                    } label: {
                        if localNetwork.connectedDevices.count == 0 {
                            Image(systemName: "tv.badge.wifi")
                                .foregroundStyle(Color.background)
                        } else {
                            Image(systemName: "tv.badge.wifi.fill")
                                .foregroundStyle(Color.background)
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isSettingUpPlayers = true
                    } label: {
                        Image(systemName: "person.3")
                            .foregroundStyle(Color.background)
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
