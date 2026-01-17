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
    @FocusState private var focusedHistoryIndex: Int?
    
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
            
            ScrollView() {
                ForEach(Array(player.history.indices.reversed()), id: \.self) {index in
                    let value = player.history[index]
                    let runningTotal = player.history.prefix(index + 1).reduce(0, +)
                    
                    HStack(spacing: 0) {
                        Text("\(index+1).")
                            .frame(width:100)
                            .bold()
            
                        Text("\(value)")
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        Text("→ \(runningTotal)")
                            .bold()
                    }
                    .contentShape(Rectangle())
                    .focused($focusedHistoryIndex, equals: index)
                    .focusable()
                    .onAppear { if focusedHistoryIndex == nil { focusedHistoryIndex = player.history.indices.last } }
                }
            }
            .font(.title3.monospacedDigit())
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
            .background(Color.pill)
            .foregroundColor(Color.background)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.background)
        .onAppear { if focusedHistoryIndex == nil { focusedHistoryIndex = player.history.indices.last } }
    }
}

#Preview {
    PlayerHistoryView(player: Player.example) {
        print("Close tapped")
    }
}
