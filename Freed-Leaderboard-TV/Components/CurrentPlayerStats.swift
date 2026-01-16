//
//  CurrentPlayerStats.swift
//  Freed-Leaderboard-TV
//
//  Created by Isaac D2 on 1/8/26.
//

import Foundation
import SwiftUI

struct CurrentPlayerStats: View {
    let player: Player?
    let round: Int
    
    var body: some View {
        Group {
            if player != nil {
                VStack(spacing: 15) {
                    Text("\(player!.name) is up")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.accent)
                    
                    Text("Total: \(player!.getScore())")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pill)
                        .foregroundColor(Color.background)
                        .clipShape(Capsule())
                    if (round > 1) {
                        if (round == 2) {
                            Text("Previous Turn:")
                                .font(.headline)
                                .foregroundColor(Color.accent)
                        } else if (round == 3) {
                            Text("Previous 2 Turns:")
                                .font(.headline)
                                .foregroundColor(Color.accent)
                        } else {
                            Text("Previous 3 Turns:")
                                .font(.headline)
                                .foregroundColor(Color.accent)
                        }
                        
                        HStack(spacing: 15) {
                            ForEach(Array(player!.getLast3Turns(before: round-1)), id: \.self) { l in
                                Text("\(l)")
                                    .font(.title3)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical)
                                    .background(Color.pill)
                                    .foregroundColor(Color.background)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            } else {
                Text("No Player")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pill)
                    .foregroundColor(Color.background)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    CurrentPlayerStats(player: Player.example, round: 1)
}
