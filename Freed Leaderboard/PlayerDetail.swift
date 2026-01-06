import SwiftUI

struct PlayerDetail: View {
    @Binding var player: Player
    let isEditing: Bool
    
    var body: some View {
        List {
            HStack {
                if isEditing {
                    TextField("New Player", text: $player.Name)
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
    }
}



struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetail(player: .constant(Player.example), isEditing: true)
    }
}
