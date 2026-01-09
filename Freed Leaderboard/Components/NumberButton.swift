//
//  NumberButton.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/8/26.
//

import SwiftUI

struct NumberButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.system(size: 30, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.pill)
                .foregroundStyle(Color.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
