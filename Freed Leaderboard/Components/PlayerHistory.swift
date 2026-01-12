//
//  PlayerHistory.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/11/26.
//

import SwiftUI


struct PlayerHistory: View {
    let history: [Int]
    
    var body: some View {
        ForEach(Array(history.indices.reversed()), id: \.self) { index in
            let value = history[index]
            let runningTotal = history[0...index].reduce(0, +)
            
            HStack {
                Text("\(index+1).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .bold()
                Text("\(value)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("→ \(runningTotal)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    PlayerHistory(history: Player.example.history)
}
