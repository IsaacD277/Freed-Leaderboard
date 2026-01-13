//
//  QuickAddButton.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/8/26.
//

import SwiftUI

struct QuickAddButton: View {
    let amount: Int
    let action: (Int) -> Void
    
    var body: some View {
        Button("\(amount > 0 ? "+" : "-")\(amount)") {
            action(amount)
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(Color.pill)
        .foregroundStyle(Color.background)
        .clipShape(Capsule())
        
        
        
    }
}

#Preview {
    QuickAddButton(amount: 100) { _ in }
}
