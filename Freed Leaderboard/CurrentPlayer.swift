//
//  CurrentPlayer.swift
//  Freed Leaderboard
//
//  Created by Noah Smith on 1/8/26.
//


import SwiftUI

let backgroundColor = Color(red: 0.2, green: 0.3, blue: 0.5)      // Deep Blue
let accentColors = Color(red: 1.0, green: 0.7, blue: 0.2)          // Sunny Orange
let pillBackground = Color(red: 0.95, green: 0.95, blue: 0.98)   // Off-White
let dividerColor = accentColors         // Sunny Orange
let textColor = backgroundColor





struct QuickAddButton: View {
    let amount: Int
    let action: (Int) -> Void

    var body: some View {
        Button("\(amount > 0 ? "+" : "-")\(amount)") {
            action(amount)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(pillBackground)
        .foregroundStyle(textColor)
        .clipShape(Capsule())
        
        
        
    }
}

struct CustomNumberPad: View {
    @Binding var value: String
    
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
                    value = "0"
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct NumberButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.system(size: 30, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(pillBackground)
                .foregroundStyle(textColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct CurrentPlayerView: View {
    @Environment(LeaderboardData.self) private var leaderboardData
    @State var player: Player
    @State var currentRoundScore: Int = 0
    @State var customAdd: String = "0"
    @FocusState private var keyboardFocus: Bool
    
    func handleScoreChange(amount: Int) {
        currentRoundScore += amount
    }
    
    var body: some View {
        
        VStack() {
            Text("\(player.name) is Up")
                .font(.title)
                .bold()
                .padding(.top, 20)
                
            Spacer()
            
            Text("Current Score: \(player.getScore())")
                .font(.title3)
                .bold()
            
            Spacer()
                
                
            
            Text("\(currentRoundScore)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .bold()
            
            Spacer()
            
            HStack(spacing: 20) {
                QuickAddButton(amount: 50, action: handleScoreChange)
                QuickAddButton(amount: 100, action: handleScoreChange)
                QuickAddButton(amount: 200, action: handleScoreChange)
                QuickAddButton(amount: 300, action: handleScoreChange)
            }
            .padding(.horizontal, 20)
            
            HStack( spacing:20) {
                
                QuickAddButton(amount: 400, action: handleScoreChange)
                QuickAddButton(amount: 500, action: handleScoreChange)
                QuickAddButton(amount: 600, action: handleScoreChange)
                QuickAddButton(amount: 750, action: handleScoreChange)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            HStack() {
                TextField("", text: $customAdd)
                .onAppear { keyboardFocus = true }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .font(.system(size: 45, weight: .bold, design: .rounded))
                .background(pillBackground)
                .foregroundStyle(textColor)
                .tint(accentColors)
                .onChange(of: customAdd) { oldValue, newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    
                    // Convert to Int and back to String to remove leading zeros
                    if let number = Int(filtered) {
                        customAdd = String(number)
                    } else {
                        customAdd = "0" // Fallback for empty or invalid input
                    }
                }
                .clipShape(Capsule())
                

                VStack(spacing:5) {
                    Button("+") {
                        handleScoreChange(amount: Int(customAdd) ?? 0);
                        customAdd = ""
                    }
                    .font(.system(size: 35))
                    .frame(width: 100)
                    .frame(maxHeight: .infinity)
                    .background(Color.green)
                    .foregroundStyle(textColor)
                    .clipShape(Capsule())
                    
                    Button("-") {
                        handleScoreChange(amount: -(Int(customAdd) ?? 0));
                        customAdd = ""
                    }
                    .font(.system(size: 35))
                    .frame(width: 100)
                    .frame(maxHeight: .infinity)
                    .background(Color.red)
                    .foregroundStyle(textColor)
                    .clipShape(Capsule())
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 100)
            .padding(.horizontal, 20)
            
            Spacer()
            
            CustomNumberPad(value: $customAdd)
            
            Spacer()
            
            HStack() {
                Button("Back") {
                    
                }
                .padding(20)
                .background(pillBackground)
                .foregroundStyle(textColor)
                .clipShape(Capsule())
                
                Spacer()
                
                Button("Next") {
                    
                }
                .padding(20)
                .background(pillBackground)
                .foregroundStyle(textColor)
                .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            
            
            

            
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(backgroundColor)
        .foregroundStyle(accentColors)
        
    }
        
    
}
    

#Preview {
    CurrentPlayerView(player: Player.example)
        .environment(LeaderboardData())
}

