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
        .padding(.horizontal, 20)
        .background(Color.pill)
        .foregroundColor(Color.background)
        .clipShape(Capsule())
    }
}

#Preview {
    LeaderboardPlayerPill(place: 1, name: "John", score: 5000)
}
