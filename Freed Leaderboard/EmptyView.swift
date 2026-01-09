//
//  EmptyView.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 1/9/26.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Tap anywhere to start")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                    .foregroundStyle(Color.accent)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.background)
        }
        
    }
}

#Preview {
    EmptyView()
}
