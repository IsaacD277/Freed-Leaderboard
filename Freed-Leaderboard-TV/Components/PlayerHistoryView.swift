//
//  PlayerHistoryView.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/16/26.
//

import SwiftUI

struct PlayerHistoryView: View {
    
    let player: Player
    let onClose: () -> Void
    
    @FocusState private var isCloseButtonFocused: Bool
    
    var body : some View {
        VStack(spacing:16) {
            Text("\(player.name)")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.accent)
            
            Text("Total: \(player.getScore())")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pill)
                .foregroundColor(Color.background)
                .clipShape(Capsule())
            
            VStack() {
                ForEach(Array(player.history.indices.reversed()), id: \.self) {index in
                    let value = player.history[index]
                    let runningTotal = player.history[0...index].reduce(0, +)
                    
                    HStack {
                        Text("\(index+1).")
                            .bold()
                        Text("\(value)")
                        
                        Spacer()
                        
                        Text("→ \(runningTotal)")
                            .bold()
                    }
                }
            }
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
            .background(Color.pill)
            .foregroundColor(Color.background)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            
            Button("Close") {
                onClose()
            }
            .buttonStyle(.plain)
            .padding()
            .background(Color.pill)
            .foregroundColor(Color.background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isCloseButtonFocused ? Color.blue : Color.clear, lineWidth: 6)
                    .padding(-3) // Offset to place border outside
            )
            .focused($isCloseButtonFocused)
            .scaleEffect(isCloseButtonFocused ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isCloseButtonFocused)
            .padding(.top, 50)
            
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    PlayerHistoryView(player: Player.example) {
        print("Close tapped")
    }
}
