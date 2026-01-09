//
//  CustomNumberPad.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/8/26.
//

import SwiftUI

struct CustomNumberPad: View {
    @Binding var value: String
    @Binding var roundValue: Int
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...9, id: \.self) { number in
                    NumberButton(number: "\(number)") {
                        if value == "0" {
                            value = "\(number)"
                        } else {
                            value += "\(number)"
                        }
                    }
                }
                
                NumberButton(number: "⌫") {
                    if value.count > 1 {
                        value.removeLast()
                    } else {
                        value = "0"
                    }
                }
                
                NumberButton(number: "0") {
                    if value != "0" {
                        value += "0"
                    }
                }
                
                NumberButton(number: "C") {
                    if value == "0" {
                        roundValue = 0
                    }
                    value = "0"
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
