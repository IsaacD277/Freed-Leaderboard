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
    
    var body: some View {
        Group {
            if player != nil {
                VStack(spacing: 15) {
                    Text("\(player!.name) is up")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .foregroundStyle(.accent)
                    
                    Text("Score: \(player!.getScore())")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.pill)
                        .foregroundColor(Color.background)
                        .clipShape(Capsule())
                    
                    Text("Previous 3 Turns:")
                        .font(.headline)
                        .foregroundColor(Color.accent)
                        .padding(.top, 10)
                    
                    HStack(spacing: 15) {
                        ForEach(Array(player!.getLast3Turns()), id: \.self) { l in
                            Text("\(l)")
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color.pill)
                                .foregroundColor(Color.background)
                                .clipShape(Capsule())
                        }
                    }
                }
            } else {
                Text("No Player")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color.pill)
                    .foregroundColor(Color.background)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    CurrentPlayerStats(player: Player.example)
}
