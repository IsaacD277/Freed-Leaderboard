import SwiftUI

struct EventEditor: View {
    @Binding var player: Player
    var isNew = false

    @State private var isDeleted = false
    @EnvironmentObject var leaderboardData: LeaderboardData
    @Environment(\.dismiss) private var dismiss

    @State private var playerCopy = Player()
    @State private var isEditing = false

    private var isPlayerDeleted: Bool {
        !leaderboardData.exists(player) && !isNew
    }

    var body: some View {
        VStack {
            PlayerDetail(player: $playerCopy, isEditing: isNew ? true : isEditing)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if isNew {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem {
                        Button {
                            if isNew {
                                leaderboardData.players.append(playerCopy)
                                dismiss()
                            } else {
                                if isEditing && !isDeleted {
                                    print("Done, saving any changes to \(player.name)")
                                    withAnimation {
                                        player = playerCopy // Put edits (if any) back in the store.
                                    }
                                }
                                isEditing.toggle()
                            }
                        } label: {
                            Text(isNew ? "Add" : (isEditing ? "Done" : "Edit"))
                        }
                    }
                }
                .onAppear {
                    playerCopy = player // Grab a copy in case we decide to make edits.
                }
                .disabled(isEventDeleted)
            
            if isEditing && !isNew {

                Button(role: .destructive, action: {
                    isDeleted = true
                    dismiss()
                    leaderboardData.delete(player)
                }, label: {
                    Label("Delete Event", systemImage: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                })
                    .padding()
            }
        }
        .overlay(alignment: .center) {
            if isEventDeleted {
                Color(UIColor.systemBackground)
                Text("Event Deleted. Select an Event.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    PlayerEditor(player: .constant(Player()))
}