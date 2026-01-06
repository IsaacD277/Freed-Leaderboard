//
//  CustomKeyboard.swift
//  Freed Leaderboard
//
//  Created by Isaac D2 on 3/7/24.
//

import SwiftUI

extension TextField {
    @ViewBuilder
    func inputView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background {
                SetTFKeyboard(keyboardContent: content())
            }
    }
    
    fileprivate struct SetTFKeyboard<Content: View>: UIViewRepresentable {
        var keyboardContent: Content
        @State private var hostingController: UIHostingController<Content>?
        func makeUIView(context: Context) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            DispatchQueue.main.async {
                if let textFieldContainerView = uiView.superview?.superview {
                    if let textField = textFieldContainerView.findTextField {
                        if textField.inputView == nil {
                            hostingController = UIHostingController(rootView: keyboardContent)
                            hostingController?.view.frame = .init(origin: .zero, size: hostingController?.view.intrinsicContentSize ?? .zero)
                            // Setting TextField Input view as our SwiftUI view
                            textField.inputView = hostingController?.view
                        } else {
                            // Updating Hosting Content
                            hostingController?.rootView = keyboardContent
                        }
                    } else {
                        print("Failed to find TextField")
                    }
                }
            }
        }
    }
}
// Making a keyboard
// https://www.youtube.com/watch?v=jNpdpO32Pjs

#Preview {
    ContentView()
}

// Extracting TextField From the Subviews
fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
    
    // Finding the UIView is TextField or Not
    var findTextField: UITextField? {
        if let textField = allSubViews.first(where: { view in
            view is UITextField
        }) as? UITextField {
            return textField
        }
        
        return nil
    }
}

