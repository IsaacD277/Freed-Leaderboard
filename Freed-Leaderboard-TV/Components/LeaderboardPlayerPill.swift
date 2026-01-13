//
//  LeaderboardPlayerPill.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/8/26.
//

import Foundation
import SwiftUI

struct LeaderboardPlayerPill: View {
    let place: Int
    let name: String
    let score: Int
    let active: Bool
    
    var body: some View {
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
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(.horizontal)
        .background(active ? Color.accent:  Color.pill)
        .foregroundColor(Color.background)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(Color.accent, lineWidth: active ? 6 : 0)
        )
        .animation(.easeInOut(duration: 0.2), value: active)
        
    }
}

#Preview {
    VStack(spacing: 20) {
        LeaderboardPlayerPill(place: 1, name: "John", score: 5000, active: false)
        LeaderboardPlayerPill(place: 2, name: "Jane", score: 4500, active: true)
    }
    .padding()
}
