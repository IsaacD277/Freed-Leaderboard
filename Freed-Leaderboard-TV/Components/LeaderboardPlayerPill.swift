//
//  LeaderboardPlayerPill.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/8/26.
//

import Foundation
import SwiftUI

struct PlayerPillButtonStyle: ButtonStyle {
    let active: Bool
    @Environment(\.isFocused) var isFocused
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(.horizontal)
            .background(active ? Color.accent : Color.pill)
            .foregroundColor(Color.background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 6)
                    .padding(-3)
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: active)
    }
}

struct LeaderboardPlayerPill: View {
    let place: Int
    let name: String
    let score: Int
    let active: Bool
    let onSelect: (() -> Void)?
    
    var body: some View {
        Button {
            onSelect?()
        } label: {
            HStack(spacing: 8) {
                Text("#\(place)")
                    .font(.headline)
                    .lineLimit(1)
                    .bold()
                    .layoutPriority(2)
                
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(0)
                
                Text("\(score)")
                    .font(.headline)
                    .lineLimit(1)
                    .bold()
                    .monospacedDigit()
                    .layoutPriority(1)
            }
        }
        .buttonStyle(PlayerPillButtonStyle(active: active))
    }
}

#Preview {
    VStack(spacing: 20) {
        LeaderboardPlayerPill(place: 1, name: "John", score: 5000, active: false, onSelect: {})
        LeaderboardPlayerPill(place: 2, name: "Jane", score: 4500, active: true, onSelect: {})
    }
    .padding()
}
