import SwiftUI

struct PlayerDetail: View {
    @Binding var player: Player
    @State private var text: String = ""
    let isEditing: Bool
    
    var body: some View {
        List {
            HStack {
                if isEditing {
                    TextField("New Player", text: $player.name)
                        .font(.title2)
                } else {
                    Text(player.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            print(player.name)
        }
    }
}


#Preview {
    PlayerDetail(player: .constant(Player.example), isEditing: true)
}
