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
    @State var isStarted = false
    var onAutoAdd = {}
    
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
                        self.onAutoAdd()
                    }
                }
                
                NumberButton(number: "C") {
                    if value == "0" {
                        roundValue = 0
                    }
                    value = "0"
                }
                
                NumberButton(number: "0") {
                    if value != "0" {
                        value += "0"
                    }
                    self.onAutoAdd()
                }

                NumberButton(number: "⌫") {
                    if value.count > 1 {
                        value.removeLast()
                    } else {
                        value = "0"
                    }
                    self.onAutoAdd()
                }
                
            }
        }
        .padding(.horizontal)
    }
    
    func onAutoAdd(_ callback: @escaping () -> ()) -> some View {
        CustomNumberPad(value: self.$value, roundValue: self.$roundValue, onAutoAdd: callback)
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var value: String = "0"
        @State private var roundValue: Int = 0
        var body: some View {
            CustomNumberPad(value: $value, roundValue: $roundValue)
        }
    }
    return PreviewWrapper()
}
